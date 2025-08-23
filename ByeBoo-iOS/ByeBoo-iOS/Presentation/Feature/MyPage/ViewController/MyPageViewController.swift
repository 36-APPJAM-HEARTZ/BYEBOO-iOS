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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .title("내 정보")
        )
        
        viewModel.action(.viewDidLoad)
    }
    
    override func setAddTarget() {
        setGesture()
        rootView.moveButton.addTarget(
            self,
            action: #selector(moveButtonDidTap),
            for: .touchUpInside
        )
        rootView.inquireView.featureButtons.forEach {
            $0.addTarget(self, action: #selector(featureButtonDidTap(_:)), for: .touchUpInside)
        }
        rootView.termAndPolicyView.featureButtons.forEach {
            $0.addTarget(self, action: #selector(featureButtonDidTap(_:)), for: .touchUpInside)
        }
        rootView.accountView.featureButtons.forEach {
            $0.addTarget(self, action: #selector(featureButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    private func setGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(lookBackButtonDidTap))
        rootView.myRecordView.textBoxView.do {
            $0.addGestureRecognizer(tapRecognizer)
            $0.isUserInteractionEnabled = true
        }
    }
}

extension MyPageViewController {
    
    private func bind() {
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
}

extension MyPageViewController {
    
    @objc
    private func lookBackButtonDidTap() {
        let lookBackViewController = LookBackJourneyViewController()
        lookBackViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(lookBackViewController, animated: true)
    }
    
    @objc
    private func moveButtonDidTap() {
        let modifyNicknameViewController = ModifyNicknameViewController()
        modifyNicknameViewController.deliverName(self.name)
        self.navigationController?.pushViewController(modifyNicknameViewController, animated: false)
    }
    
    @objc
    private func featureButtonDidTap(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        switch title {
        case MyPageFeatureType.inquire.rawValue:
            break
        case MyPageFeatureType.makeService.rawValue:
            break
        case MyPageFeatureType.privacyPolicy.rawValue:
            break
        case MyPageFeatureType.serviceTerm.rawValue:
            break
        case MyPageFeatureType.logout.rawValue:
            ModalBuilder(
                modalView: LogoutModalView(),
                action: nil,
                rootViewController: self
            ).present()
        case MyPageFeatureType.cancel.rawValue:
            ModalBuilder(
                modalView: CancelModalView(),
                action: nil,
                rootViewController: self
            ).present()
        default:
            break
        }
    }
}
