//
//  ViewController.swift
//  AABlurModalView
//
//  Created by Anas Ait Ali on 30/08/2016.
//  Copyright © 2016 Anas AIT ALI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!

    @IBAction func show(_ sender: AnyObject) {
        // Instanciate a view from a XIB
        let nib = UINib(nibName: "ExampleView", bundle: Bundle(for: type(of: self)))
        let xibObjs = nib.instantiate(withOwner: self, options: nil)
        let temporaryView = xibObjs.last as! UIView

        switch segmentControl.selectedSegmentIndex {
        case 1:
            let blurModalView = AABlurModalView(contentView: temporaryView, contentSize: CGSize(width: 500, height: 500))
            blurModalView.show()
        case 2:
            let blurModalView = AABlurModalView(contentView: temporaryView)
            blurModalView.blurEffectStyle = .light
            blurModalView.show()
        default:
            AABlurModalView(contentView: temporaryView).show()
        }
    }

}
