//
//  FinishJourneyViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit
import Combine

import Mixpanel

final class FinishJourneyViewController: BaseViewController {

    private let rootView = FinishJourneyView()
    private let viewModel: FinishJourneyViewModel
    
    private var cancellables = Set<AnyCancellable>()
    private var journeyType: JourneyType = .recording
    
    init(viewModel: FinishJourneyViewModel) {
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
        
        viewModel.action(.viewDidLoad)
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .close(header: .clear),
            action: #selector(close)
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.rootView.startParagraphAnimation()
        }
        
        let property = QuestEvents.JourneyFinishProperty(
            journeyEndAt: Date().toString(),
            journeyType: journeyType.mixpanelKey
        )
        Mixpanel.mainInstance().track(
            event: QuestEvents.Name.journeyCompletePageView,
            properties: property.dictionary
            )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        tabBarController?.hidesBottomBarWhenPushed = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func setAddTarget() {
        rootView.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        rootView.lookBackButton.addTarget(self, action: #selector(lookBackButtonDidTap), for: .touchUpInside)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(homeLabelDidTap))
        rootView.backHomeLabel.addGestureRecognizer(tapRecognizer)
        rootView.backHomeLabel.isUserInteractionEnabled = true
    }
}

extension FinishJourneyViewController {
    private func bind() {
        
        Publishers.CombineLatest(
            viewModel.output.userNamePublisher,
            viewModel.output.lastJourneyPublisher
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] name, journey in
            self?.rootView.updateText(nickname: name, journey: journey)
            self?.journeyType = JourneyType.titleToEnum(journey) ?? .recording
        }
        .store(in: &cancellables)
    }
}

extension FinishJourneyViewController: Dismissible {
    func close() {
        if let tabBarController {
            navigationController?.popViewController(animated: false)
            ViewControllerUtils.changeSelectedIndex(index: 0)
        }
    }
}

extension FinishJourneyViewController {
    @objc
    private func startButtonDidTap() {
        let viewController = ViewControllerFactory.shared.makeNewJourneySelectViewController()
        viewController.hidesBottomBarWhenPushed = true
        
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        navigationController.pushViewController(viewController, animated: false)
    }
    
    @objc
    private func lookBackButtonDidTap() {
        let viewController = ViewControllerFactory.shared.makeLookBackJourneyViewController()
        viewController.hidesBottomBarWhenPushed = true
        
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        navigationController.pushViewController(viewController, animated: false)
    }
    
    @objc
    private func homeLabelDidTap() {
        guard let navigationController else {
            ByeBooLogger.error(ByeBooError.navigationControllerMissing)
            return
        }
        
        ViewControllerUtils.changeSelectedIndex(index: 0)
    }
}
