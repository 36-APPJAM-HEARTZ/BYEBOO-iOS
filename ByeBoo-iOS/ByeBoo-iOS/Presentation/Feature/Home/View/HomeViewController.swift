//
//  HomeViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/5/25.
//

import UIKit

import SnapKit
import Then

final class HomeViewController: BaseViewController {
    
    private let rootView = HomeView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
