//
//  Extension + UIImage.swift
//  SniffMeet
//
//  Created by sole on 11/29/24.
//

import UIKit

extension UIImage {
    func clipToSquareWithBackgroundColor(with convertedSize: CGFloat) -> UIImage? {
        let aspectRatio = size.width / size.height

        var cropRect: CGRect
        if aspectRatio > 1 {
            let newHeight = convertedSize
            let newWidth = convertedSize * aspectRatio
            cropRect = .init(
                origin: .init(
                    x: (convertedSize - newWidth) / 2,
                    y: (convertedSize - newHeight) / 2
                ),
                size: CGSize(width: newWidth, height: newHeight)
            )
        } else {
            let newWidth = convertedSize
            let newHeight = convertedSize / aspectRatio
            cropRect = .init(
                origin: .init(
                x: (convertedSize - newWidth) / 2,
                y: (convertedSize - newHeight) / 2
                ),
                size: CGSize(
                    width: newWidth,
                    height: newHeight
                )
            )
        }
        let renderer = UIGraphicsImageRenderer(
            size: CGSize(width: convertedSize, height: convertedSize)
        )
        let resultImage = renderer.image { context in
            SNMColor.subGray1.setFill()
            UIRectFill(
                .init(
                    origin: .zero,
                    size: .init(width: convertedSize, height: convertedSize)
                )
            )
            context.cgContext.translateBy(x: convertedSize / 2, y: convertedSize / 2)
            context.cgContext.scaleBy(x: 1.0, y: -1.0)
            context.cgContext.translateBy(x: -convertedSize / 2, y: -convertedSize / 2)
            guard let cgImage else { return }
            context.cgContext.draw(cgImage, in: cropRect)
        }
        return resultImage
    }
}
