//
//  ProcessedWalkInteractor.swift
//  SniffMeet
//
//  Created by sole on 12/4/24.
//

import Foundation

protocol ProcessedWalkInteractable: AnyObject {
    var presenter: (any ProcessedWalkInteractorOutput)? { get set }
    func fetchSenderInfo(userId: UUID)
    func fetchProfileImage(urlString: String)
    func convertLocationToText(latitude: Double, longtitude: Double)
}

final class ProcessedWalkInteractor: ProcessedWalkInteractable {
    weak var presenter: (any ProcessedWalkInteractorOutput)?
    private let convertLocationToTextUseCase: any ConvertLocationToTextUseCase
    private let requestUserInfoUseCase: RequestMateInfoUseCase
    private let requestProfileImageUseCase: RequestProfileImageUseCase

    init(
        presenter: (any ProcessedWalkInteractorOutput)? = nil,
        convertLocationToTextUseCase: any ConvertLocationToTextUseCase,
        requestUserInfoUseCase: any RequestMateInfoUseCase,
        requestProfileImageUseCase: any RequestProfileImageUseCase
    ) {
        self.presenter = presenter
        self.convertLocationToTextUseCase = convertLocationToTextUseCase
        self.requestUserInfoUseCase = requestUserInfoUseCase
        self.requestProfileImageUseCase = requestProfileImageUseCase
    }

    func fetchSenderInfo(userId: UUID) {
        Task {
            do {
                guard let senderInfo = try await requestUserInfoUseCase.execute(
                    mateId: userId
                ) else {
                    presenter?.didFailToFetchWalkRequest(
                        error: SupabaseError.notFound
                    )
                    return
                }
                presenter?.didFetchUserInfo(senderInfo: senderInfo)
                guard let profileImageURL = senderInfo.profileImageURL else { return }
                fetchProfileImage(urlString: profileImageURL)
            } catch {
                presenter?.didFailToFetchWalkRequest(error: error)
            }
        }
    }
    func fetchProfileImage(urlString: String) {
        Task { [weak self] in
            let imageData = try await self?.requestProfileImageUseCase.execute(fileName: urlString)
            self?.presenter?.didFetchProfileImage(with: imageData)
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
