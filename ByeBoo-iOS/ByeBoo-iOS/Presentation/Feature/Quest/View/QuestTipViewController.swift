//
//  QuestTipViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Combine
import UIKit

final class QuestTipViewController: BaseViewController {
    
    private let rootView: QuestTipView
    private let viewModel: QuestTipViewModel
    private var cancellables = Set<AnyCancellable>()
    private let questID: Int
    private let questType: QuestType
    
    override func loadView() {
        view = rootView
    }
    
    init(viewModel: QuestTipViewModel, questID: Int, questType: QuestType) {
        self.viewModel = viewModel
        self.questID = questID
        self.questType = questType
        rootView = QuestTipView(questType: questType)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        viewModel.action(.questTipDidLoad(questID: questID))
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .none
        )
        
        setAction()
        bind()
    }
    
    private func setAction() {
        rootView.closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
    }
    
    private func bind() {
        viewModel.output.questTipPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.rootView.bind(with: entity)
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellables)
    }
}

extension QuestTipViewController {
    
    @objc
    func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
}
