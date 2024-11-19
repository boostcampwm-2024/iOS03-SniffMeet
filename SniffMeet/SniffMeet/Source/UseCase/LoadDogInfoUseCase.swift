//
//  LoadInfoUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/18/24.
//

protocol LoadDogInfoUseCase {
    func execute() throws -> Dog
}

struct LoadDogInfoUseCaseImpl: LoadDogInfoUseCase {
    private let dataLoadable: (any DataLoadable)

    init(dataLoadable: any DataLoadable) {
        self.dataLoadable = dataLoadable
    }

    func execute() throws -> Dog {
        try dataLoadable.loadData(forKey: "dogInfo", type: Dog.self)
    }
}
