//
//  SelectLocationRouter.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

import UIKit

protocol SelectLocationRoutable: AnyObject, Routable {
    var presenter: (any SelectLocationPresentable)? { get set }
    var delegate: (any SelectLocationRouterDelegate)? { get set }
    
    func dismiss(from: any SelectLocationViewable, with: Address?)
    func showAlert(from: any SelectLocationViewable, title: String, message: String)
}

protocol SelectLocationRouterDelegate: AnyObject {
    func didDismiss(router: any SelectLocationRoutable, address: Address?)
}

final class SelectLocationRouter: SelectLocationRoutable {
    weak var presenter: (any SelectLocationPresentable)?
    weak var delegate: (any SelectLocationRouterDelegate)?
    
    func dismiss(from: any SelectLocationViewable, with address: Address?) {
        guard let view = from as? UIViewController else { return }
        delegate?.didDismiss(router: self, address: address)
        dismiss(from: view, animated: true)
    }
    func showAlert(
        from view: any SelectLocationViewable,
        title: String,
        message: String
    ) {
        guard let view = view as? UIViewController else { return }
        let alertVC: UIAlertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let alertAction: UIAlertAction = UIAlertAction(title: "확인", style: .default)
        alertVC.addAction(alertAction)
        present(from: view, with: alertVC, animated: true)
    }
}

extension SelectLocationRouter: SelectLocationModuleBuildable {}
