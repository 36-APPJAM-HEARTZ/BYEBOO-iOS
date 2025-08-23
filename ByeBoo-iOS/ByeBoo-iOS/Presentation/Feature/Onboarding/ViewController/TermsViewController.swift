//
//  TermsViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/18/25.
//

import SafariServices
import UIKit

final class TermsViewController: BaseViewController {
    
    private let rootView = TermsView()
    
    override func loadView() {
        view = rootView
    }
    
    override func setAddTarget() {
        rootView.allCheckButton.addTarget(
            self,
            action: #selector(allCheckButtonDidTap),
            for: .touchUpInside
        )
        rootView.serviceAgreeView.checkButton.addTarget(
            self,
            action: #selector(detailCheckButtonDidTap),
            for: .touchUpInside
        )
        rootView.privacyAgreeView.checkButton.addTarget(
            self,
            action: #selector(detailCheckButtonDidTap),
            for: .touchUpInside
        )
        rootView.ageAgreeView.checkButton.addTarget(
            self,
            action: #selector(detailCheckButtonDidTap),
            for: .touchUpInside
        )
        rootView.serviceAgreeView.viewMoreButton.addTarget(
            self,
            action: #selector(serviceViewMoreButtonDidTap),
            for: .touchUpInside
        )
        rootView.privacyAgreeView.viewMoreButton.addTarget(
            self,
            action: #selector(privacyViewMoreButtonDidTap),
            for: .touchUpInside
        )
        rootView.moveNextButton.addTarget(
            self,
            action: #selector(moveNextButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension TermsViewController {
    
    @objc
    private func allCheckButtonDidTap() {
        rootView.toggleAllAgree()
    }
    
    @objc
    private func detailCheckButtonDidTap(_ sender: UIButton) {
        guard let detailAgreeView = sender.superview as? DetailTermsView else { return }
        detailAgreeView.isChecked.toggle()
        rootView.updateAllAgreeState()
    }
    
    @objc
    private func serviceViewMoreButtonDidTap() {
        ExternalLink.serviceTerm.openURL(for: self)
    }
    
    @objc
    private func privacyViewMoreButtonDidTap() {
        ExternalLink.serviceTerm.openURL(for: self)
    }
    
    @objc
    private func moveNextButtonDidTap() {
        guard let viewModel = DIContainer.shared.resolve(type: InformationViewModel.self) else {
            ByeBooLogger.error(ByeBooError.DIFailedError)
            fatalError()
        }
        let informationViewController = InformationViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(informationViewController, animated: true)
    }
}
