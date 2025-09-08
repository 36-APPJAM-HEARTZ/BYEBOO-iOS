//
//  QuestStartViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/9/25.
//

import UIKit
import Combine

protocol StartModalDelegate: AnyObject {
    func startAndDismissModal()
    func backDismissModal()
}

final class QuestStartViewController: BaseViewController {
    
    private let viewModel: QuestStartViewModel
    private var cancellables = Set<AnyCancellable>()
    private let rootView = QuestStartView()
    
    private var journeyTitle: String = ""
    
    weak var delegate: StartModalDelegate?
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
                    self?.delegate?.startAndDismissModal()
                    self?.dismiss(animated: false)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
    }
}

extension QuestStartViewController: BackNavigable {
    func back() {
        if let delegate = self.delegate {
            delegate.backDismissModal()
        } else {
            ViewControllerUtils.changeSelectedIndex(index: 0)
        }
        self.dismiss(animated: false)
    }
}
extension QuestStartViewController {
    func configure(journeyTitle: String) {
        self.journeyTitle = journeyTitle
    }
}
