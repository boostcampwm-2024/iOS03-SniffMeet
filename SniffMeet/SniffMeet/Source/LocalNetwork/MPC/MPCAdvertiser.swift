//
//  MPCAdvertiser.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/13/24.
//
import Combine
import MultipeerConnectivity
import os

fileprivate let log = Logger()

final class MPCAdvertiser: NSObject {
    let advertiser: MCNearbyServiceAdvertiser
    let session: MCSession
    let myPeerID: MCPeerID

    static var sharedAdvertiser: MCNearbyServiceAdvertiser?

//    @Published var receivedInvite: Bool = false
    var receivedInvite = PassthroughSubject<Bool, Never>()

    @Published var receivedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?

    init(advertiser: MCNearbyServiceAdvertiser,
         session: MCSession,
         myPeerID: MCPeerID,
         receivedInviteFrom: MCPeerID? = nil,
         invitationHandler: ((Bool, MCSession?) -> Void)? = nil)
    {
        self.advertiser = advertiser
        self.session = session
        self.myPeerID = myPeerID
        self.receivedInviteFrom = receivedInviteFrom
        self.invitationHandler = invitationHandler
        
        super.init()
        advertiser.delegate = self
    }
    
    convenience init(session: MCSession, myPeerID: MCPeerID, serviceType: String) {
        /// 이렇게 메타데이터와 함께 advertiser를 만들면 advertising할 때 정보 전달 가능
        ///let advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: "my-service")
        if let existingAdvertiser = MPCAdvertiser.sharedAdvertiser {
            self.init(advertiser: existingAdvertiser, session: session, myPeerID: myPeerID)
        } else {
            let newAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID,
                                                          discoveryInfo: nil,
                                                          serviceType: serviceType)
            MPCAdvertiser.sharedAdvertiser = newAdvertiser
            self.init(advertiser: newAdvertiser, session: session, myPeerID: myPeerID)
            log.log("Created new MCNearbyServiceAdvertiser instance")
        }
    }

    deinit {
        if MPCAdvertiser.sharedAdvertiser === advertiser {
            MPCAdvertiser.sharedAdvertiser = nil
            log.log("MPCAdvertiser deinit")
        }
    }

    func startAdvertising() {
        advertiser.startAdvertisingPeer()
        log.log("start advertising")
    }
    
    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
        receivedInvite.send(true)
        log.log("stop advertising")
    }
}

extension MPCAdvertiser: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        log.info("Advertiser failed to start: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        log.info("Received invitation from \(peerID)")
        invitationHandler(true, session)
        receivedInvite.send(true)
    }
}
