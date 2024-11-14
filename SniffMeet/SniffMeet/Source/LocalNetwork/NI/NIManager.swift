//
//  NIManager.swift
//  SniffMeet
//
//  Created by 배현진 on 11/14/24.
//

import MultipeerConnectivity
import NearbyInteraction

class NBInteractionManager: NSObject {
    private var niSession: NISession?
    private var mpcManager: MPCManager

    init(mpcManager: MPCManager) {
        self.mpcManager = mpcManager
        super.init()

        setupNISession()
        setupBindings()
    }

    private func setupNISession() {
        niSession = NISession()
        niSession?.delegate = self
    }

    private func setupBindings() {
        // MPC 연결 완료 시 discoveryToken을 주고받기

        // MPC로 discoveryToken 수신 시 NI 세션 업데이트
    }

    // discoveryToken 전송
    private func sendDiscoveryToken() {

    }

    // discoveryToken 수신 처리
    private func handleReceivedDiscoveryToken(_ data: Data) {

    }
}

// MARK: - NISessionDelegate
extension NBInteractionManager: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        for nearbyObject in nearbyObjects {

            print("Distance to peer: \(nearbyObject.distance ?? 0)")
        }
    }

    func sessionWasSuspended(_ session: NISession) {
        print("NearbyInteraction session suspended.")
    }

    func sessionSuspensionEnded(_ session: NISession) {
        print("NearbyInteraction session suspension ended.")
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
        print("NearbyInteraction session invalidated: \(error)")
    }
}
