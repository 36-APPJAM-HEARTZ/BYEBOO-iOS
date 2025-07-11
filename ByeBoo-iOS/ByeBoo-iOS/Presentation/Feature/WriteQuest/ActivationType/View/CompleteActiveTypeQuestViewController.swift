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
    private let viewModel = CompleteQuestViewModel()
    private var cancellables = Set<AnyCancellable>()
    

    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        viewModel.action(.questAnswerDidLoad)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .close,
            action: #selector(close)
        )
        
        bind()
    }
    
    private func bind() {
        viewModel.output.resultPublisher
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

extension CompleteActiveTypeQuestViewController: Dismissible {
    func close() {
        // TODO: - 퀘스트 메인 이동 수정
        self.navigationController?.popViewController(animated: true)
    }
}
