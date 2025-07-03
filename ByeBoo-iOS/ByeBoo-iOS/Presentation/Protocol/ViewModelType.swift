//
//  ViewModelType.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/1/25.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func action(_ trigger: Input)
}
