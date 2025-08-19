//
//  TermsViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/18/25.
//

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
        guard let detailAgreeView = sender.superview as? DetailAgreeView else { return }
        detailAgreeView.isChecked.toggle()
        rootView.updateAllAgreeState()
    }
    
    @objc
    private func serviceViewMoreButtonDidTap() {
        openURL(.termsOfService)
    }
    
    @objc
    private func privacyViewMoreButtonDidTap() {
        openURL(.privacyPolicy)
    }
    
    private func openURL(_ externalLink: ExternalLink) {
        guard let url = URL(string: externalLink.rawValue) else {
            ByeBooLogger.error(ByeBooError.URLError)
            return
        }
        UIApplication.shared.open(url) { isSucceed in
            if !isSucceed {
                ByeBooLogger.error(ByeBooError.cannotOpenPage)
            }
        }
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
