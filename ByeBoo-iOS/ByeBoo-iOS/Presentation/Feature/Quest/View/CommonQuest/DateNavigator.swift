//
//  DateNavigator.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

import UIKit

protocol DateNavigatorDelegate: AnyObject {
    func dateDidChanged(to date: Date)
}

final class DateNavigator: UITableViewHeaderFooterView {
    
    private let calendar = Calendar.current
    private let yesterday: Int = -1
    private let tommorow: Int = 1
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
    private let minDate: Date
    
    weak var delegate: DateNavigatorDelegate?
    
    private(set) var currentDate: Date = .now
    private let navigatorStackView = UIStackView()
    private(set) var previousButton = UIButton()
    private let dateLabel = UILabel()
    private(set) var nextButton = UIButton()
    
    override init(reuseIdentifier: String?) {
        self.minDate = DateComponents(
            calendar: calendar,
            year: 2026,
            month: 4,
            day: 1
        ).date ?? .now
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.do {
            $0.backgroundView = UIView()
            $0.backgroundColor = .grayscale900
            $0.contentView.backgroundColor = .grayscale900
        }
        navigatorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 20
            $0.distribution = .fill
        }
        previousButton.do {
            $0.setImage(.previousOn, for: .normal)
            $0.backgroundColor = .white5
            $0.layer.cornerRadius = 16
        }
        dateLabel.applyByeBooFont(
            style: .body2M16,
            text: dateFormatter.string(from: currentDate),
            color: .grayscale50,
            textAlignment: .center
        )
        nextButton.do {
            $0.setImage(.nextOff, for: .normal)
            $0.backgroundColor = .white5
            $0.layer.cornerRadius = 16
            $0.isEnabled = true
        }
    }
    
    private func setUI() {
        addSubview(navigatorStackView)
        navigatorStackView.addArrangedSubviews(
            previousButton,
            dateLabel,
            nextButton
        )
    }
    
    private func setLayout() {
        navigatorStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.adjustedH)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24.adjustedH)
        }
        previousButton.snp.makeConstraints {
            $0.size.equalTo(32.adjustedW)
            $0.centerY.equalToSuperview()
        }
        dateLabel.snp.makeConstraints {
            $0.width.equalTo(58.adjustedW)
            $0.centerY.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.size.equalTo(32.adjustedW)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setAction() {
        previousButton.addTarget(
            self,
            action: #selector(moveYesterday),
            for: .touchUpInside
        )
        nextButton.addTarget(
            self,
            action: #selector(moveTomorrow),
            for: .touchUpInside
        )
    }
}

extension DateNavigator {
    
    @objc
    private func moveYesterday() {
        guard !isMinDate else { return }
        
        moveDay(to: yesterday)
    }
    
    @objc
    private func moveTomorrow() {
        moveDay(to: tommorow)
    }
    
    private func moveDay(to day: Int) {
        currentDate = getDate(by: day) ?? .now
        dateLabel.text = dateFormatter.string(from: currentDate)
        updateButtons()
        delegate?.dateDidChanged(to: currentDate)
    }
    
    private func getDate(by value: Int) -> Date? {
        calendar.date(byAdding: .day, value: value, to: currentDate)
    }
    
    private func updateButtons() {
        updatePreviousButton()
        updateNextButton()
    }
    
    private func updatePreviousButton() {
        let previousImage: UIImage = isMinDate ? .previousOff : .previousOn
        previousButton.setImage(previousImage, for: .normal)
        nextButton.isEnabled = !isMinDate
    }
    
    private func updateNextButton() {
        let nextImage: UIImage = isToday ? .nextOff : .nextOn
        nextButton.setImage(nextImage, for: .normal)
        nextButton.isEnabled = !isToday
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(currentDate)
    }
    
    private var isMinDate: Bool {
        calendar.isDate(currentDate, inSameDayAs: minDate)
    }
}
