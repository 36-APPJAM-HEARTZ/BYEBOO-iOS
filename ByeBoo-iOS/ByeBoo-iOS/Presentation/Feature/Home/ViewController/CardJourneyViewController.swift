//
//  CardJourneyViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/14/25.
//

import UIKit
import Combine

import Mixpanel

final class CardJourneyViewController: BaseViewController {
    
    private let viewModel: CardJourneyViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let rootView = CardJourneyView()
    private var journeyType: JourneyType = .recording
    
    init(viewModel: CardJourneyViewModel) {
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
        setGesture()
        
        viewModel.action(.viewDidLoad)
    }
    
    private func setGesture() {
        let cardTapGesture = UITapGestureRecognizer(target: self, action: #selector(cardDidTap))
        cardTapGesture.isEnabled = true
        cardTapGesture.cancelsTouchesInView = false
        rootView.cardImageView.addGestureRecognizer(cardTapGesture)
        
        let confirmLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(confirmLabelDidTap))
        rootView.confirmLabel.addGestureRecognizer(confirmLabelTapGesture)
        rootView.confirmLabel.isUserInteractionEnabled = true
    }
}

extension CardJourneyViewController {
    @objc
    private func cardDidTap() {
        rootView.flipCard()
    }
    
    @objc
    private func confirmLabelDidTap() {
        let property = CommonEvents.JourneyTypeProperty(journeyType: journeyType.mixpanelKey)
        Mixpanel.mainInstance().track(event: CommonEvents.Name.journeyCardComplete, properties: property.dictionary)
        let userProperty = UserEvents.UserFirstJourneyTypeProperty(userFirstJourneyType: journeyType.mixpanelKey)
        Mixpanel.mainInstance().people.set(properties: userProperty.dictionary)
        
        let viewController = HomeOnboardingViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(viewController, animated: false)
    }
}

extension CardJourneyViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        viewModel.output.journeyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let journey):
                    self?.rootView.updateJourney(
                        journeyType: JourneyType.titleToEnum(journey.title) ?? .recording,
                        journeyDescription: journey.description ?? ""
                    )
                    self?.journeyType = JourneyType.titleToEnum(journey.title) ?? .recording
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
    }
}
