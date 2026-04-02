//
//  CommonQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/12/26.
//

import Combine
import UIKit

import Mixpanel

final class CommonQuestViewController: BaseViewController {
    
    private let rootView = CommonQuestView()
    private let viewModel: CommonQuestViewModel
    
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: CommonQuestViewModel) {
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.action(.viewWillAppear)
        
        Mixpanel.mainInstance().track(event: CommonJourneyEvents.Name.commonJourneyPageview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func setAddTarget() {
        rootView.headerView.historyButton.addTarget(
            self,
            action: #selector(myAnswerHistoryButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func setDelegate() {
        rootView.commonQuestTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(CommonQuestAnswerCell.self)
            $0.register(CommonQuestContentCell.self)
            $0.register(NoAnswerCell.self)
            $0.register(
                DateNavigator.self,
                forHeaderFooterViewReuseIdentifier: DateNavigator.identifier
            )
        }
    }
}

extension CommonQuestViewController {
    
    func bind() {
        viewModel.output.commonQuestPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.rootView.commonQuestTableView.reloadData()
                case .failure(let error):
                    ByeBooLogger.error(error)
                }
            }
            .store(in: &cancellable)
    }
}

extension CommonQuestViewController: DateNavigatorDelegate {
    
    @objc
    private func myAnswerHistoryButtonDidTap() {
        let myAnswersViewController = ViewControllerFactory.shared.makeCommonQuestMyAnswersViewController()
        myAnswersViewController.navigationItem.hidesBackButton = true
        
        self.navigationController?.pushViewController(
            myAnswersViewController,
            animated: false
        )
    }
    
    @objc
    private func moveWriteAnswerButtonDidTap() {
        let questID = viewModel.questID
        let writeCommonQuestViewController = ViewControllerFactory.shared.makeWriteQuestionTypeQuestViewController()
        writeCommonQuestViewController.navigationItem.hidesBackButton = true
        writeCommonQuestViewController.questScope = .common
        writeCommonQuestViewController.configureToWrite(questID, nil, QuestType.question, viewModel.question)
        self.navigationController?.pushViewController(writeCommonQuestViewController, animated: false)
        
        Mixpanel.mainInstance().track(event: CommonJourneyEvents.Name.commonJourneyWriteClick)
    }
    
    func dateDidChanged(to date: Date) {
        let _ = viewModel.action(
            .moveDateButtonDidTap(selectedDate: DateFormatter.toAPIDateString(from: date))
        )
    }
}

extension CommonQuestViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || !viewModel.isExistAnswer {
            return
        }
        
        let answerIndex = indexPath.row - 1
        guard let answer = viewModel.getAnswer(at: answerIndex) else {
            return
        }
        
        let formattedWrittenAt = DateFormatter.toDetailDate(from: answer.writtenAt).map {
            DateFormatter.toDisplayDateString(from: $0)
        }
        
        guard let formattedWrittenAt else {
            return
        }
        
        let historyViewController = ViewControllerFactory.shared.makeCommonQuestHistoryViewController()
        historyViewController.configure(
            question: viewModel.question,
            writtenAt: formattedWrittenAt,
            profileIcon: viewModel.getProfileIcon(at: answerIndex),
            nickname: answer.writer,
            content: answer.content,
            answerID: answer.answerID,
            writerID: answer.writerID,
            isMyAnswer: answer.isMyAnswer
        )
        historyViewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(
            historyViewController,
            animated: false
        )
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        indexPath.row == 0 ? UITableView.automaticDimension : 171.adjustedH
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let navigator = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: DateNavigator.identifier
        ) as? DateNavigator else {
            return nil
        }
        
        navigator.delegate = self
        return navigator
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        76.adjustedH
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let prefetchOffset = 3
        let trigger = max(1, viewModel.currentAnswerCount - prefetchOffset)
        
        guard cell is CommonQuestAnswerCell,
              viewModel.hasMorePages,
              indexPath.row == trigger
        else {
            return
        }
        
        viewModel.action(.scrollAnswer)
    }
}

extension CommonQuestViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if viewModel.isExistAnswer {
            return 1 + viewModel.answersCount
        }
        return 2
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if indexPath.row == .zero {
            return dequeueQuestContentCell(from: tableView, indexPath: indexPath)
        }
        if viewModel.isExistAnswer {
            return dequeueQuestAnswerCell(from: tableView, indexPath: indexPath)
        }
        return dequeueNoAnswerCell(from: tableView, indexPath: indexPath)
    }
    
    private func dequeueQuestContentCell(
        from tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: CommonQuestContentCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.bind(
            isAnswered: viewModel.isUserAnswered,
            question: viewModel.question,
            answersCount: viewModel.answersCount
        )
        cell.moveWriteAnswerButton.addTarget(
            self,
            action: #selector(moveWriteAnswerButtonDidTap),
            for: .touchUpInside
        )
        
        return cell
    }
    
    private func dequeueQuestAnswerCell(
        from tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: CommonQuestAnswerCell = tableView.dequeueReusableCell(for: indexPath)
        
        let answer = viewModel.getAnswer(at: indexPath.row - 1)
        let profileIcon = viewModel.getProfileIcon(at: indexPath.row - 1)
        let writtenAt = viewModel.getWrittenAt(at: indexPath.row - 1)
        
        if let answer,
           let writtenAt {
            cell.bind(
                profileIcon: profileIcon,
                answer: answer,
                writtenAt: writtenAt
            )
        }
        
        return cell
    }
    
    private func dequeueNoAnswerCell(
        from tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: NoAnswerCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
