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
        setGesture()
        
        rootView.allCheckButton.addTarget(
            self,
            action: #selector(allCheckButtonDidTap),
            for: .touchUpInside
        )
        [rootView.serviceAgreeView, rootView.privacyAgreeView, rootView.ageAgreeView].forEach {
            $0.checkButton.addTarget(
                self,
                action: #selector(detailCheckButtonDidTap),
                for: .touchUpInside
            )
        }
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
    
    private func setGesture() {
        let allAgreeTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(allAgreeDidTap(_:)))
        rootView.allAgreeView.addGestureRecognizer(allAgreeTapRecognizer)
        rootView.allAgreeView.isUserInteractionEnabled = true
        
        [rootView.serviceAgreeView, rootView.privacyAgreeView, rootView.ageAgreeView].forEach {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailAgreeDidTap(_:)))
            $0.addGestureRecognizer(tapRecognizer)
            $0.isUserInteractionEnabled = true
        }
    }
}

extension TermsViewController {
    
    @objc
    private func allAgreeDidTap(_ gesture: UITapGestureRecognizer) {
        guard let _ = gesture.view else { return }
        rootView.toggleAllAgree()
    }
    
    @objc
    private func allCheckButtonDidTap() {
        rootView.toggleAllAgree()
    }
    
    @objc
    private func detailAgreeDidTap(_ gesture: UITapGestureRecognizer) {
        guard let detailAgreeView = gesture.view as? DetailTermsView else { return }
        detailAgreeView.isChecked.toggle()
        rootView.updateAllAgreeState()
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
        ExternalLink.privacyPolicy.openURL(for: self)
    }
    
    @objc
    private func moveNextButtonDidTap() {
        let viewController = ViewControllerFactory.shared.makeInformationViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
