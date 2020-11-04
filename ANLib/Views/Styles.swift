//
//  Styles.swift
//  ANLib
//
//  Created by Elliot Schrock on 10/30/20.
//

import UIKit
import LithoOperators
import Prelude

func applyShadow(_ view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.2
    view.layer.shadowOffset = CGSize(width: 1, height: 1)
}

func makeCircular(_ view: UIView) {
    view.layer.cornerRadius = view.bounds.size.height / 2
}

let floatingStyle = makeCircular <> applyShadow

let floatingButtonStyle = makeCircular <> applyShadow <> { (button: UIButton) in
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = UIColor.accent()
}

let primaryButtonStyle = makeCircular <> applyShadow <> { (button: UIButton) in
    button.setTitleColor(UIColor.reverse(), for: .normal)
    button.backgroundColor = UIColor.primary()
}

let reversePrimaryButtonStyle = makeCircular <> applyShadow <> { (button: UIButton) in
    button.setTitleColor(UIColor.primary(), for: .normal)
    button.backgroundColor = UIColor.reverse()
}

let reverseButtonStyle = makeCircular <> applyShadow <> { (button: UIButton) in
    button.setTitleColor(UIColor.accent(), for: .normal)
    button.backgroundColor = UIColor.reverse()
}

let ctaButtonStyle = makeCircular <> applyShadow <> { (button: UIButton) in
    button.setTitleColor(UIColor.accent(), for: .normal)
    button.backgroundColor = UIColor.reverse()
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
