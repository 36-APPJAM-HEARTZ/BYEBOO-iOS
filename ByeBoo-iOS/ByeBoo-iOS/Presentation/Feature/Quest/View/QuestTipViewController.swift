//
//  QuestTipViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Combine
import UIKit

final class QuestTipViewController: BaseViewController {
    
    private let rootView = QuestTipView()
    private let viewModel = QuestTipViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .titleAndClose("퀘스트 작성 TIP"),
            action: #selector(close)
        )
        
        bind()
        viewModel.action(.questTipDidLoad)
    }
    
    private func bind() {
        viewModel.output.questTipPublisher
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.rootView.bind(with: entity)
                case .failure(let error):
                    print("에러 발생: \(error)")
                }
            }
            .store(in: &cancellables)
    }
}

extension QuestTipViewController: Dismissible {
    func close() {
        dismiss(animated: true)
    }
}
