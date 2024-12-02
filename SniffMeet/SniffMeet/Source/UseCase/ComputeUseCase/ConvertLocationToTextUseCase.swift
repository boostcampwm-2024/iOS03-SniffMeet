//
//  ConvertLocationToTextUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

import CoreLocation

protocol ConvertLocationToTextUseCase {
    func execute(latitude: Double, longtitude: Double) async -> String?
}

struct ConvertLocationToTextUseCaseImpl: ConvertLocationToTextUseCase {
    private let geoCoder: CLGeocoder = CLGeocoder()

    func execute(latitude: Double, longtitude: Double) async -> String? {
        let placemarks = try? await geoCoder.reverseGeocodeLocation(
            CLLocation(latitude: latitude, longitude: longtitude),
            preferredLocale: .current
        )
        return placemarks?.first?.name
    }
}
