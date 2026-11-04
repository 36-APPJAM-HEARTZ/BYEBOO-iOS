//
//  ListDetailArrangementViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 10/28/26.
//

import UIKit

/// iPhone Duo 대응: 목록(primary) - 상세(secondary)
/// - 탭 바의 탭 하나를 감싸고, 목록과 상세가 각자 UINavigationController를 가짐
/// - 가로가 더 넓은 화면(펼친 Duo 내부 디스플레이)에서는 목록 leading / 상세 trailing
/// - 세로로는 나누지 않으므로 외부 디스플레이, 일반 iPhone, Split View에서는 목록 스택 하나만 보임
/// - 나뉨 상태가 바뀌면 상세 스택을 옮김
///   - 나뉠 때: 목록 스택의 root 이후 화면들을 상세 스택으로
///   - 합쳐질 때: 상세 스택의 화면들을 목록 스택 뒤로
/// - 화면에서는 showDetail(_:) / resetDetail()만 사용. 상세 안에서의 이동은 기존처럼 push / pop
/// - iOS 27.1 미만에서는 UINavigationController 하나
extension UIViewController {
    /// 탭에 넣을 컨테이너
    func embeddedInListDetail() -> UIViewController {
        guard #available(iOS 27.1, *) else { return ByeBooNavigationController(rootViewController: self) }
        return ListDetailArrangementViewController(root: self)
    }

    /// 탭 컨테이너의 목록 쪽 네비게이션 컨트롤러
    var listNavigationController: UINavigationController? {
        if #available(iOS 27.1, *), let arrangement = self as? ListDetailArrangementViewController {
            return arrangement.primaryNavigationController
        }
        return self as? UINavigationController
    }

    /// 상세 열기. 목록 - 상세로 나뉜 상태면 trailing에, 아니면 기존처럼 push
    func showDetail(_ viewController: UIViewController) {
        if #available(iOS 27.1, *), let arrangement = listDetailArrangement {
            arrangement.openDetail(viewController)
            return
        }
        navigationController?.pushViewController(viewController, animated: false)
    }

    /// 목록 - 상세로 나뉘어 trailing이 보이는 상태인지
    var isDetailPaneVisible: Bool {
        guard #available(iOS 27.1, *) else { return false }
        return listDetailArrangement?.isSecondaryVisible ?? false
    }

    /// trailing을 빈 화면으로 되돌림 (목록이 바뀌는 경우)
    func resetDetail() {
        guard #available(iOS 27.1, *) else { return }
        listDetailArrangement?.closeDetail()
    }

    @available(iOS 27.1, *)
    private var listDetailArrangement: ListDetailArrangementViewController? {
        sequence(first: self, next: \.parent)
            .first { $0 is ListDetailArrangementViewController } as? ListDetailArrangementViewController
    }
}

@available(iOS 27.1, *)
final class ListDetailArrangementViewController: UIArrangementViewController {

    let primaryNavigationController: UINavigationController
    private let secondaryNavigationController: UINavigationController
    private let emptyViewController = UIViewController()
    private var isSplit = false

    /// state(for:)는 처음부터 세로로 실행된 경우 오른쪽 칸을 보이는 상태로 잘못 알려주는 경우가 있어
    /// split 규칙(가로로만 나눔 = 가로가 더 넓을 때만 오른쪽 칸이 보임)으로 직접 판단
    fileprivate var isSecondaryVisible: Bool {
        view.bounds.width > view.bounds.height
    }

    init(root: UIViewController) {
        // ponytail: 빈 화면은 임시로 배경색만. 디자인 나오면 교체
        emptyViewController.view.backgroundColor = .grayscale900
        primaryNavigationController = ByeBooNavigationController(rootViewController: root)
        secondaryNavigationController = UINavigationController(rootViewController: emptyViewController)
        super.init()

        secondaryNavigationController.delegate = self

        setViewController(primaryNavigationController, for: .primary)
        setViewController(secondaryNavigationController, for: .secondary)
        updateArrangement(UISplitArrangement.split.axes(.horizontal))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 상세 화면들이 viewWillAppear에서 탭 바를 숨기는데, 탭을 전환해 돌아오면 didShow가 불리지 않으므로 여기서 다시 보여줌
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isSecondaryVisible {
            tabBarController?.tabBar.isHidden = false
        }
    }

