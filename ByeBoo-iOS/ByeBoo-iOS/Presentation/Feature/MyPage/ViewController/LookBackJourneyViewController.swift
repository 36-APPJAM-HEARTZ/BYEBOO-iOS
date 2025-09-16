//
//  LookBackJourneyViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import Combine
import UIKit

import Mixpanel

final class LookBackJourneyViewController: BaseViewController {
    
    private let rootView: LookBackJourneyView
    private let viewModel: LookBackJourneyViewModel
    private var cancellables = Set<AnyCancellable>()
        
    override func loadView() {
        view = rootView
    }
    
    init(viewModel: LookBackJourneyViewModel) {
        self.viewModel = viewModel
        rootView = LookBackJourneyView(journeyList: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.action(.lookBackJourneyDidLoad)
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back(),
            action: #selector(back)
        )
        
        bind()
        rootView.journeyView.completeJourneyDelegate = self
        
        Mixpanel.mainInstance().track(event: QuestEvents.Name.journeyReviewPageView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 다음 화면으로 이동할 때 헤더 타입을 미리 변경하여 flick 방지
        if isMovingFromParent {
            ByeBooNavigationBar.replaceHeaderType(
                from: self.navigationController ?? UINavigationController(),
                headerType: .clear
            )
        }
    }
}

extension LookBackJourneyViewController: SelectCompletedJourneyProtocol {
    
    func addGesture() {
        if let views = rootView.journeyView.journeyListView?.arrangedSubviews {
            for (_, view) in views.enumerated() {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(journeyViewDidTap(_:)))
                view.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    @objc
    private func journeyViewDidTap(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view as? OneLineTextBoxView else { return }
        
        let completedQuestsViewController = ViewControllerFactory.shared.makeCompletedQuestsViewController()
        completedQuestsViewController.configure(journey: view.title)
        completedQuestsViewController.navigationItem.hidesBackButton = true
        
        self.navigationController?.pushViewController(completedQuestsViewController, animated: false)
    }
}

extension LookBackJourneyViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        viewModel.output.lookBackJourneyPublisher
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

extension LookBackJourneyViewController: BackNavigable {
    func back() {
        navigationController?.popViewController(animated: false)
    }
}
