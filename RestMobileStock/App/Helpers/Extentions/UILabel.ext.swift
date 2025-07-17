//
//  UILabel.ext.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 17.07.2025.
//

import UIKit

extension UILabel {
    func addTrailingIcon(image: UIImage, tintColor: UIColor? = nil,
                         offset: CGFloat = 4, iconSize: CGSize = CGSize(width: 18, height: 18)) {
        let attachment = NSTextAttachment()
        
        if let tintColor = tintColor {
            attachment.image = image.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        } else {
            attachment.image = image
        }
        
        attachment.bounds = CGRect(x: 0, y: -2, width: iconSize.width, height: iconSize.height )
        
        let fullString = NSMutableAttributedString()
        
        if let text = self.text {
            fullString.append(NSAttributedString(string: text + " "))
        }
        
        fullString.append(NSAttributedString(attachment: attachment))
        self.attributedText = fullString
    }
}
