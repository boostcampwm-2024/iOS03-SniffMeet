//
//  MPCAdvertiser.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/13/24.
//
import MultipeerConnectivity
import os

fileprivate let log = Logger()

final class MPCAdvertiser: NSObject {
    let advertiser: MCNearbyServiceAdvertiser
    let session: MCSession
    let myPeerID: MCPeerID

    @Published var receivedInvite: Bool = false
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
        self.init(advertiser: MCNearbyServiceAdvertiser(peer: myPeerID,
                                                        discoveryInfo: nil,
                                                        serviceType: serviceType),
                  session: session,
                  myPeerID: myPeerID)
    }
    
    func startAdvertising() {
        advertiser.startAdvertisingPeer()
        log.log("start advertising")
    }
    
    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
        log.log("stop advertising")
    }
}

extension MPCAdvertiser: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        self.receivedInvite = true
        self.receivedInviteFrom = peerID
        self.invitationHandler = invitationHandler

        log.info("Received invitation from \(peerID)")
        invitationHandler(true, session)
    }
}
