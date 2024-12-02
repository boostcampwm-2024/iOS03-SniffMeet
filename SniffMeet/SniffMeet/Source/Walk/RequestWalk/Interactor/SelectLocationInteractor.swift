//
//  SelectLocationInteractor.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

protocol SelectLocationInteractable: AnyObject {
    var presenter: SelectLocationInteractorOutput? { get set }
    
    func requestLocationAuth()
    func requestUserLocation()
    func convertLocationToText(latitude: Double, longtitude: Double)
}

final class SelectLocationInteractor: SelectLocationInteractable {
    weak var presenter: (any SelectLocationInteractorOutput)?
    private let convertLocationToTextUseCase: any ConvertLocationToTextUseCase
    private let requestLocationAuthUseCase: any RequestLocationAuthUseCase
    private let requestUserLocationUseCase: any RequestUserLocationUseCase

    init(
        presenter: (any SelectLocationInteractorOutput)? = nil,
        convertLocationToTextUseCase: any ConvertLocationToTextUseCase,
        requestLocationAuthUseCase: any RequestLocationAuthUseCase,
        requestUserLocationUseCase: any RequestUserLocationUseCase
    ) {
        self.presenter = presenter
        self.convertLocationToTextUseCase = convertLocationToTextUseCase
        self.requestLocationAuthUseCase = requestLocationAuthUseCase
        self.requestUserLocationUseCase = requestUserLocationUseCase
    }

    func requestLocationAuth() {
        do {
            try requestLocationAuthUseCase.execute()
            presenter?.didSuccessRequestLocationAuth()
        } catch {
            presenter?.didFailToRequestLocationAuth(error: error)
        }
    }
    func requestUserLocation() {
        if let userLocation = requestUserLocationUseCase.execute() {
            presenter?.didUpdateUserLocation(location: userLocation)
        }
    }
    func convertLocationToText(latitude: Double, longtitude: Double) {
        Task {
            let locationText: String? = await convertLocationToTextUseCase.execute(
                latitude: latitude, longtitude: longtitude
            )
             presenter?.didConvertLocationToText(with: locationText)
        }
    }
}
