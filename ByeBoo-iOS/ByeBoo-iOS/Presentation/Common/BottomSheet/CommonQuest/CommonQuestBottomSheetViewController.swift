//
//  CommonQuestBottomSheetViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/23/26.
//

import Combine
import UIKit

protocol EditCommonQuestProtocol: AnyObject {
    func didTapCommonQuestEdit(
        answerID: Int,
        answer: String,
        question: String,
        writtenAt: String
    )
    func didTapCommentEdit(commentID: Int, content: String)
}

protocol BlockReportProtocol: AnyObject {
    func completeBlockReport(type: CommonQuestArchiveType.Action)
}

protocol DeleteCommonQuestDelegate: AnyObject {
    func completeDeleteCommonQuest(deletedID: Int)
}

final class CommonQuestBottomSheetViewController: BaseViewController {
    
    private let yesAnswer = "예"
    private let noAnswer = "아니오"
    
    private var rootView = CommonQuestBottomSheetView(sheetType: .otherAnswer)
    private let viewModel: CommonQuestBottomSheetViewModel
    private var writerID: Int = 0
    private var cancellables = Set<AnyCancellable>()
    private(set) var targetID: Int?
    private(set) var answer: String?
    private(set) var content: String?
    private(set) var question: String?
    private(set) var writtenAt: String?
    
    var sheetType: CommonQuestArchiveType?
    var action: CommonQuestArchiveType.Action?
    
    weak var blockDelegate: BlockReportProtocol?
    weak var editDelegate: EditCommonQuestProtocol?
    weak var deleteDelegate: DeleteCommonQuestDelegate?
    
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
}

extension CommonQuestBottomSheetViewController {
    
    func configureWhenQuestEdit(
        sheeetType: CommonQuestArchiveType,
        answerID: Int? = nil,
        answer: String? = nil,
        question: String? = nil,
        writtenAt: String? = nil
    ) {
        self.sheetType = sheeetType
        self.targetID = answerID
        self.answer = answer
        self.question = question
        self.writtenAt = writtenAt
    }
    
    
    func configureWhenComment(
        sheetType: CommonQuestArchiveType,
        targetID: Int,
        writerID: Int,
        content: String? = nil
    ) {
        self.sheetType = sheetType
        self.targetID = targetID
        self.writerID = writerID
        self.content = content
        rootView = CommonQuestBottomSheetView(sheetType: sheetType)
    }
    
    @objc
    private func sheetItemDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        guard let tappedView = tapRecognizer.view,
              let sheetType = sheetType else { return }
        
        let index = tappedView.tag
        guard sheetType.items.indices.contains(index) else { return }
        
        action = sheetType.items[index].action
        
        switch action {
        case .questEdit:
            guard let targetID, let answer, let question, let writtenAt else { return }
            
            dismiss(animated: false) { [weak self] in
                self?.editDelegate?.didTapCommonQuestEdit(
                    answerID: targetID,
                    answer: answer,
                    question: question,
                    writtenAt: writtenAt
                )
            }
        case .commentEdit:
            guard let targetID, let content else { return }
            dismiss(animated: false) { [weak self] in
                self?.editDelegate?.didTapCommentEdit(commentID: targetID, content: content)
            }
        case .delete:
            guard let targetID else { return }
            if sheetType == .myAnswer || sheetType == .otherAnswer {
                presentDeleteQuestModal(answerID: targetID, targetType: .COMMON_QUEST)
            } else {
                presentDeleteQuestModal(answerID: targetID, targetType: .COMMENT)
            }
        case .block:
            viewModel.action(.block(userID: writerID))
        case .report:
            guard let targetID else { return }
            if sheetType == .myAnswer || sheetType == .otherAnswer {
                viewModel.action(.report(targetID: targetID, targetType: .COMMON_QUEST))
            } else {
                viewModel.action(.report(targetID: targetID, targetType: .COMMENT))
            }
        default:
            return
        }
    }
    
    @objc
    private func dismissButtonDidTap() {
        presentingViewController?.dismiss(animated: true)
    }
    
    private func presentDeleteQuestModal(answerID: Int, targetType: CommonQuestTargetType) {
        let modalView = createModalView()
        let action: () -> Void = { self.viewModel.action(.delete(targetID: answerID, targetType: targetType)) }
        
        ModalBuilder(
            modalView: modalView,
            action: action,
            rootViewController: self
        ).present()
    }
    
    private func createModalView() -> ConfirmModalView {
        let dismissButton: ByeBooButton? = ByeBooButton(titleText: noAnswer, type: .outline)
        let actionButton = ByeBooButton(titleText: yesAnswer, type: .enabled)
        return ConfirmModalView(
            modalType: .delete,
            dismissButton: dismissButton,
            actionButton: actionButton
        )
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
                    self.blockDelegate?.completeBlockReport(type: .block)
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
                    self.blockDelegate?.completeBlockReport(type: .report)
                    self.dismiss(animated: false)
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.deleteQuestPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success():
                    ByeBooLogger.debug("삭제 성공")
                    guard let self else { return }
                    let deleteDelegate = self.deleteDelegate
                    self.dismiss(animated: false) {
                        guard let deletedID = self.targetID else { return }
                        deleteDelegate?.completeDeleteCommonQuest(deletedID: deletedID)
                    }
                case .failure(let error):
                    ByeBooLogger.debug(error)
                }
            }
            .store(in: &cancellables)
    }
}
