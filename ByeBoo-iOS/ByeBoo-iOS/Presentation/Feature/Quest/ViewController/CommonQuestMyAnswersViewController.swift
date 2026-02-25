//
//  CommonQuestMyAnswersViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import UIKit

final class CommonQuestMyAnswersViewController: BaseViewController {
    
    private let rootView = CommonQuestMyAnswersView()
    private let viewModel: CommonQuestMyAnswerViewModel
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .back(header: .black),
            action: #selector(back)
        )
    }
    
    override func setDelegate() {
        rootView.answersTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(
                CommonQuestMyAnswerCell.self,
                forCellReuseIdentifier: CommonQuestMyAnswerCell.identifier
            )
            $0.register(
                NoAnswerCell.self,
                forCellReuseIdentifier: NoAnswerCell.identifier
            )
        }
    }
}

extension CommonQuestMyAnswersViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension CommonQuestMyAnswersViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let record = viewModel.getRecord(at: indexPath.section) else {
            return
        }
        
        let historyViewController = ViewControllerFactory.shared.makeCommonQuestHistoryViewController()
        historyViewController.navigationItem.hidesBackButton = true
        historyViewController.configure(
            question: record.question,
            writtenAt: record.writtenAt,
            content: record.answer
        )
        
        self.navigationController?.pushViewController(historyViewController, animated: false)
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if viewModel.dataCount == 0 {
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
}

extension CommonQuestMyAnswersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.dataCount == 0 ? 1 : viewModel.dataCount
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
        if viewModel.dataCount == 0 {
            let cell: NoAnswerCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.topConstraint?.update(inset: 185.adjustedH)
            return cell
        }
        
        let cell: CommonQuestMyAnswerCell = tableView.dequeueReusableCell(for: indexPath)
        
        guard let record = viewModel.getRecord(at: indexPath.section) else {
            return UITableViewCell()
        }
        
        cell.bind(
            question: record.question,
            content: record.answer,
            writtenAt: record.writtenAt
        )
        return cell
    }
}
