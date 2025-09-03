//
//  MyPageViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import Combine
import UIKit

final class MyPageViewController: BaseViewController {
    
    private let viewModel: MyPageViewModel
    private var cancellables = Set<AnyCancellable>()
    private var name: String?
    
    private let rootView = MyPageView()
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.viewWillAppear)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .title("내 정보")
        )
    }
    
    override func setAddTarget() {
        setGesture()
        rootView.moveButton.addTarget(
            self,
            action: #selector(moveButtonDidTap),
            for: .touchUpInside
        )
        [rootView.inquireView, rootView.termAndPolicyView, rootView.accountView].forEach {
            $0.featureButtons.forEach {
                $0.addTarget(self, action: #selector(featureButtonDidTap(_:)), for: .touchUpInside)
            }
        }
    }
    
    private func setGesture() {
        let nicknameTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveButtonDidTap))
        rootView.nameView.do {
            $0.addGestureRecognizer(nicknameTapRecognizer)
            $0.isUserInteractionEnabled = true
        }
        
        let lookBackTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(lookBackButtonDidTap))
        let viewUniversetapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewByeBooWorldDidTap))
        rootView.myRecordView.textBoxView.do {
            $0.addGestureRecognizer(lookBackTapRecognizer)
            $0.isUserInteractionEnabled = true
        }
        rootView.worldView.textBoxView.do {
            $0.addGestureRecognizer(viewUniversetapRecognizer)
        }
    }
}

extension MyPageViewController {
    
    private func bind() {
        bindUserResult()
        bindLogoutResult()
        bindWithdrawResult()
    }
    
    private func bindUserResult() {
        viewModel.output.userResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let name):
                    self?.name = name
                    self?.rootView.updateName(name)
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindLogoutResult() {
        viewModel.output.logoutResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    ByeBooLogger.debug("로그아웃 성공")
                    self?.navigateInitialViewController()
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
    }
        
    private func bindWithdrawResult() {
        viewModel.output.withdrawResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    ByeBooLogger.debug("탈퇴 성공")
                    self?.navigateInitialViewController()
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
    }
}

extension MyPageViewController {
    
    @objc
    private func lookBackButtonDidTap() {
        let lookBackJourneyViewController = ViewControllerFactory.shared.makeLookBackJourneyViewController()
        lookBackJourneyViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(lookBackJourneyViewController, animated: true)
    }
    
    @objc
    private func viewByeBooWorldDidTap() {
        let tutorialViewController = TutorialModalViewController()
        tutorialViewController.navigationItem.hidesBackButton = true
        tutorialViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(tutorialViewController, animated: false)
    }
    
    @objc
    private func moveButtonDidTap() {
        let modifyNicknameViewController = ViewControllerFactory.shared.makeModifyNicknameViewController()
        modifyNicknameViewController.updateName(self.name)
        modifyNicknameViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(modifyNicknameViewController, animated: false)
    }
    
    @objc
    private func featureButtonDidTap(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text,
              let type = MyPageDetailFeatureType(rawValue: title) else {
            return
        }
        actionFeature(type: type)
    }
    
    private func actionFeature(type: MyPageDetailFeatureType) {
        switch type {
        case .inquireByeBoo:
            ExternalLink.inquire.openURL(for: self)
        case .makeService:
            ExternalLink.makeService.openURL(for: self)
        case .privacyPolicy:
            ExternalLink.privacyPolicy.openURL(for: self)
        case .serviceTerm:
            ExternalLink.serviceTerm.openURL(for: self)
        case .logout:
            let logoutModalView = createConfirmModal(
                modalType: .logout,
                dismissOption: "취소",
                actionOption: "로그아웃"
            )
            presentModal(to: logoutModalView)
        case .cancel:
            let cancelModalView = createConfirmModal(
                modalType: .withdraw,
                dismissOption: "취소",
                actionOption: "탈퇴하기"
            )
            presentModal(to: cancelModalView)
        }
    }
    
    private func createConfirmModal(
        modalType: ConfirmModalType,
        dismissOption: String? = nil,
        actionOption: String
    ) -> ConfirmModalView {
        let dismissButton: ByeBooButton? = dismissOption.map { ByeBooButton(titleText: $0, type: .outline) }
        let actionButton = ByeBooButton(titleText: actionOption, type: .enabled)
        
        return ConfirmModalView(
            modalType: modalType,
            dismissButton: dismissButton,
            actionButton: actionButton
        )
    }
    
    private func presentModal(to modal: BaseView & ModalProtocol) {
        guard let modalType = modal.modalType else { return }
        let action: (() -> Void) = {
            switch modalType{
            case .logout:
                self.viewModel.action(.logoutActionButtonDidTap)
            case .withdraw:
                self.viewModel.action(.withdrawActionButtonDidTap)
            }
        }
        
        ModalBuilder(
            modalView: modal,
            action: action,
            rootViewController: self
        ).present()
    }
    
    private func navigateInitialViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }

        let viewController = ViewControllerFactory.shared.makeLoginViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        sceneDelegate.window?.rootViewController = navigationController
        sceneDelegate.window?.makeKeyAndVisible()
    }
}
