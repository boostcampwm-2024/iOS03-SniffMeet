//
//  MPConnectionManager.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/13/24.
//

import Combine
import MultipeerConnectivity
import NearbyInteraction
import os

extension String {
    static var serviceName = "SniffMeet"
}

final class MPCManager: NSObject {
    let advertiser: MPCAdvertiser
    let browser: MPCBrowser
    let session: MCSession
    let mypeerID: MCPeerID
    private var cancellables = Set<AnyCancellable>()

    @Published var paired: Bool = false

    private let log = Logger()

    var receivedTokenPublisher = PassthroughSubject<Data, Never>()
    var receivedDataPublisher = PassthroughSubject<DogProfileInfo, Never>()
    var isAvailableToBeConnected: Bool = false {
        didSet {
            if isAvailableToBeConnected {
                advertiser.startAdvertising()
                browser.startBrowsing()
            } else {
                log.error("isAvailableToBeConnected is changed")
                advertiser.stopAdvertising()
                browser.stopBrowsing()
            }

            advertiser.receivedInvite
                .sink { [weak self] bool in
                    if bool {
                        self?.browser.stopBrowsing()
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    init(advertiser: MPCAdvertiser, browser: MPCBrowser, session: MCSession, mypeerID: MCPeerID) {
        self.advertiser = advertiser
        self.browser = browser
        self.session = session
        self.mypeerID = mypeerID
       
        super.init()

        session.delegate = self
    }
    
    convenience init(yourName: String) {
        let peerID = MCPeerID(displayName: yourName)
        let serviceType = String.serviceName
        let session = MCSession(peer: peerID)

        self.init(advertiser: MPCAdvertiser(session: session,
                                            myPeerID: peerID,
                                            serviceType: serviceType),
                  browser:  MPCBrowser(session: session,
                                       myPeerID: peerID,
                                       serviceType: serviceType),
                  session: session,
                  mypeerID: peerID)
    }
    
    deinit {
        advertiser.stopAdvertising()
        browser.stopBrowsing()
    }
    
    func sendToken(discoveryToken: Data) {
        guard !session.connectedPeers.isEmpty else { return }

        do {
            let dataToSend = ReceiveData(token: discoveryToken, profile: nil)
            let encodedData = try JSONEncoder().encode(dataToSend)
            log.info("encodedToken is  \(encodedData)")
            try session.send(encodedData, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            log.error("error sending \(error.localizedDescription)")
        }
    }

    func sendData(profile: DogProfileInfo) {
        guard !session.connectedPeers.isEmpty else {
            log.log("no one is connected")
            return
        }

        do {
            let dataToSend = ReceiveData(token: nil, profile: profile)
            let encodedData = try JSONEncoder().encode(dataToSend)
            log.info("encodedData is  \(encodedData)")
            try session.send(encodedData, toPeers: session.connectedPeers, with: .reliable)
            log.log("DogProfileInfo 전송 성공")
        } catch {
            log.error("DogProfileInfo 전송 실패: \(error.localizedDescription)")
        }
    }
}

// MARK: - MCSessionDelegate
extension MPCManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
        switch state {
        case .notConnected:
            Task { @MainActor in
                log.log("notConnected to MPCSession")
                log.info("notConnected: \(session.connectedPeers)")
                self.paired = false
                self.isAvailableToBeConnected = true
            }
        case .connected:
            Task { @MainActor in
                log.log("successfully connected to MPCSession")
                self.paired = true
                self.isAvailableToBeConnected = false
                log.info("ConnectedPeers: \(session.connectedPeers)")
            }
        default:
            Task { @MainActor in
                self.paired = false
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        log.info("didReceive bytes \(data.count) bytes")

        do {
            let receivedData = try JSONDecoder().decode(ReceiveData.self, from: data)

            if let tokenData = receivedData.token {
                Task { @MainActor in
                    receivedTokenPublisher.send(tokenData)
                }
            } else if let profile = receivedData.profile {
                Task { @MainActor in
                    receivedDataPublisher.send(profile)
                }
            }
        } catch {
            log.error("Failed to decode received data: \(error)")
        }
    }

    func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {
        log.error("Receiving streams is not supported")
    }

    func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {
        log.error("Receiving resources is not supported")
    }

    func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: (any Error)?
    ) {
        log.error("Receiving resources is not supported")
    }
}
