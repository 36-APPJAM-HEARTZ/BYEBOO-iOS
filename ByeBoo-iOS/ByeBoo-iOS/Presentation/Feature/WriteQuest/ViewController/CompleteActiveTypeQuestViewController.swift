//
//  CompleteActiveTypeQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import Combine
import UIKit

final class CompleteActiveTypeQuestViewController: BaseViewController {
    
    private let rootView = CompleteActiveTypeQuestView()
    private var viewModel: CompleteQuestViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var questID: Int = 31
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

extension CompleteActiveTypeQuestViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        viewModel.output.resultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.questNumber = entity.questNumber
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

extension CompleteActiveTypeQuestViewController: Dismissible, ReviewRequestProtocol {
    
    func close() {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: false)
        
        if requestQuestNumber.contains(questNumber) {
            reviewRequest()
        }
    }
    
    private func modalAction() {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: false)
    }
}

extension CompleteActiveTypeQuestViewController {
    func configure(
        questID: Int,
        questNumber: Int
    ) {
        self.questID = questID
        self.questNumber = questNumber
    }
}
