//
//  toast.swift
//  SniffMeet
//
//  Created by Kelly Chui on 12/5/24.
//

import UIKit

extension BaseViewController {
    enum SNMAnimationType {
        case slideUp
        case slideDown
        case showAtCenter
    }
    
    func showSNMImageToast(
        image: UIImage?,
        duration: Double = 2,
        animationType: SNMAnimationType
    ) {
        guard let image = image else { return }

        let backgroundView: UIView = {
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            backgroundView.layer.cornerRadius = 20
            return backgroundView
        }()

        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .white
            return imageView
        }()

        backgroundView.addSubview(imageView)
        self.view.addSubview(backgroundView)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        switch animationType {
        case .showAtCenter:
            backgroundView.centerYAnchor.constraint(
                equalTo: self.view.centerYAnchor
            ).isActive = true
        case .slideDown:
            backgroundView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: 50
            ).isActive = true
        case .slideUp:
            backgroundView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: -50
            ).isActive = true
        }
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 80),
            backgroundView.heightAnchor.constraint(equalToConstant: 80),

            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor)
        ])

        switch animationType {
        case .slideUp:
            backgroundView.transform = CGAffineTransform(translationX: 0, y: 100)
        case .slideDown:
            backgroundView.transform = CGAffineTransform(translationX: 0, y: -100)
        case .showAtCenter:
            backgroundView.alpha = 0
        }
        
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
            switch animationType {
            case .slideUp, .slideDown:
                backgroundView.transform = .identity
            case .showAtCenter:
                backgroundView.alpha = 1
            }
        }) { _ in
            UIView.animate(
                withDuration: 0.5,
                delay: duration,
                options: .curveEaseInOut,
                animations: {
                backgroundView.alpha = 0
            }) { _ in
                backgroundView.removeFromSuperview()
            }
        }
    }
    
    func showSNMTextAndImageToast(
        image: UIImage?,
        text: String?,
        duration: Double = 2,
        animationType: SNMAnimationType
    ) {
        guard let image = image, let text = text else { return }

        let backgroundView: UIView = {
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.systemGray3.withAlphaComponent(0.6)
            backgroundView.layer.cornerRadius = 20
            return backgroundView
        }()

        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .white
            return imageView
        }()

        let messageLabel: UILabel = {
            let messageLabel = UILabel()
            messageLabel.text = text
            messageLabel.textColor = .white
            messageLabel.textAlignment = .left
            messageLabel.numberOfLines = 0
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            return messageLabel
        }()

        backgroundView.addSubview(imageView)
        backgroundView.addSubview(messageLabel)
        self.view.addSubview(backgroundView)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        switch animationType {
        case .showAtCenter:
            backgroundView.centerYAnchor.constraint(
                equalTo: self.view.centerYAnchor
            ).isActive = true
        case .slideDown:
            backgroundView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: 50
            ).isActive = true
        case .slideUp:
            backgroundView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: -50
            ).isActive = true
        }

        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 150),
            backgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            messageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            messageLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
        
        switch animationType {
        case .slideUp:
            backgroundView.transform = CGAffineTransform(translationX: 0, y: 100)
        case .slideDown:
            backgroundView.transform = CGAffineTransform(translationX: 0, y: -100)
        case .showAtCenter:
            backgroundView.alpha = 0
        }
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            switch animationType {
            case .slideUp, .slideDown:
                backgroundView.transform = .identity
            case .showAtCenter:
                backgroundView.alpha = 1
            }
        }) { _ in
            UIView.animate(
                withDuration: 0.5,
                delay: duration,
                options: .curveEaseInOut,
                animations: {
                backgroundView.alpha = 0
            }) { _ in
                backgroundView.removeFromSuperview()
            }
        }
    }
    
    func showSNMProgressToast() {
        let backgroundView: UIView = {
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.8)
            backgroundView.layer.cornerRadius = 20
            backgroundView.alpha = 0
            return backgroundView
        }()
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large

        backgroundView.addSubview(activityIndicatorView)
        self.view.addSubview(backgroundView)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 120),
            backgroundView.centerYAnchor.constraint(
                equalTo: self.view.centerYAnchor
            ),
            backgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            activityIndicatorView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                backgroundView.alpha = 1
        }) { _ in
            UIView.animate(
                withDuration: 0.5,
                delay: 10.0,
                options: .curveEaseInOut,
                animations: {
                backgroundView.alpha = 0
            }) { _ in
                backgroundView.removeFromSuperview()
            }
        }
        activityIndicatorView.startAnimating()
    }
}
