//
//  LoginViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/19/25.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    private let rootView = LoginView()
    
    override func viewDidLoad() {
        view = rootView
    }
}
