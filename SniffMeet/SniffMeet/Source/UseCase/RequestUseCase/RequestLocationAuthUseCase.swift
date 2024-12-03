//
//  RequestLocationAuthUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

import CoreLocation

protocol RequestLocationAuthUseCase {
    func execute()
}

struct RequestLocationAuthUseCaseImpl: RequestLocationAuthUseCase {
    private let locationManager: CLLocationManager

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func execute() {
        locationManager.requestWhenInUseAuthorization()
    }
}
