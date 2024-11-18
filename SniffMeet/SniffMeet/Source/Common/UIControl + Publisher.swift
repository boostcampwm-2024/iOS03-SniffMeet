//
//  UIControl + Publisher.swift
//  SniffMeet
//
//  Created by sole on 11/18/24.
//

import Combine
import UIKit

extension UIControl {
    func publisher(event: UIControl.Event) -> UIControlEventPublisher {
        UIControlEventPublisher(control: self, event: event)
    }
}

struct UIControlEventPublisher: Publisher {
    typealias Output = Void
    typealias Failure = Never
    private let control: UIControl
    private let event: UIControl.Event

    init(control: UIControl, event: UIControl.Event) {
        self.control = control
        self.event = event
    }

    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription: UIControlEventSubscription = UIControlEventSubscription(
            subscriber: subscriber,
            control: control,
            event: event
        )
        subscriber.receive(subscription: subscription)
    }
}

final class UIControlEventSubscription<S>: Subscription where S: Subscriber,
                                                              S.Input == Void,
                                                              S.Failure == Never {
    private weak var control: UIControl?
    private var subscriber: S?

    init(subscriber: S? = nil, control: UIControl, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(processControlAction), for: event)
    }

    func request(_ demand: Subscribers.Demand) {}
    func cancel() {
        subscriber = nil
        control?.removeTarget(self, action: #selector(processControlAction), for: .allEvents)
    }
    @objc func processControlAction() {
        _ = subscriber?.receive(())
    }
}
