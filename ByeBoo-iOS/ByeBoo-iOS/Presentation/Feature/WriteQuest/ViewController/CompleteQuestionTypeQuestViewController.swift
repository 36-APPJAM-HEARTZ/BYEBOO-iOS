//
//  CompleteQuestionTypeQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Combine
import UIKit

final class CompleteQuestionTypeQuestViewController: BaseViewController {
    
    private let rootView = CompleteQuestionTypeQuestView()
    private var viewModel: CompleteQuestViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var questID: Int = 1
    private var questNumber: Int = 1
    
    override func loadView() {
        view = rootView
    }
    
    init(viewModel: CompleteQuestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        viewModel.action(.questAnswerDidLoad(questID: questID))
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .close(header: .black),
            action: #selector(close)
        )
        
        bind()
    }
}

extension CompleteQuestionTypeQuestViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        viewModel.output.resultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.rootView.bind(with: entity)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.loadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if result {
                    self?.view.alpha = 0
                } else {
                    UIView.animate(withDuration: 0.2) {
                        self?.view.alpha = 1
                    }
                }
            }
            .store(in: &cancellables)
    }
}

extension CompleteQuestionTypeQuestViewController: Dismissible {
    
    func close() {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: false)
        
        // TODO: 매직 넘버 바꾸기
        if questNumber == 30 {
            // TODO: 오프보딩 플로우 연결
            let modalBuilder = ModalBuilder(
                modalView: CongrateModalView(),
                action: modalAction,
                rootViewController: self
            )
            modalBuilder.present()
        }
    }
    
    private func modalAction() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let tabBar = window.rootViewController as? UITabBarController,
              let root = tabBar.selectedViewController as? UINavigationController else {
            return
        }
        
        let viewController = ViewControllerFactory.shared.makeFinishJourneyViewController()
        root.pushViewController(viewController, animated: false)
    }
}

extension CompleteQuestionTypeQuestViewController {
    func configure(
        questID: Int,
        questNumber: Int
    ) {
        self.questID = questID
        self.questNumber = questNumber
    }
}
