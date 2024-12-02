//
//  SelectLocationViewController.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

import Combine
import CoreLocation
import MapKit
import UIKit

protocol SelectLocationViewable: AnyObject {
    var presenter: (any SelectLocationPresentable)? { get set }
}

final class SelectLocationViewController: BaseViewController, SelectLocationViewable {
    var presenter: (any SelectLocationPresentable)?
    private var cancellables: Set<AnyCancellable> = []
    private let mapView: MKMapView = {
        let mapView: MKMapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.cameraZoomRange = .init(
            minCenterCoordinateDistance: 1000,
            maxCenterCoordinateDistance: 5000
        )
        return mapView
    }()
    private let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
    private let locationLabel: UILabel = {
        let locationLabel: UILabel = UILabel(frame: .zero)
        locationLabel.backgroundColor = SNMColor.mainWhite
        locationLabel.textAlignment = .center
        locationLabel.layer.cornerRadius = 38 / 2
        locationLabel.clipsToBounds = true
        locationLabel.font = SNMFont.caption
        return locationLabel
    }()
    private let completeSelectButton: PrimaryButton = PrimaryButton(
        title: Context.selectButtonLabel
    )
    private let focusUserLocationButton: UIButton = {
        let focusUserLocationButton = UIButton(
            frame: .init(
                origin: .zero,
                size: CGSize(width: 52, height: 52)
            )
        )
        let iconImage: UIImage? = UIImage(systemName: Context.focusButtonImageName)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(SNMColor.mainNavy)
        focusUserLocationButton.setImage(iconImage, for: .normal)
        focusUserLocationButton.backgroundColor = SNMColor.mainWhite
        focusUserLocationButton.makeViewCircular()
        return focusUserLocationButton
    }()

    override func viewDidLoad() {
        // presenter -> Location Auth + Updating Location 후
        presenter?.viewDidLoad()
        super.viewDidLoad()
    }

    override func configureAttributes() {
        mapView.delegate = self
        mapView.setUserTrackingMode(.follow, animated: false)
        // annotation init
        mapView.addAnnotation(pointAnnotation)
        if let userLocation = presenter?.output.userLocation.value {
            pointAnnotation.coordinate = userLocation.coordinate
        }
        mapView.setCenter(pointAnnotation.coordinate, animated: true)
    }
    override func configureHierachy() {
        [mapView,
         locationLabel,
         focusUserLocationButton,
         completeSelectButton].forEach {
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
            locationLabel.bottomAnchor.constraint(
                equalTo: completeSelectButton.topAnchor,
                constant: -LayoutConstant.regularVerticalPadding
            ),
            locationLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: LayoutConstant.horizontalPadding
            ),
            locationLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -LayoutConstant.horizontalPadding
            ),
            locationLabel.heightAnchor.constraint(equalToConstant: 38),
            focusUserLocationButton.bottomAnchor.constraint(
                equalTo: locationLabel.topAnchor,
                constant: -LayoutConstant.mediumVerticalPadding
            ),
            focusUserLocationButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -LayoutConstant.horizontalPadding
            ),
            focusUserLocationButton.widthAnchor.constraint(equalToConstant: 52),
            focusUserLocationButton.heightAnchor.constraint(equalToConstant: 52),
            completeSelectButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -LayoutConstant.xlargeVerticalPadding
            ),
            completeSelectButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: LayoutConstant.horizontalPadding
            ),
            completeSelectButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -LayoutConstant.horizontalPadding
            )
        ])
    }
    override func bind() {
        presenter?.output.locationLabel
            .receive(on: RunLoop.main)
            .sink { [weak self] locationText in
                self?.locationLabel.text = locationText
            }
            .store(in: &cancellables)

        focusUserLocationButton.publisher(event: .touchUpInside)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self,
                      let location = self.presenter?.output.userLocation.value
                else { return }
                self.mapView.setCenter(
                    location.coordinate,
                    animated: true
                )
            }
            .store(in: &cancellables)

        completeSelectButton.publisher(event: .touchUpInside)
            .debounce(for: .seconds(EventConstant.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.presenter?.didTapSelectCompleteButton()
            }
            .store(in: &cancellables)
    }
}

// MARK: - SelectLocationViewController+MKMapViewDelegate

extension SelectLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        // user location annotation의 경우 무시
        guard !(annotation is MKUserLocation) else { return nil }
        let annotationView: MKPinAnnotationView = MKPinAnnotationView(
            annotation: annotation,
            reuseIdentifier: Context.draggableAnnotationIdentifier
        )
        annotationView.isDraggable = true
        annotationView.canShowCallout = false
        return annotationView
    }
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        didChange newState: MKAnnotationView.DragState,
        fromOldState oldState: MKAnnotationView.DragState
    ) {
        if let coordinate = view.annotation?.coordinate {
            let location: CLLocation = CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            presenter?.didUpdateSelectLocation(location: location)
        }
    }
}

private  extension SelectLocationViewController {
    enum Context {
        static let selectButtonLabel: String = "선택하기"
        static let focusButtonImageName: String = "dot.scope"
        static let draggableAnnotationIdentifier: String = "MKAnnotationView"
    }
}
