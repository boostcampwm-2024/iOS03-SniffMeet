//
//  BaseView.swift
//  SniffMeet
//
//  Created by sole on 11/12/24.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        
        configureAttributes()
        configureHierarchy()
        configureConstraints()
        bind()
    }
    
    /// frame이 zero로 설정됩니다.
    init() {
        super.init(frame: .zero)

        backgroundColor = .white

        configureAttributes()
        configureHierarchy()
        configureConstraints()
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAttributes() {}
    func configureHierarchy() {}
    func configureConstraints() {}
    func bind() {}
}
