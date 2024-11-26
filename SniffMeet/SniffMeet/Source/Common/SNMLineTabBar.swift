//
//  SNMLineTabBar.swift
//  SniffMeet
//
//  Created by sole on 11/23/24.
//

import Combine
import UIKit

final class SNMLineTabBar: BaseView {
    private var cancellables: Set<AnyCancellable> = []
    private let underlineView: UIView = UIView()
    private let segmentControl: UISegmentedControl
    private var underlineLeadingConstraint: NSLayoutConstraint?

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: segmentControl.bounds.width,
            height: segmentControl.bounds.height + LayoutConstant.xsmallVerticalPadding + 4
        )
    }

    init(tabBarItems: [String]) {
        self.segmentControl = UISegmentedControl(items: tabBarItems)
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureAttributes() {
        underlineView.backgroundColor = SNMColor.mainNavy
        segmentControl.selectedSegmentIndex = 0
        segmentControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.black],
            for: .selected
        )
        segmentControl.setTitleTextAttributes(
            [.font: SNMFont.headline,
             .foregroundColor: SNMColor.text1],
            for: .normal
        )
        let transparentImage: UIImage = UIImage()
        segmentControl.setBackgroundImage(transparentImage, for: .normal, barMetrics: .default)
        segmentControl.setBackgroundImage(transparentImage, for: .selected, barMetrics: .default)
        segmentControl.setBackgroundImage(transparentImage, for: .highlighted, barMetrics: .default)
        segmentControl.setDividerImage(
            transparentImage,
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .default
        )
    }
    override func configureHierarchy() {
        [segmentControl,
         underlineView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    override func configureConstraints() {
        underlineLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: leadingAnchor)
        underlineLeadingConstraint?.isActive = true

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: SNMFont.headline.lineHeight),
            underlineView.topAnchor.constraint(
                equalTo: segmentControl.bottomAnchor,
                constant: LayoutConstant.xsmallVerticalPadding
            ),
            underlineView.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 1 / CGFloat(segmentControl.numberOfSegments)
             ),
            underlineView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    override func bind() {
        segmentControl.publisher(for: \.selectedSegmentIndex)
            .sink { [weak self] _ in
                self?.updateUnderLineViewConstraints()
            }
            .store(in: &cancellables)
    }

    private func updateUnderLineViewConstraints() {
        underlineLeadingConstraint?.constant = bounds.width /
        CGFloat(segmentControl.numberOfSegments) * CGFloat(segmentControl.selectedSegmentIndex)
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self else { return }
            self.layoutIfNeeded()
        }
    }
    func selectTab(index: Int) {
        guard index < segmentControl.numberOfSegments else { return }
        segmentControl.selectedSegmentIndex = index
    }
}

// MARK: - SNMLineTabBar+Publisher

extension SNMLineTabBar {
    func valueChangedPublisher() -> AnyPublisher<Int, Never> {
        segmentControl.publisher(for: \.selectedSegmentIndex)
            .eraseToAnyPublisher()
    }
}
