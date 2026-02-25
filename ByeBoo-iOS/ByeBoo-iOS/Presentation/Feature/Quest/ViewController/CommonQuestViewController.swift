//
//  CommonQuestViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/12/26.
//

import UIKit

final class CommonQuestViewController: BaseViewController {
    
    private let rootView = CommonQuestView()
    private let viewModel: CommonQuestViewModel
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = viewModel.action(.viewDidLoad)
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
        
    }
    
    func dateDidChanged(to date: String) {
        let _ = viewModel.action(
            .moveDateButtonDidTap(selectedDate: date)
        ).commonQuestAnswers
        rootView.commonQuestTableView.reloadData()
    }
}

extension CommonQuestViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || !viewModel.isExistAnswer {
            return
        }
        
        let answerIndex = indexPath.row - 1
        let answer = viewModel.getAnswer(at: answerIndex)
        
        let historyViewController = ViewControllerFactory.shared.makeCommonQuestHistoryViewController()
        historyViewController.configure(
            question: viewModel.question,
            writtenAt: answer.writtenAt,
            profileIcon: viewModel.getProfileIcon(at: answerIndex),
            nickname: answer.writer,
            content: answer.content
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
        indexPath.row == 0 ? 141.adjustedH : 171.adjustedH
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
        
        return navigator
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        76.adjustedH
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
        let writtenAt = DateFormatter.standard.string(from: viewModel.getWrittenAt(at: indexPath.row - 1))
        
        cell.bind(
            profileIcon: profileIcon,
            answer: answer,
            writtenAt: writtenAt
        )
        
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
