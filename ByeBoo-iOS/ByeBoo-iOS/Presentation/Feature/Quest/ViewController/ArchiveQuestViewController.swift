//
//  ArchiveQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25
//

import Combine
import UIKit

final class ArchiveQuestViewController: BaseViewController {
        
    private var rootView = ArchiveQuestView(type: .activation)
    private let viewModel: CompleteQuestViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var questID: Int = 1
    private var questType: QuestType = .activation
    
    init(viewModel: CompleteQuestViewModel
    ) {
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
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .editAndClose(header: .black),
            action: #selector(close),
            secondAction: #selector(editButtonDidTap)
        )
        viewModel.action(.questAnswerDidLoad(questID: questID))
        bind()
    }
}

extension ArchiveQuestViewController: ToastPresentable, ToastErrorHandler {
    func bind() {
        viewModel.output.resultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.rootView.updateUI(entity)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.loadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case true:
                    self?.view.alpha = 0
                case false:
                    UIView.animate(withDuration: 0.1) {
                        self?.view?.alpha = 1
                    }
                }
            }
            .store(in: &cancellables)
    }
}

extension ArchiveQuestViewController: Dismissible {
    func close() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension ArchiveQuestViewController {
    func configure(questID: Int, questType: QuestType) {
        self.questID = questID
        self.questType = questType
        rootView = ArchiveQuestView(type: questType)
    }
    
    @objc
    private func editButtonDidTap() {
        ByeBooLogger.debug("버튼 터치, entity: \(String(describing: viewModel.entity))")
        
        guard let entity = viewModel.entity else { return }

        var viewController: ( BaseViewController & EditQuestProtocol )
        if rootView.type == .question {
            viewController = ViewControllerFactory.shared.makeWriteQuestionTypeQuestViewController() as WriteQuestionTypeQuestViewController
            viewController.questMode = .edit
            viewController.getExistingQuest(questID: self.viewModel.questID ,quest: entity.answer, image: entity.imageUrl)
            viewController.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(viewController, animated: false)
        } else {
            let viewController = ViewControllerFactory.shared.makeWriteActiveTypeQuestViewController()
            viewController.questMode = .edit
            viewController.getExistingQuest(questID: self.viewModel.questID, quest: entity.answer, image: entity.imageUrl)
            viewController.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    private func setNavigateViewController(type: QuestType) -> UIViewController {
        if type == .question {
            return ViewControllerFactory.shared.makeWriteQuestionTypeQuestViewController()
        } else {
            return ViewControllerFactory.shared.makeWriteActiveTypeQuestViewController()
        }
    }
}
