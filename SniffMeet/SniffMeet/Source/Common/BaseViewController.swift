//
//  BaseViewController.swift
//  SniffMeet
//
//  Created by sole on 11/12/24.
//

import UIKit

class BaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureAttributes()
        configureHierachy()
        configureConstraints()
        bind()
    }

    func configureAttributes() {}
    func configureHierachy() {}
    func configureConstraints() {}
    func bind() {}
}
