//
//  CommonQuestMyAnswersViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import Combine
import UIKit

final class CommonQuestMyAnswersViewController: BaseViewController {
    
    private let rootView = CommonQuestMyAnswersView()
    private let viewModel: CommonQuestMyAnswerViewModel
    
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: CommonQuestMyAnswerViewModel) {
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
        tabBarController?.tabBar.isHidden = true
        viewModel.action(.viewWillAppear)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back(header: .black),
            action: #selector(back)
        )
        
        bind()
    }
    
    override func setDelegate() {
        rootView.answersTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(CommonQuestMyAnswerCell.self)
            $0.register(NoAnswerCell.self)
        }
    }
}

extension CommonQuestMyAnswersViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension CommonQuestMyAnswersViewController {
    
    private func bind() {
        bindName()
        bindCommonQuestAnswers()
    }
    
    private func bindName() {
        viewModel.output.namePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let name):
                    self?.rootView.configure(userName: name)
                case .failure(let error):
                    ByeBooLogger.error(error)
                }
            }
            .store(in: &cancellable)
    }
    
    private func bindCommonQuestAnswers() {
        viewModel.output.answersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.rootView.answersTableView.reloadData()
                case .failure(let error):
                    ByeBooLogger.error(error)
                }
            }
            .store(in: &cancellable)
    }
}

extension CommonQuestMyAnswersViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let answer = viewModel.getAnswer(at: indexPath.section) else {
            return
        }
        
        let historyViewController = ViewControllerFactory.shared.makeCommonQuestHistoryViewController()
        historyViewController.navigationItem.hidesBackButton = true
        historyViewController.configure(
            question: answer.question,
            writtenAt: answer.writtenAt,
            profileIcon: .relievedBadge,
            nickname: answer.nickname,
            content: answer.content,
            answerID: answer.answerID,
            isLiked: answer.isLiked,
            likeCount: answer.likeCount,
            commentCount: answer.commentCount
        )
        
        self.navigationController?.pushViewController(historyViewController, animated: false)
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if viewModel.answersCount == 0 {
            return UITableView.automaticDimension
        }
        return 149.adjustedH
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        UIView()
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        section == 0 ? 0 : 5.adjustedH
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let prefetchOffset = 3
        let trigger = max(1, viewModel.answersCount - prefetchOffset)
        
        guard cell is CommonQuestMyAnswerCell,
              viewModel.hasMorePages,
              indexPath.section == trigger
        else {
            return
        }
        
        viewModel.action(.scrollAnswer)
    }
}

extension CommonQuestMyAnswersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.answersCount == 0 ? 1 : viewModel.answersCount
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if viewModel.answersCount == 0 {
            let cell: NoAnswerCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.topConstraint?.update(inset: 185.adjustedH)
            return cell
        }
        
        guard let answer = viewModel.getAnswer(at: indexPath.section) else {
            return UITableViewCell()
        }
        
        let cell: CommonQuestMyAnswerCell = tableView.dequeueReusableCell(for: indexPath)
        cell.questContentView.delegate = self
        cell.bind(
            question: answer.question,
            content: answer.content,
            writtenAt: answer.writtenAt,
            isLiked: answer.isLiked,
            likeCount: answer.likeCount,
            commentCount: answer.commentCount
        )
        return cell
    }
}

extension CommonQuestMyAnswersViewController: CommonQuestLikeCommentProtocol {
    func likeButtonDidTap() {
        // TODO: like button
    }
}
