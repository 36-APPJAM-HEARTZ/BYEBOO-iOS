//
//  ParentQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/14/26.
//

import UIKit

final class ParentQuestViewController<T: TabItem>: BaseViewController, ToastPresentable {
    
    private let tabBar: TopTabBar
    private let containerView = UIView()
    private(set) var controllers: [UIViewController]
    private var currentViewController: UIViewController?
    private var selectedIndex: Int = 0
    
    init(items: T.AllCases) {
        self.tabBar = TopTabBar(items: Array(items))
        self.controllers = items.map { $0.viewController }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        
        guard controllers.indices.contains(selectedIndex) else { return }
        
        show(controllers[selectedIndex])
        tabBar.select(index: selectedIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bind()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleToast(_:)),
            name: .showToastMessage,
            object: nil
        )
    }
    
    override func setView() {
        view.addSubviews(
            tabBar,
            containerView
        )
    }
    
    func selectTab(index: Int) {
        guard controllers.indices.contains(index) else { return }
        
        selectedIndex = index
        show(controllers[index])
        tabBar.select(index: index)
    }
    
    func presentCompleteModal() {
        let modal = ModalBuilder(
            modalView: QuestCompleteModal(),
            action: nil,
            rootViewController: self
        )
        modal.present()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            modal.dismiss()
        }
    }
    
    @objc
    private func handleToast(_ notification: Notification) {
        guard let type = notification.userInfo?["type"] as? CommonQuestArchiveType.Action else { return }
        switch type {
        case .block:
            self.presentToastMessage(type: .block)
        case .report:
            self.presentToastMessage(type: .report)
        case .edit, .delete:
            return
        }
    }
}

extension ParentQuestViewController {
    
    private func setLayout() {
        tabBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(228.adjustedW)
            $0.height.equalTo(28.adjustedH)
        }
        containerView.snp.makeConstraints {
            $0.top.equalTo(tabBar.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        tabBar.didTap = { [weak self] index in
            guard let self,
                  index >= 0 && index < controllers.count
            else {
                return
            }
            show(controllers[index])
        }
    }
    
    private func show(_ target: UIViewController) {
        guard currentViewController != target else { return }
        
        if let currentViewController {
            currentViewController.do {
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }
        }
        
        addChild(target)
        containerView.addSubview(target.view)
        target.view.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        target.didMove(toParent: self)
        currentViewController = target
    }
}
