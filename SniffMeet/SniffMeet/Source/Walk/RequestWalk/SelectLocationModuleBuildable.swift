//
//  SelectLocationModuleBuildable.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

import UIKit
import CoreLocation

protocol SelectLocationModuleBuildable {
    static func build() -> UIViewController
}

extension SelectLocationModuleBuildable {
    static func build() -> UIViewController {
        let locationManager: CLLocationManager = CLLocationManager()
        let view: UIViewController & SelectLocationViewable = SelectLocationViewController()
        let interactor: SelectLocationInteractable = SelectLocationInteractor(
            convertLocationToTextUseCase: ConvertLocationToTextUseCaseImpl(
                geoCoder: CLGeocoder()
            ),
            requestLocationAuthUseCase: RequestLocationAuthUseCaseImpl(
                locationManager: locationManager
            ),
            requestUserLocationUseCase: RequestUserLocationUseCaseImpl(
                locationManager: locationManager
            )
        )
        let presenter: SelectLocationPresentable & SelectLocationInteractorOutput = SelectLocationPresenter()
        let router: SelectLocationRoutable = SelectLocationRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
}