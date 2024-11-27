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
    var fetchUserUseCase: FetchUserInfoUseCase { get }
    var respondUseCase: RespondWalkRequestUseCase { get }
    var calculateTimeLimitUseCase: CalculateTimeLimitUseCase { get }
    var convertLocationToTextUseCase: ConvertLocationToTextUseCase { get }
    
    func fetchSenderInfo(userId: UUID)
    func respondWalkRequest(walkNotiId: UUID, isAccepted: Bool)
    func calculateTimeLimit(requestTime: Date)
    func convertLocationToText(latitude: Double, longtitude: Double) async
}

final class RespondWalkInteractor: RespondWalkInteractable {
    weak var presenter: (any RespondWalkInteractorOutput)?
    var fetchUserUseCase: FetchUserInfoUseCase
    var respondUseCase: RespondWalkRequestUseCase
    var calculateTimeLimitUseCase: CalculateTimeLimitUseCase
    var convertLocationToTextUseCase: ConvertLocationToTextUseCase
    
    init(presenter: (any RespondWalkInteractorOutput)? = nil,
         fetchUserUseCase: FetchUserInfoUseCase,
         respondUseCase: RespondWalkRequestUseCase,
         calculateTimeLimitUseCase: CalculateTimeLimitUseCase,
         convertLocationToTextUseCase: ConvertLocationToTextUseCase
    )
    {
        self.presenter = presenter
        self.fetchUserUseCase = fetchUserUseCase
        self.respondUseCase = respondUseCase
        self.calculateTimeLimitUseCase = calculateTimeLimitUseCase
        self.convertLocationToTextUseCase = convertLocationToTextUseCase
    }
    
    func fetchSenderInfo(userId: UUID) {
        do {
            let senderInfo = try fetchUserUseCase.execute(userId: userId) // 아마 await
            presenter?.didFetchUserInfo(senderInfo: senderInfo)
        } catch {
            presenter?.didFailToFetchWalkRequest(error: error)
        }
    }
    
    func respondWalkRequest(walkNotiId: UUID, isAccepted: Bool) {
        do {
            try respondUseCase.execute(walkNotiId: walkNotiId, isAccepted: isAccepted)
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

}
