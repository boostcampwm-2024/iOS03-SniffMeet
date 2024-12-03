//
//  SelectLocationInteractor.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

protocol SelectLocationInteractable: AnyObject {
    var presenter: SelectLocationInteractorOutput? { get set }

    func requestUserLocationAuth()
    func convertLocationToText(latitude: Double, longtitude: Double)
}

final class SelectLocationInteractor: SelectLocationInteractable {
    weak var presenter: (any SelectLocationInteractorOutput)?
    private let convertLocationToTextUseCase: any ConvertLocationToTextUseCase
    private let requestLocationAuthUseCase: any RequestLocationAuthUseCase

    init(
        presenter: (any SelectLocationInteractorOutput)? = nil,
        convertLocationToTextUseCase: any ConvertLocationToTextUseCase,
        requestLocationAuthUseCase: any RequestLocationAuthUseCase
    ) {
        self.presenter = presenter
        self.convertLocationToTextUseCase = convertLocationToTextUseCase
        self.requestLocationAuthUseCase = requestLocationAuthUseCase
    }

    func requestUserLocationAuth() {
        requestLocationAuthUseCase.execute()
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
