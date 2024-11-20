//
//  ConvertLocationToTextUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

import CoreLocation

protocol ConvertLocationToTextUseCase {
    func execute(location: CLLocation) async -> String?
}

struct ConvertLocationToTextUseCaseImpl: ConvertLocationToTextUseCase {
    private let geoCoder: CLGeocoder

    init(geoCoder: CLGeocoder) {
        self.geoCoder = geoCoder
    }

    func execute(location: CLLocation) async -> String? {
        let placemarks = try? await geoCoder.reverseGeocodeLocation(
            location,
            preferredLocale: .current
        )
        return placemarks?.first?.name
    }
}
