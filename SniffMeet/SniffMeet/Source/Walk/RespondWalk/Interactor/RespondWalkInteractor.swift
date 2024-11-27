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
    var requestUserInfoUseCase: RequestUserInfoUseCase { get }
    var respondWalkRequestUseCase: RespondWalkRequestUseCase { get }
    var calculateTimeLimitUseCase: CalculateTimeLimitUseCase { get }
    var convertLocationToTextUseCase: ConvertLocationToTextUseCase { get }
    var requestProfileImageUseCase: RequestProfileImageUseCase { get }
    
    func fetchSenderInfo(userId: UUID)
    func respondWalkRequest(walkNotiId: UUID, isAccepted: Bool)
    func calculateTimeLimit(requestTime: Date)
    func convertLocationToText(latitude: Double, longtitude: Double) async
    func fetchProfileImage()
}

final class RespondWalkInteractor: RespondWalkInteractable {
    weak var presenter: (any RespondWalkInteractorOutput)?
    var requestUserInfoUseCase: RequestUserInfoUseCase
    var respondWalkRequestUseCase: RespondWalkRequestUseCase
    var calculateTimeLimitUseCase: CalculateTimeLimitUseCase
    var convertLocationToTextUseCase: ConvertLocationToTextUseCase
    var requestProfileImageUseCase: RequestProfileImageUseCase
    
    init(presenter: (any RespondWalkInteractorOutput)? = nil,
         requestUserInfoUseCase: RequestUserInfoUseCase,
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
        do {
            let senderInfo = try requestUserInfoUseCase.execute(userId: userId) // 아마 await
            presenter?.didFetchUserInfo(senderInfo: senderInfo)
        } catch {
            presenter?.didFailToFetchWalkRequest(error: error)
        }
    }
    
    func respondWalkRequest(walkNotiId: UUID, isAccepted: Bool) {
        do {
            try respondWalkRequestUseCase.execute(walkNotiId: walkNotiId, isAccepted: isAccepted)
            presenter?.didSendWalkRespond()
        } catch {
            presenter?.didFailToSendWalkRequest(error: error)
        }
    }
    
    func calculateTimeLimit(requestTime: Date) {
        let timeDifference = calculateTimeLimitUseCase.execute(requestTime: requestTime)
        presenter?.didCalculateTimeLimit(secondDifference: timeDifference)
        
    }
    func convertLocationToText(latitude: Double, longtitude: Double) async {
        Task {
            let locationText: String? = await convertLocationToTextUseCase.execute(
                location: CLLocation(latitude: latitude, longitude: longtitude)
            )
            presenter?.didConvertLocationToText(with: locationText)
        }
    }
    
    func fetchProfileImage() {
        Task { [weak self] in
            let imageData = await requestProfileImageUseCase.execute()
            self?.presenter?.didFetchProfileImage(with: imageData)
        }
    }
}
