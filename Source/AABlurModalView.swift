//
//  AABlurModalView.swift
//  AABlurModalView
//
//  Created by Anas Ait Ali on 30/08/2016.
//  Copyright © 2016 Anas AIT ALI. All rights reserved.
//

import UIKit

enum AABlurModalViewError: Error {
    case nibViewNotFound
}

open class AABlurModalView: UIView {

    // TODO : Allow a contentSize change after init
    open var contentSize : CGSize?
    open var blurEffectStyle: UIBlurEffectStyle = .dark
    open var identifier: String?
    open var contentView : UIView!

    fileprivate var backgroundImage : UIImageView!

    public init(nibName: String, bundle: Bundle?) throws {
        super.init(frame: UIScreen.main.bounds)

        let nib = UINib(nibName: nibName, bundle: bundle)
        let nibObjs = nib.instantiate(withOwner: nil, options: nil)
        guard let nibView = nibObjs.last as? UIView else { throw AABlurModalViewError.nibViewNotFound }

        commonInit(nibView, contentSize: nil)
    }

    public init(contentView: UIView, contentSize: CGSize? = nil) {
        super.init(frame: UIScreen.main.bounds)

        commonInit(contentView, contentSize: contentSize)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit(UIView(), contentSize: nil)
    }

    open func show(_ view: UIView?? = UIApplication.shared.delegate?.window) {
        self.frame = UIScreen.main.bounds
        setupContentView()
        // TODO : Add alternative solution if the snapshot fails
        backgroundImage.image = snapshot()
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = backgroundImage.bounds
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        blurEffectView.contentView.addSubview(vibrancyEffectView)
        backgroundImage.addSubview(blurEffectView)

        view??.addSubview(self)
    }

    open func hide() {
        self.backgroundImage.subviews.forEach { $0.removeFromSuperview() }
        self.removeFromSuperview()
    }

    open static func hideBlurModalView(_ identifier: String?) {
        if let identifier = identifier {
            UIApplication.shared.delegate?.window??.subviews
                .filter { $0.isKind(of: AABlurModalView.self) }
                .filter { ($0 as? AABlurModalView)?.identifier == identifier }
                .forEach { $0.hideBlurModalView() }
        }
    }

    fileprivate func commonInit(_ contentView: UIView, contentSize: CGSize? = nil) {
        self.isOpaque = true
        self.alpha = 1
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundImage = UIImageView(frame: self.bounds)
        self.backgroundImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(backgroundImage)

        self.contentView = contentView
        self.identifier = contentView.accessibilityIdentifier
        self.contentSize = contentSize
    }

    fileprivate func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        let viewDict : [String: Any] = ["cV":contentView, "view":self]
        let cSize = contentSize ?? contentView.frame.size
        let metrics = ["cVHeight": cSize.height, "cVWidth": cSize.width]
        [NSLayoutConstraint.constraints(withVisualFormat: "V:[cV(cVHeight)]", options: [], metrics: metrics, views: viewDict),
            NSLayoutConstraint.constraints(withVisualFormat: "H:[cV(cVWidth)]", options: [], metrics: metrics, views: viewDict),
            NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-(<=1)-[cV]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewDict),
            NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(<=1)-[cV]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewDict)
            ].forEach { NSLayoutConstraint.activate($0) }
    }

    fileprivate func snapshot() -> UIImage? {
        let appDelegate = UIApplication.shared.delegate
        guard let window = appDelegate?.window else { return nil }
        UIGraphicsBeginImageContextWithOptions(window!.bounds.size, false, window!.screen.scale)
        window!.drawHierarchy(in: window!.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }

}

public extension UIView {

    public func hideBlurModalView(_ identifier: String? = nil) {
        if identifier != nil {
            AABlurModalView.hideBlurModalView(identifier)
        } else {
            if let blurModal = self.superview as? AABlurModalView {
                blurModal.hide()
            } else if let blurModal = self as? AABlurModalView {
                blurModal.hide()
            }
        }

    }

}
