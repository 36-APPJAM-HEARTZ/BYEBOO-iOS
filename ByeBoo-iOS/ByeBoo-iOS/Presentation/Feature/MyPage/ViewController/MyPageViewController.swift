//
//  MyPageViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import Combine
import UIKit

final class MyPageViewController: BaseViewController {
    
    private let viewModel: MyPageViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let rootView = MyPageView()
    
    init(viewModel: MyPageViewModel) {
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
        bind()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .title("마이페이지")
        )
        
        viewModel.action(.viewDidLoad)
    }
    
    override func setAddTarget() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(lookBackButtonDidTap))
        rootView.myRecordView.textBoxView.addGestureRecognizer(tapRecognizer)
        rootView.myRecordView.textBoxView.isUserInteractionEnabled = true
    }
}

extension MyPageViewController {
    @objc
    private func lookBackButtonDidTap() {
        guard let viewModel = DIContainer.shared.resolve(type: LookBackJourneyViewModel.self) else {
            return
        }
        
        let lookBackViewController = LookBackJourneyViewController(viewModel: viewModel)
        lookBackViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(lookBackViewController, animated: true)
    }
    
    private func bind() {
        viewModel.output.userResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let name):
                    self?.rootView.updateName(name)
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
    }
}
