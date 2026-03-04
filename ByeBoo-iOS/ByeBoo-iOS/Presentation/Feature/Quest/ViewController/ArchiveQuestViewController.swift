//
//  ArchiveQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25
//

import Combine
import UIKit

enum ArchiveViewControllerEntryPoint {
    case mypage
    case questMain
    case writeQuest
    case edit
}

final class ArchiveQuestViewController: BaseViewController {
        
    private var rootView = ArchiveQuestView(type: .question)
    private let viewModel: ArchiveQuestViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var questID: Int = 1
    private var questType: QuestType = .activation
    var entryViewController: ArchiveViewControllerEntryPoint?
    
    init(viewModel: ArchiveQuestViewModel
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
        
        guard let entryViewController else { return }
        switch entryViewController {
        case .writeQuest:
            ByeBooNavigationBar.makeNavigationBar(
                navigationItem: self.navigationItem,
                navigationController: self.navigationController,
                type: .close(header: .black),
                action: #selector(close)
            )
        case .mypage, .questMain, .edit:
            ByeBooNavigationBar.makeNavigationBar(
                navigationItem: self.navigationItem,
                navigationController: self.navigationController,
                type: .editAndClose(header: .black),
                action: #selector(close),
                secondAction: #selector(editButtonDidTap)
            )
        }
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
                    guard let self else { return }
                    ByeBooLogger.debug("퀘스트 아이디 \(self.questID)")
                    self.rootView.updateUI(entity)
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
        guard let entryViewController else { return }
        switch entryViewController {
        case .mypage, .questMain:
            self.navigationController?.popViewController(animated: true)
        case .writeQuest, .edit:
            let viewController = ByeBooTabBar()
            viewController.selectedIndex = 1
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                
                ViewControllerUtils.setRootViewController(
                    window: window,
                    viewController: viewController,
                    withAnimation: true
                )
            }
        }
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
        viewController = setNavigateViewController(type: rootView.type)
        viewController.questMode = .edit
        viewController.getExistingQuest(questID: self.viewModel.questID ,questAnswer: entity.answer, image: entity.imageUrl, imageKey: entity.imageKey)
        viewController.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func setNavigateViewController(type: QuestType) -> ( BaseViewController & EditQuestProtocol ) {
        if type == .question {
            return ViewControllerFactory.shared.makeWriteQuestionTypeQuestViewController()
        } else {
            return ViewControllerFactory.shared.makeWriteActiveTypeQuestViewController()
        }
    }
}
