//
//  RespondMapViewController.swift
//  SniffMeet
//
//  Created by sole on 11/30/24.
//

import Combine
import MapKit

final class RespondMapViewController: BaseViewController {
    private var cancellables: Set<AnyCancellable> = []
    private let mapView: MKMapView = MKMapView()
    private let annotation: MKPointAnnotation = MKPointAnnotation()
    private let dismissButton: UIButton = UIButton()

    override func configureAttributes() {
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.tintColor = SNMColor.mainNavy

        let defaultCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: 37.334886, longitude: -122.008988
        )
        mapView.addAnnotation(annotation)
        mapView.setCenter(defaultCoordinate, animated: true)
        annotation.coordinate = defaultCoordinate
    }
    override func configureHierachy() {
        [mapView,
         dismissButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            dismissButton.widthAnchor.constraint(equalToConstant: LayoutConstant.iconSize),
            dismissButton.heightAnchor.constraint(equalToConstant: LayoutConstant.iconSize)
        ])
    }
    override func bind() {
        dismissButton.publisher(event: .touchUpInside)
            .sink { [weak self] _ in
                // self?.presenter?.didTapDismissButton()
            }
            .store(in: &cancellables)
    }

    private func updateCoordinate(latitude: Double, longtitude: Double) {
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: latitude, longitude: longtitude
        )
        mapView.setCenter(coordinate, animated: true)
        annotation.coordinate = coordinate
    }
}
