//
//  NewJourneySelectViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import Combine
import UIKit

import Mixpanel

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
        
        Mixpanel.mainInstance().track(event: QuestEvents.Name.journeyNewPageView)
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
        let journeyTitle = journeyView.title
            .replacingOccurrences(of: "여정", with: "")
            .trimmingCharacters(in: .whitespaces)
        let journeyType = JourneyType.titleToEnum(journeyTitle) ?? .recording
        
        ByeBooLogger.debug(journeyType.title)
        
        let viewController = ViewControllerFactory.shared.makeQuestStartViewController()
        viewController.configure(journeyTitle: journeyType.title)
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        self.present(viewController, animated: false)
        
        let property = QuestEvents.NewJourneyProperty(newJourneyType: journeyType.mixpanelKey)
        Mixpanel.mainInstance().track(
            event: QuestEvents.Name.journeyNewClick,
            properties: property.dictionary
        )
    }
}

extension NewJourneySelectViewController: StartModalDelegate {
    func startAndDismissModal() {
        navigationController?.popToRootViewController(animated: false)
    }
    
    func backDismissModal() { }
}
