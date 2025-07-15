//
//  ArchiveQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import Combine
import UIKit

final class ArchiveQuestViewController: BaseViewController {
    
    private let viewModel: CompleteQuestViewModel
    private var cancellable = Set<AnyCancellable>()
    private let rootView = ArchiveQuestView(type: .activation)
    var questID: Int = 0
    
    init(viewModel: CompleteQuestViewModel) {
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
        
        bind()
        viewModel.action(.questAnswerDidLoad(questID: questID))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .close,
            action: #selector(close)
        )
    }
    
}

extension ArchiveQuestViewController: Dismissible {
    func close() {
        //
    }
}

extension ArchiveQuestViewController {
    
    private func bind() {
        viewModel.output.resultPublisher
            .sink { result in
                switch result {
                case .success(let entity):
                    print("엔티티를 받아왔습니다")
                    self.rootView.updateUI(entity)
                case .failure:
                    break
                }
            }
            .store(in: &cancellable)
    }
}
