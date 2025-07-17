//
//  UITextField.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 17.07.2025.
//

import UIKit

extension UITextField {
    enum IconPosition {
        case left
        case right
    }

    func addTappableIcon(
        _ image: UIImage,
        position: IconPosition = .left,
        tintColor: UIColor? = nil,
        leftPadding: CGFloat = 16.0,
        rightPadding: CGFloat = 8.0,
        iconSize: CGSize = CGSize(width: 24, height: 24),
        tapHandler: @escaping () -> Void
    ) {
        let iconImage = tintColor != nil ? image.withTintColor(tintColor!, renderingMode: .alwaysOriginal) : image

        let containerWidth = iconSize.width + leftPadding + rightPadding
        let containerHeight = max(iconSize.height, 40)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight))
        containerView.isUserInteractionEnabled = true

        let button = UIButton(type: .custom)
        button.setImage(iconImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.frame = CGRect(x: leftPadding, y: (containerHeight - iconSize.height) / 2, width: iconSize.width, height: iconSize.height)
        button.isUserInteractionEnabled = true

        containerView.addSubview(button)

        // Сохраняем tap
        objc_setAssociatedObject(button, &AssociatedKeys.tapHandlerKey, tapHandler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        button.addTarget(self, action: #selector(handleIconTap(_:)), for: .touchUpInside)

        // Установка
        switch position {
        case .left:
            self.leftView = containerView
            self.leftViewMode = .always
        case .right:
            self.rightView = containerView
            self.rightViewMode = .always
        }
    }


    @objc private func handleIconTap(_ sender: UIButton) {
        if let handler = objc_getAssociatedObject(sender, &AssociatedKeys.tapHandlerKey) as? () -> Void {
            handler()
        }
    }

    private struct AssociatedKeys {
        static var tapHandlerKey = "UITextFieldTapHandlerKey"
    }
}
