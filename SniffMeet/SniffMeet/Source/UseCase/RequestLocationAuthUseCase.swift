//
//  RequestLocationAuthUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

import CoreLocation

protocol RequestLocationAuthUseCase {
    func execute() throws
}

struct RequestLocationAuthUseCaseImpl: RequestLocationAuthUseCase {
    private let locationManager: CLLocationManager

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func execute() throws {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            throw LocationManagerError.authorizationRestricted
        case .denied:
            throw LocationManagerError.authorizationDenied
        case .authorizedAlways,
                .authorizedWhenInUse:
            break
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

enum LocationManagerError: Error {
    case authorizationDenied
    case authorizationRestricted
}
