//
//  OnBoardingPageViewController.swift
//  SniffMeet
//
//  Created by 배현진 on 12/4/24.
//

import UIKit

class OnBoardingPageViewController: BaseViewController {
    let page: OnBoardingPage

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Context.titleLabel
        label.textColor = SNMColor.mainNavy
        label.numberOfLines = 4
        label.font = SNMFont.largeTitle
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.descriptionLabel
        label.textColor = SNMColor.mainNavy
        label.numberOfLines = 5
        label.font = SNMFont.callout
        return label
    }()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ImagePlaceholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.alignment = .center
        return stackView
    }()

    init(page: OnBoardingPage) {
        self.page = page
        super.init()
    }
    
    override func configureAttributes() {
        let highlightText = "산책 메이트"
        titleLabel.attributedText = getAttributedText(fullText: page.title, highlight: highlightText, color: SNMColor.mainBrown)
        descriptionLabel.text = page.description
        if page.isGif {
            if let gifImageView = createGIFImageView(named: page.imageName) {
                imageView.removeFromSuperview()
                imageView = gifImageView
                imageView.contentMode = .scaleAspectFit
            }
        } else {
            imageView.image = UIImage(named: page.imageName)
        }
    }
    override func configureHierachy() {
        [titleLabel,
         imageView,
         descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    override func bind() {}
}

private extension OnBoardingPageViewController {
    enum Context {
        static let titleLabel: String = "온보딩 타이틀"
        static let descriptionLabel: String = "온보딩 설명"
    }
}

private extension OnBoardingPageViewController {
    func createGIFImageView(named gifName: String) -> UIImageView? {
        guard let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif"),
              let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)),
              let source = CGImageSourceCreateWithData(gifData as CFData, nil) else {
            return nil
        }

        var images = [UIImage]()
        var duration: Double = 0

        let frameCount = CGImageSourceGetCount(source)
        for frame in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, frame, nil) else { continue }
            images.append(UIImage(cgImage: cgImage))

            let frameProperties = CGImageSourceCopyPropertiesAtIndex(source, frame, nil) as? [String: Any]
            let gifProperties = frameProperties?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
            let frameDuration = gifProperties?[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0
            duration += frameDuration
        }

        let imageView = UIImageView()
        imageView.animationImages = images
        imageView.animationDuration = duration
        imageView.startAnimating()

        return imageView
    }

    private func getAttributedText(fullText: String, highlight: String, color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)

        if let range = fullText.range(of: highlight) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
        }

        return attributedString
    }
}

