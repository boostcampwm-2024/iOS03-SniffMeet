//
//  RequestUserLocationUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

import CoreLocation

protocol RequestUserLocationUseCase {
    func execute() -> CLLocation?
}

final class RequestUserLocationUseCaseImpl: RequestUserLocationUseCase {
    private let locationManager: CLLocationManager

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }

    func execute() -> CLLocation? {
        locationManager.startUpdatingLocation()
        return locationManager.location
    }

    deinit {
        locationManager.stopUpdatingLocation()
    }
}
