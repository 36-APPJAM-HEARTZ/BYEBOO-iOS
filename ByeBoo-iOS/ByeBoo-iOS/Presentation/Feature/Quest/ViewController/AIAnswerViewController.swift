//
//  AIAnswerViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 2/18/26.
//

import Combine
import UIKit

final class AIAnswerViewController: BaseViewController {
    
    private let rootView = AIAnswerView()
    private let viewModel: AIAnswerViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var questID: Int = 1
    private var isAIAnswerExists: Bool = false
    
    init(viewModel: AIAnswerViewModel) {
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
        
        self.navigationItem.hidesBackButton = true
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .close(header: .black),
            action: #selector(close)
        )
        
        bind()
        viewModel.action(
            .viewDidLoad(
                questID: questID,
                isAIAnswerExists: isAIAnswerExists
            )
        )
    }
}

extension AIAnswerViewController {
    private func bind() {
        viewModel.output.AILoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case true:
                    self?.rootView.updateState(state: .loading)
                case false:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.AIResultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let answer):
                    self?.rootView.cardView.updateText(answer: answer)
                    self?.rootView.updateState(state: .success)
                case .failure:
                    self?.rootView.updateState(state: .fail)
                }
            }
            .store(in: &cancellables)
    }
}

extension AIAnswerViewController: Dismissible {
    func close() {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: false)
    }
}

extension AIAnswerViewController {
    func configure(
        questID: Int,
        isAIAnswerExists: Bool
    ) {
        self.questID = questID
        self.isAIAnswerExists = isAIAnswerExists
    }
}