    // arrangement에는 상태 변경 콜백이 없으므로 크기 변화와 레이아웃 시점에 직접 확인
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            self?.moveStacksIfNeeded()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        #if DEBUG
        // TODO: Duo 레이아웃 확인용 임시 로그. 확인 후 삭제
        let primaryView: UIView = primaryNavigationController.view
        let navigationBar = primaryNavigationController.navigationBar
        NSLog("[Duo] view \(view.bounds.size) safe \(view.safeAreaInsets)")
        NSLog("[Duo] primary frame \(primaryView.frame) safe \(primaryView.safeAreaInsets) top safe \(primaryNavigationController.topViewController?.view.safeAreaInsets ?? .zero)")
        NSLog("[Duo] primary navBar isHidden \(navigationBar.isHidden) navHidden \(primaryNavigationController.isNavigationBarHidden) frame \(navigationBar.frame)")
        NSLog("[Duo] secondary frame \(secondaryNavigationController.view.frame)")
        var stack: [UIView] = [primaryView]
        while let current = stack.popLast() {
            if let scrollView = current as? UIScrollView, scrollView is UICollectionView || scrollView is UITableView {
                NSLog("[Duo] \(type(of: scrollView)) frame \(scrollView.convert(scrollView.bounds, to: primaryView)) safe \(scrollView.safeAreaInsets) adjusted \(scrollView.adjustedContentInset)")
            }
            stack += current.subviews
        }
        #endif

        updatePrimaryTrailingInset()
        
        // 레이아웃 중에 네비게이션 스택을 바꾸지 않도록 다음 런루프에서 처리
        DispatchQueue.main.async { [weak self] in
            self?.moveStacksIfNeeded()
        }
    }
    
    /// 목록 칸은 창 오른쪽 끝에 닿지 않는데도 안쪽 화면에 세로 바(상태바, 탭 바) 여백이 그대로 잡혀서 상쇄
    /// (UINavigationController가 자신이 창 오른쪽 끝에 닿아 있다고 보고 여백을 넣는 것으로 보임)
    private func updatePrimaryTrailingInset() {
        let trailing = isSecondaryVisible ? view.safeAreaInsets.right : 0
        for viewController in primaryNavigationController.viewControllers
        where viewController.additionalSafeAreaInsets.right != -trailing {
            viewController.additionalSafeAreaInsets.right = -trailing
        }
        for viewController in secondaryNavigationController.viewControllers
        where viewController.additionalSafeAreaInsets.right != 0 {
            viewController.additionalSafeAreaInsets.right = 0
        }
    }

    fileprivate func openDetail(_ viewController: UIViewController) {
        #if DEBUG
        let secondaryState = state(for: .secondary)
        NSLog("[Duo] openDetail \(type(of: viewController)) secondaryState hidden \(String(describing: secondaryState?.isHidden)) axis \(String(describing: secondaryState?.splitAxis)) isSplit \(isSplit) view \(view.bounds.size) primary \(primaryNavigationController.viewControllers.count) secondary \(secondaryNavigationController.viewControllers.count)")
        #endif
        if isSecondaryVisible {
            viewController.hidesBottomBarWhenPushed = false
            secondaryNavigationController.setViewControllers([emptyViewController, viewController], animated: false)
        } else {
            primaryNavigationController.pushViewController(viewController, animated: false)
        }
    }

    fileprivate func closeDetail() {
        guard secondaryNavigationController.viewControllers.count > 1 else { return }
        secondaryNavigationController.setViewControllers([emptyViewController], animated: false)
    }

    /// 나뉨 상태가 바뀌면 상세 스택을 옮김
    private func moveStacksIfNeeded() {
        guard isSplit != isSecondaryVisible else { return }
        isSplit = isSecondaryVisible

        if isSplit {
            let primaryStack = primaryNavigationController.viewControllers
            guard primaryStack.count > 1 else { return }
            let details = Array(primaryStack.dropFirst())
            details.forEach { $0.hidesBottomBarWhenPushed = false }
            primaryNavigationController.setViewControllers([primaryStack[0]], animated: false)
            secondaryNavigationController.setViewControllers([emptyViewController] + details, animated: false)
            // 목록 스택에 있을 때 받은 음수 여백이 남아 세로 바와 겹치지 않도록 옮긴 직후 다시 계산
            updatePrimaryTrailingInset()
        } else {
            let details = Array(secondaryNavigationController.viewControllers.dropFirst())
            guard !details.isEmpty else { return }
            // 목록 스택에서는 기존처럼 상세가 탭 바를 가림
            details.forEach { $0.hidesBottomBarWhenPushed = true }
            secondaryNavigationController.setViewControllers([emptyViewController], animated: false)
            primaryNavigationController.setViewControllers(primaryNavigationController.viewControllers + details, animated: false)
        }
    }
}

@available(iOS 27.1, *)
extension ListDetailArrangementViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        // 빈 화면에서는 네비바 숨김
        navigationController.setNavigationBarHidden(viewController === emptyViewController, animated: false)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        // 상세 화면들이 viewWillAppear에서 탭 바를 숨기므로 trailing에서는 다시 보여줌
        tabBarController?.tabBar.isHidden = false
        
        if viewController === emptyViewController {
            NotificationCenter.default.post(name: .listDetailDidClose, object: nil)
        }
    }
}
