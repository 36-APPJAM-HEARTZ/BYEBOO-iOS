//
//  EmptySplitArrangementViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 10/28/26.
//

import UIKit

/// arrangement가 배경을 전체에 깔 때 숨길 화면별 배경
protocol ArrangementBackground: UIView {
    var backgroundImageView: UIImageView { get }
}

/// iPhone Duo 대응
/// - 가로가 더 넓은 화면(펼친 Duo 내부 디스플레이)에서는 기존 화면을 leading 절반에 두고 trailing 절반은 빈 화면으로 둠
/// - 세로로는 나누지 않으므로 외부 디스플레이, 일반 iPhone, Split View에서는 기존 화면만 보임
/// - iOS 27.1 미만에서는 기존 화면을 그대로 반환
extension UIViewController {
    func arrangedWithEmptyView() -> UIViewController {
        guard #available(iOS 27.1, *) else { return self }
        return SplashEmptySplitArrangementViewController(primary: self)
    }
}

@available(iOS 27.1, *)
final class SplashEmptySplitArrangementViewController: UIArrangementViewController {

    let primary: UIViewController

    init(primary: UIViewController) {
        self.primary = primary
        super.init()

        // 빈 화면은 스플래시 로고
        let splashView = SplashView()
        let emptyViewController = UIViewController()
        emptyViewController.view = splashView

        // 배경은 arrangement가 한 장으로 그리므로 빈 화면 배경은 숨김
        splashView.backgroundImageView.isHidden = true

        setViewController(primary, for: .primary)
        setViewController(emptyViewController, for: .secondary)
        updateArrangement(UISplitArrangement.split.axes(.horizontal))

        navigationItem.hidesBackButton = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 배경은 양쪽 화면에 따로 두지 않고 전체에 한 장으로 깔아 가운데에서 끊기지 않게 함
    override func viewDidLoad() {
        super.viewDidLoad()

        // arrangement가 관리하는 subview 계층은 건드리지 않고 layer에 직접 그림
        view.layer.contents = UIImage.bgDark.cgImage
        view.layer.contentsGravity = .resizeAspectFill
        view.layer.masksToBounds = true

        (primary.view as? ArrangementBackground)?.backgroundImageView.isHidden = true
    }

    override var childForStatusBarStyle: UIViewController? {
        primary
    }
}
