//
//  NewJourneySelectViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import Combine
import UIKit

final class NewJourneySelectViewController: BaseViewController {
        
    private let rootView: NewJourneySelectView
    private let viewModel: NewJourneyViewModel
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = rootView
    }

    init(viewModel: NewJourneyViewModel) {
        self.viewModel = viewModel
        rootView = NewJourneySelectView(unCompleteJourneyList: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bind()
        
        rootView.unCompleteListView.delegate = self
        viewModel.action(.newJourneyDidLoad)
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back(),
            action: #selector(back)
        )
    }
}

extension NewJourneySelectViewController: ToastPresentable, ToastErrorHandler {
    private func bind() {
        viewModel.output.newJourneyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.rootView.bind(with: entity)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
    }
}

extension NewJourneySelectViewController: BackNavigable {
    func back() {
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        
        navigationController.popViewController(animated: true)
    }
}

extension NewJourneySelectViewController: SelectUnCompletedJourneyProtocol {
    func addGesture() {
        guard let journeyStack = rootView.unCompleteListView.journeyListView else { return }

        ByeBooLogger.debug(journeyStack)
        journeyStack.arrangedSubviews.dropLast().forEach { journey in
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(journeyDidTap))
            journey.addGestureRecognizer(tapRecognizer)
            journey.isUserInteractionEnabled = true
        }
    }
}

extension NewJourneySelectViewController {
    @objc
    private func journeyDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        guard let journeyView = tapRecognizer.view as? OneLineTextBoxView else { return }
        ByeBooLogger.debug(journeyView.title)
        
        let viewController = ViewControllerFactory.shared.makeQuestStartViewController()
        viewController.configure(journeyTitle: journeyView.title)
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        self.present(viewController, animated: false)
    }
}

extension NewJourneySelectViewController: StartModalDelegate {
    func startAndDismissModal() {
        navigationController?.popToRootViewController(animated: false)
        ViewControllerUtils.changeSelectedIndex(index: 1)
    }
    
    func backDismissModal() { }
}
