//
//  TestViewController.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/28/25.
//

import UIKit

class TestViewController: UIViewController {
    
    private let viewModel: TestViewModel
    
    init(viewModel: TestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
