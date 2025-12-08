//
//  MyPageViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import Combine
import UIKit

import Mixpanel

final class MyPageViewController: BaseViewController {
    
    private let viewModel: MyPageViewModel
    private var cancellables = Set<AnyCancellable>()
    private var name: String?
    private var beforeNotificationStatus = false
    private var didOpenSetting = false
    
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
        viewModel.action(.checkHasEnterMyPage)
        rootView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .title("내 정보")
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkNoticeAuthorizationWhenBack),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
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
        rootView.noticeView.noticeSwitch.addTarget(
            self,
            action: #selector(noticeSwitchValueChanged(_:)),
            for: .valueChanged
        )
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
        bindNotificationResult()
        bindHasEnterMyPage()
        bindAlarmEnabled()
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
    
    private func bindNotificationResult() {
        viewModel.output.notificationResult
            .sink { [weak self] result in
                switch result {
                case .success(let alarmEnabled):
                    self?.beforeNotificationStatus = alarmEnabled
                    DispatchQueue.main.async {
                        self?.rootView.noticeView.noticeSwitch.setOn(alarmEnabled, animated: false)
                    }
                case .failure(let error):
                    ByeBooLogger.error(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindHasEnterMyPage() {
        viewModel.output.hasEnterMyPageResult
            .sink { [weak self] result in
                switch result {
                case .success(let hasEnter):
                    if !hasEnter {
                        self?.rootView.noticeView.noticeSwitch.setOn(false, animated: false)
                        return
                    }
                    self?.viewModel.action(.checkAlarmEnabled)
                case .failure(let error) :
                    ByeBooLogger.error(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindAlarmEnabled() {
        viewModel.output.alarmEnabledResult
            .sink { [weak self] result in
                switch result {
                case .success(let alarmEnabled):
                    self?.rootView.noticeView.noticeSwitch.setOn(alarmEnabled, animated: true)
                case .failure(let error) :
                    ByeBooLogger.error(error)
                }
            }
            .store(in: &cancellables)
    }
}

extension MyPageViewController {
    
    @objc
    private func checkNoticeAuthorizationWhenBack() {
        guard didOpenSetting else { return }
        
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let self else { return }
            
            let isAuthorized: Bool
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                isAuthorized = true
            default:
                isAuthorized = false
            }
            
            if beforeNotificationStatus != isAuthorized {
                viewModel.action(.notificationSwitchDidTap)
            } else if !isAuthorized {
                DispatchQueue.main.async {
                    self.rootView.noticeView.noticeSwitch.setOn(false, animated: false)
                }
            }
            
            beforeNotificationStatus = isAuthorized
            didOpenSetting = false
        }
    }
    
    @objc
    private func lookBackButtonDidTap() {
        let lookBackJourneyViewController = ViewControllerFactory.shared.makeLookBackJourneyViewController()
        lookBackJourneyViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(lookBackJourneyViewController, animated: true)
        
        Mixpanel.mainInstance().track(event: MyPageEvents.Name.myPageJourneyReviewClick)
    }
    
    @objc
    private func viewByeBooWorldDidTap() {
        let tutorialViewController = TutorialModalViewController()
        tutorialViewController.navigationItem.hidesBackButton = true
        tutorialViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(tutorialViewController, animated: false)
        
        Mixpanel.mainInstance().track(event: MyPageEvents.Name.tutorialButtonClick)
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
    
    @objc
    private func noticeSwitchValueChanged(_ sender: UISwitch) {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let self else { return }
                        
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    self.requestNoticeAuthorization()
                case .authorized, .provisional, .ephemeral:
                    self.viewModel.action(.notificationSwitchDidTap)
                case .denied:
                    self.presentMoveSettingAlert(
                        isOn: sender.isOn,
                        status: .denied
                    )
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func actionFeature(type: MyPageDetailFeatureType) {
        switch type {
        case .inquireByeBoo:
            ExternalLink.inquire.openURL(for: self)
        case .makeService:
            ExternalLink.makeService.openURL(for: self)
        case .questOpenNotice:
            break
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
                
                Mixpanel.mainInstance().track(event: MyPageEvents.Name.logoutConfirmClick)
            case .withdraw:
                self.viewModel.action(.withdrawActionButtonDidTap)
                
                Mixpanel.mainInstance().track(event: MyPageEvents.Name.withdrawConfirmClick)
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
    
    private func requestNoticeAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { [weak self] _, _ in
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self?.checkNoticeAuthorizationWhenBack()
            }
        )
    }
    
    private func presentMoveSettingAlert(
        isOn: Bool,
        status: NotificationPermissionStatus
    ) {
        guard isOn else { return }
        
        let alertController = createAlertController(status: status)
        alertController.addActions(
            createSuccessAlertAction(),
            createCancelAlertAction()
        )
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    private func createAlertController(status: NotificationPermissionStatus) -> UIAlertController {
        UIAlertController(
            title: status.title,
            message: status.message,
            preferredStyle: .alert
        )
    }
    
    private func createSuccessAlertAction() -> UIAlertAction {
        UIAlertAction(
           title: "설정으로 이동",
           style: .default
       ) { [weak self] _ in
           self?.moveSetting()
       }
    }
    
    private func createCancelAlertAction() -> UIAlertAction {
        UIAlertAction(
            title: "취소",
            style: .cancel
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.rootView.noticeView.noticeSwitch.setOn(false, animated: true)
            }
        }
    }
    
    private func moveSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
            didOpenSetting = true
        }
    }
}
