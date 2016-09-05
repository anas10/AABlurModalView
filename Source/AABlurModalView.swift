//
//  AABlurModalView.swift
//  AABlurModalView
//
//  Created by Anas Ait Ali on 30/08/2016.
//  Copyright © 2016 Anas AIT ALI. All rights reserved.
//

import UIKit

enum AABlurModalViewError: ErrorType {
    case NibViewNotFound
}

public class AABlurModalView: UIView {

    public var contentSize : CGSize?
    public var blurEffectStyle: UIBlurEffectStyle = .Dark
    public var identifier: String?
    public var contentView : UIView!

    private var backgroundImage : UIImageView!

    public init(nibName: String, bundle: NSBundle?) throws {
        super.init(frame: UIScreen.mainScreen().bounds)

        let nib = UINib(nibName: nibName, bundle: bundle)
        let nibObjs = nib.instantiateWithOwner(nil, options: nil)
        guard let nibView = nibObjs.last as? UIView else { throw AABlurModalViewError.NibViewNotFound }

        commonInit(nibView, contentSize: nil)
    }

    public init(contentView: UIView, contentSize: CGSize? = nil) {
        super.init(frame: UIScreen.mainScreen().bounds)

        commonInit(contentView, contentSize: contentSize)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit(UIView(), contentSize: nil)
    }

    public func show() {
        setupContentView()
        // TODO : Add alternative solution if the snapshot fails
        backgroundImage.image = snapshot()
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = backgroundImage.bounds
        vibrancyEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        blurEffectView.contentView.addSubview(vibrancyEffectView)
        backgroundImage.addSubview(blurEffectView)

        UIApplication.sharedApplication().delegate?.window??.addSubview(self)
    }

    public func hide() {
        self.backgroundImage.subviews.forEach { $0.removeFromSuperview() }
        self.removeFromSuperview()
    }

    public static func hideBlurModalView(identifier: String?) {
        if let identifier = identifier {
            UIApplication.sharedApplication().delegate?.window??.subviews
                .filter { $0.isKindOfClass(AABlurModalView) }
                .filter { ($0 as? AABlurModalView)?.identifier == identifier }
                .forEach { $0.hideBlurModalView() }
        }
    }

    private func commonInit(contentView: UIView, contentSize: CGSize? = nil) {
        self.opaque = true
        self.alpha = 1
        self.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.backgroundImage = UIImageView(frame: self.bounds)
        self.backgroundImage.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(backgroundImage)

        self.contentView = contentView
        self.identifier = contentView.accessibilityIdentifier
        self.contentSize = contentSize
    }

    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        let viewDict = ["cV":contentView, "view":self]
        let cSize = contentSize ?? contentView.frame.size
        let metrics = ["cVHeight": cSize.height, "cVWidth": cSize.width]
        [NSLayoutConstraint.constraintsWithVisualFormat("V:[cV(cVHeight)]", options: [], metrics: metrics, views: viewDict),
            NSLayoutConstraint.constraintsWithVisualFormat("H:[cV(cVWidth)]", options: [], metrics: metrics, views: viewDict),
            NSLayoutConstraint.constraintsWithVisualFormat("H:[view]-(<=1)-[cV]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict),
            NSLayoutConstraint.constraintsWithVisualFormat("V:[view]-(<=1)-[cV]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewDict)
            ].forEach { NSLayoutConstraint.activateConstraints($0) }
    }

    private func snapshot() -> UIImage? {
        let appDelegate = UIApplication.sharedApplication().delegate
        guard let window = appDelegate?.window else { return nil }
        UIGraphicsBeginImageContextWithOptions(window!.bounds.size, false, window!.screen.scale)
        window!.drawViewHierarchyInRect(window!.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }

}

public extension UIView {

    public func hideBlurModalView(identifier: String? = nil) {
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
