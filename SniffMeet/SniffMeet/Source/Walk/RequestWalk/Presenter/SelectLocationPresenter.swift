//
//  SelectLocationPresenter.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

import Combine
import CoreLocation

protocol SelectLocationPresentable: AnyObject {
    var view: (any SelectLocationViewable)? { get set }
    var interactor: (any SelectLocationInteractable)? { get set }
    var router: (any SelectLocationRoutable)? { get set }
    var output: any SelectLocationPresenterOutput { get }

    func viewDidLoad()
    func didTapSelectCompleteButton()
    func didUpdateSelectLocation(location: CLLocation)
}

protocol SelectLocationInteractorOutput: AnyObject {
    func didConvertLocationToText(with: String?)
    func didSuccessRequestLocationAuth()
    func didFailToRequestLocationAuth(error: any Error)
    func didUpdateUserLocation(location: CLLocation)
}

final class SelectLocationPresenter: SelectLocationPresentable {
    weak var view: (any SelectLocationViewable)?
    var interactor: (any SelectLocationInteractable)?
    var router: (any SelectLocationRoutable)?
    let output: any SelectLocationPresenterOutput

    init(
        view: (any SelectLocationViewable)? = nil,
        output: any SelectLocationPresenterOutput = DefaultSelectLocationPresenterOutput(
            selectedCoordinate: CLLocation(latitude: 37.334886, longitude: -122.008988),
            locationLabel: CurrentValueSubject<String?, Never>(nil),
            userLocation: CurrentValueSubject<CLLocation, Never>(
                CLLocation(latitude: 37.334886, longitude: -122.008988) // default location
            )
        )
    ) {
        self.view = view
        self.output = output
    }

    func viewDidLoad() {
        interactor?.requestLocationAuth()
        let location = output.userLocation.value
        interactor?.convertLocationToText(with: location)
    }
    func didTapFocusUserLocationButton() {
        interactor?.requestUserLocation()
    }
    func didTapSelectCompleteButton() {
        guard let view else { return }
        let address: Address = Address(
            longtitude: output.selectedCoordinate.coordinate.latitude,
            latitude: output.selectedCoordinate.coordinate.latitude
        )
        router?.dismiss(from: view, with: address)
    }
    func didUpdateSelectLocation(location: CLLocation) {
        interactor?.convertLocationToText(with: location)
    }
    func didUpdateUserLocation(location: CLLocation) {
        output.userLocation.send(location)
    }
}

//MARK: - SelectLocationPresenter+SelectLocationInteractorOutput

extension SelectLocationPresenter: SelectLocationInteractorOutput {
    func didConvertLocationToText(with locationText: String?) {
        output.locationLabel.send(locationText)
    }
    func didSuccessRequestLocationAuth() {
        interactor?.requestUserLocation()
    }
    func didFailToRequestLocationAuth(error: any Error) {
        guard let view else { return }
        router?.showAlert(
            from: view,
            title: "위치 권한 거부",
            message: "유저 근처 위치를 받아올 수 없습니다. 설정에서 GPS를 허용해주세요."
        )
    }
}

//MARK: - SelectLocationPresenterOutput

protocol SelectLocationPresenterOutput {
    var selectedCoordinate: CLLocation { get }
    var locationLabel: CurrentValueSubject<String?, Never> { get }
    var userLocation: CurrentValueSubject<CLLocation, Never> { get }
}

struct DefaultSelectLocationPresenterOutput: SelectLocationPresenterOutput {
    var selectedCoordinate: CLLocation
    let locationLabel: CurrentValueSubject<String?, Never>
    let userLocation: CurrentValueSubject<CLLocation, Never>
}
