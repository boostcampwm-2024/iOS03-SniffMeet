//
//  RespondWalkInteractor.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
protocol RespondWalkInteractable: AnyObject {
    var presenter: RespondWalkInteractorOutput? { get set }
    var fetchRequestUseCase: FetchRequestUseCase { get }
    var respondUseCase: RespondWalkRequestUseCase { get }
    
    func fetchRequest(requestNum: Int)
    func respondWalkRequest(requestNum: Int, isAccepted: Bool)
}

final class RespondWalkInteractor: RespondWalkInteractable {
    weak var presenter: (any RespondWalkInteractorOutput)?
    var fetchRequestUseCase: FetchRequestUseCase
    var respondUseCase: RespondWalkRequestUseCase
    
    init(presenter: (any RespondWalkInteractorOutput)? = nil,
         fetchRequestUseCase: FetchRequestUseCase,
         respondUseCase: RespondWalkRequestUseCase)
    {
        self.presenter = presenter
        self.fetchRequestUseCase = fetchRequestUseCase
        self.respondUseCase = respondUseCase
    }
    
    func fetchRequest(requestNum: Int) {
        do {
           let request = try fetchRequestUseCase.execute(requestNum: requestNum) // 아마 await
            presenter?.didFetchWalkRequest(walkRequest: request)
        } catch {
            presenter?.didFailToFetchWalkRequest(error: error)
        }
    }
    
    func respondWalkRequest(requestNum: Int, isAccepted: Bool) {
        do {
            if isAccepted {
                try respondUseCase.accept(to: requestNum)
            } else {
                try respondUseCase.decline(to: requestNum)
            }
            presenter?.didSendWalkRequest()
        } catch {
            presenter?.didFailToSendWalkRequest(error: error)
        }
    }
}
