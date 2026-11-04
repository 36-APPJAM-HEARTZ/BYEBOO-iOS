//
//  QuestTipViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Combine
import UIKit

import Mixpanel

final class QuestTipViewController: BaseViewController {
    
    private var rootView: QuestTipView?
    private let viewModel: QuestTipViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var questID: Int = 1
    private var questType: QuestType = .activation
    private var questNumber: Int = 0
    
    override func loadView() {
        view = rootView
    }
    
    init(viewModel: QuestTipViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .titleAndClose("퀘스트 작성 TIP", header: .black),
            action: #selector(closeButtonDidTap)
        )
        // 스택에 push된 경우에도 닫기 버튼만 보이도록 함
        self.navigationItem.hidesBackButton = true
        
        viewModel.action(.questTipDidLoad(questID: questID))
        bind()
        
        let property = QuestEvents.QuestTipProperty(questNumber: questNumber)
        Mixpanel.mainInstance().track(
            event: QuestEvents.Name.questTipPageView,
            properties: property.dictionary
        )
    }
}

extension QuestTipViewController {
    
    @objc
    func closeButtonDidTap() {
        // 전체 화면 모달로 띄운 경우 닫고, 스택에 push된 경우(작성 화면, 펼친 iPhone Duo의 오른쪽 칸) pop
        if navigationController?.viewControllers.first === self {
            self.dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: false)
        }
    }
}

extension QuestTipViewController {
    func bind(questID: Int, questType: QuestType, questNumber: Int) {
        self.questID = questID
        self.questType = questType
        rootView = QuestTipView(questType: questType)
        self.questNumber = questNumber
    }
}

extension QuestTipViewController: ToastPresentable, ToastErrorHandler {
    
    private func bind() {
        viewModel.output.questTipPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let entity):
                    self?.rootView?.bind(with: entity)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            .store(in: &cancellables)
    }
}
