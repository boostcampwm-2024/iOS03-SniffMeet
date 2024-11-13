//
//  MPConnectionManager.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/13/24.
//
import MultipeerConnectivity
import os

extension String {
    static var serviceName = "SniffMeet"
}

final class MPCManager: NSObject {
    let advertiser: MPCAdvertiser
    let browser: MPCBrowser
    let session: MCSession
    let mypeerID: MCPeerID
    var connectedPeers: MCPeerID?
    
    @Published var paired: Bool = false
    @Published var receivedData: Data?
    private let log = Logger()

    var isAvailableToBeConnected: Bool = false {
        didSet {
            if isAvailableToBeConnected {
                advertiser.startAdvertising()
            } else {
                advertiser.stopAdvertising()
            }
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
    
    func send(mateData: Codable) {
        if !session.connectedPeers.isEmpty {
            do {
                if let data =  try? JSONEncoder().encode(mateData) {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                }
            } catch {
                print("error sending \(error.localizedDescription)")
            }
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
                self.paired = false
                self.isAvailableToBeConnected = true
            }
        case .connected:
            Task { @MainActor in
                self.paired = true
                self.isAvailableToBeConnected = false
            }
        default:
            Task { @MainActor in
                self.paired = false
                self.isAvailableToBeConnected = true
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        log.info("didReceive bytes \(data.count) bytes")
        Task { @MainActor in
            // interactor에 mate 요청 데이터를 보내고
            receivedData = data
            self.session.disconnect()
            self.isAvailableToBeConnected = true
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.error("Receiving streams is not supported")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        log.error("Receiving resources is not supported")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        log.error("Receiving resources is not supported")
    }
}

