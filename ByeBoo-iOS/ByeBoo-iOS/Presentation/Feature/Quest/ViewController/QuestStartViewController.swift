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
    
    private var journeyTitle: String = ""
    
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

extension QuestStartViewController {
    
    @objc
    func questStartButtonDidTap() {
        viewModel.action(.buttonDidTap(journey: journeyTitle))
    }
}

extension QuestStartViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        Publishers.CombineLatest(
            viewModel.output.nameResult,
            viewModel.output.journeyResult
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] name, journey in
            switch (name, journey) {
            case let (.success(name), .success(journey)):
                self?.rootView.updateDescription(nickname: name, journey: journey.title)
            case let (.success(name), .failure):
                self?.rootView.updateDescription(nickname: name, journey: self?.journeyTitle ?? "")
            case (_, .failure(let error)):
                self?.handleError(error)
            default:
                ByeBooLogger.error(ByeBooError.unknownError)
            }
        }
        .store(in: &cancellables)
        
        viewModel.output.startResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.dismiss(animated: false)
                    guard self?.tabBarController?.viewControllers?[safe: 1] != nil else { return }
                    self?.navigationController?.tabBarController?.selectedIndex = 1
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
    }
}

extension QuestStartViewController: BackNavigable {
    func back() {
        if let presentingVC = self.presentingViewController {
            if let tabBarController = presentingVC as? UITabBarController {
                self.dismiss(animated: false)
                tabBarController.selectedIndex = 0
            } else {
                self.dismiss(animated: false)
            }
        }
    }
}
extension QuestStartViewController {
    func configure(journeyTitle: String) {
        self.journeyTitle = journeyTitle
    }
}
