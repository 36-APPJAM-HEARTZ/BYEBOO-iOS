//
//  QuestStartViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/9/25.
//

import UIKit
import Combine

final class QuestStartViewController: BaseViewController {
    
    private let viewModel: QuestStartViewModel
    private var cancellables = Set<AnyCancellable>()
    private let rootView = QuestStartView(nickname: "하츠핑")
    
    init(viewModel: QuestStartViewModel) {
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
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back,
            action: #selector(back)
        )
        bind()
    }
    
    override func setAddTarget() {
        rootView.confirmButton.addTarget(
            self,
            action: #selector(questStartButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension QuestStartViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension QuestStartViewController {
    @objc
    func questStartButtonDidTap() {
        viewModel.action(.buttonDidTap)
    }
    
    private func bind() {
        viewModel.output.startResult
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success:
                    self.navigationController?.tabBarController?.selectedIndex = 1
                    self.navigationController?.popToRootViewController(animated: true)
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
    }
}
