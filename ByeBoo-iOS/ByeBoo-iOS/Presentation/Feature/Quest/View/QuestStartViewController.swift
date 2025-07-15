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
    private let rootView = QuestStartView()
    
    var onStartedQuest: (() -> Void)?
    
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

        bind()
        setGesture()
        viewModel.action(.viewDidLoad)
    }
    
    override func setAddTarget() {
        rootView.confirmButton.addTarget(
            self,
            action: #selector(questStartButtonDidTap),
            for: .touchUpInside
        )
    }
    
    private func setGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(back))
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        rootView.backButton.addGestureRecognizer(tapGestureRecognizer)
    }
}

extension QuestStartViewController: BackNavigable {
    func back() {
        if let presentingVC = self.presentingViewController {
            if let tabBarController = presentingVC as? UITabBarController {
                // 홈 탭에서 진입
                if tabBarController.selectedIndex == 0 {
                    self.dismiss(animated: false)
                } else {
                    // 퀘스트 탭에서 진입
                    self.dismiss(animated: false)
                    tabBarController.selectedIndex = 0
                }
            }
        }
    }
}

extension QuestStartViewController {
    @objc
    func questStartButtonDidTap() {
        viewModel.action(.buttonDidTap)
    }
    
    private func bind() {
        Publishers.CombineLatest(
            viewModel.output.nameResult,
            viewModel.output.journeyResult
        )
        .receive(on: DispatchQueue.main)
        .sink { name, journey in
            switch (name, journey) {
            case let (.success(name), .success(journey)):
                self.rootView.updateDescription(nickname: name, journey: journey.title)
            default:
                break
            }
        }
        .store(in: &cancellables)
        
        viewModel.output.startResult
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success:
                    self.onStartedQuest?()
                    if let presentingVC = self.presentingViewController {
                        if let tabBarController = presentingVC as? UITabBarController {
                            self.dismiss(animated: false) {
                                tabBarController.selectedIndex = 1
                            }
                        }
                    }
                case .failure(let failure):
                    ByeBooLogger.error(failure)
                }
            }
            .store(in: &cancellables)
    }
}
