//
//  CommonQuestBottomSheetViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/23/26.
//

import Combine
import UIKit

protocol BlockReportProtocol: AnyObject {
    func completeBlockReport(type: CommonQuestArchiveType.Action)
}

final class CommonQuestBottomSheetViewController: BaseViewController {
    
    private var rootView = CommonQuestBottomSheetView(sheetType: .other)
    private let viewModel: CommonQuestBottomSheetViewModel
    private var answerID: Int = 0
    private var userID: Int = 0
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: BlockReportProtocol?
    var sheetType: CommonQuestArchiveType?
    var action: CommonQuestArchiveType.Action?
    
    init(viewModel: CommonQuestBottomSheetViewModel) {
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
    }
    
    override func setAddTarget() {
        rootView.dismissButton.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        rootView.itemList.enumerated().forEach { index, item in
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sheetItemDidTap(_:)))
            item.tag = index
            item.addGestureRecognizer(tapRecognizer)
            item.isUserInteractionEnabled = true
        }
    }
    
    
    func configure(sheeetType: CommonQuestArchiveType) {
        self.sheetType = sheeetType
        if let sheetType {
            rootView = CommonQuestBottomSheetView(sheetType: sheetType)
        }
    }
    
    @objc
    private func sheetItemDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        guard let tappedView = tapRecognizer.view,
        let sheetType = sheetType else { return }
        
        let index = tappedView.tag
        guard sheetType.items.indices.contains(index) else { return }
        
        action = sheetType.items[index].action
        
        switch action {
        case .edit:
            // TODO: 수정하기
            ByeBooLogger.debug("edit")
        case .delete:
            // TODO: 삭제하기
            ByeBooLogger.debug("delete")
        case .block:
            viewModel.action(.block(userID: userID))
        case .report:
            viewModel.action(.report(answerID: answerID))
        default:
            return
        }
    }
    
    @objc
    private func dismissButtonDidTap() {
        presentingViewController?.dismiss(animated: true)
    }
}

extension CommonQuestBottomSheetViewController {
    private func bind() {
        viewModel.output.blockUserPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success():
                    ByeBooLogger.debug("차단 성공")
                    self.dismiss(animated: false)
                    self.delegate?.completeBlockReport(type: .block)
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.reportQuestPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success():
                    ByeBooLogger.debug("신고 성공")
                    self.delegate?.completeBlockReport(type: .report)
                    self.dismiss(animated: false)
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellables)
    }
}
