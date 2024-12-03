//
//  RespondWalkInteractor.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import CoreLocation
import Foundation

protocol RespondWalkInteractable: AnyObject {
    var presenter: RespondWalkInteractorOutput? { get set }
    var requestUserInfoUseCase: RequestMateInfoUseCase { get }
    var respondWalkRequestUseCase: RespondWalkRequestUseCase { get }
    var calculateTimeLimitUseCase: CalculateTimeLimitUseCase { get }
    var convertLocationToTextUseCase: ConvertLocationToTextUseCase { get }
    var requestProfileImageUseCase: RequestProfileImageUseCase { get }
    
    func fetchSenderInfo(userId: UUID)
    func respondWalkRequest(walkNoti: WalkNotiDTO)
    func calculateTimeLimit(requestTime: Date)
    func convertLocationToText(latitude: Double, longtitude: Double) async
    func fetchProfileImage(urlString: String)
}

final class RespondWalkInteractor: RespondWalkInteractable {
    weak var presenter: (any RespondWalkInteractorOutput)?
    var requestUserInfoUseCase: RequestMateInfoUseCase
    var respondWalkRequestUseCase: RespondWalkRequestUseCase
    var calculateTimeLimitUseCase: CalculateTimeLimitUseCase
    var convertLocationToTextUseCase: ConvertLocationToTextUseCase
    var requestProfileImageUseCase: RequestProfileImageUseCase
    
    init(presenter: (any RespondWalkInteractorOutput)? = nil,
         requestUserInfoUseCase: RequestMateInfoUseCase,
         respondUseCase: RespondWalkRequestUseCase,
         calculateTimeLimitUseCase: CalculateTimeLimitUseCase,
         convertLocationToTextUseCase: ConvertLocationToTextUseCase,
         requestProfileImageUseCase: RequestProfileImageUseCase
    )
    {
        self.presenter = presenter
        self.requestUserInfoUseCase = requestUserInfoUseCase
        self.respondWalkRequestUseCase = respondUseCase
        self.calculateTimeLimitUseCase = calculateTimeLimitUseCase
        self.convertLocationToTextUseCase = convertLocationToTextUseCase
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
    
    func respondWalkRequest(walkNoti: WalkNotiDTO) {
        do {
            Task {
                try await respondWalkRequestUseCase.execute(walkNoti: walkNoti)
            }
            presenter?.didSendWalkRespond()
        }
    }
    
    func calculateTimeLimit(requestTime: Date) {
        let timeDifference = calculateTimeLimitUseCase.execute(requestTime: requestTime)
        presenter?.didCalculateTimeLimit(secondDifference: timeDifference)
        
    }
    func convertLocationToText(latitude: Double, longtitude: Double) async {
        Task {
            let locationText: String? = await convertLocationToTextUseCase.execute(
                latitude: latitude, longtitude: longtitude
            )
            presenter?.didConvertLocationToText(with: locationText)
        }
    }
    
    func fetchProfileImage(urlString: String) {
        Task { [weak self] in
            let imageData = try await self?.requestProfileImageUseCase.execute(fileName: urlString)
            self?.presenter?.didFetchProfileImage(with: imageData)
        }
    }
}
