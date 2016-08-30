//
//  ExampleView.swift
//  AABlurModalView
//
//  Created by Anas Ait Ali on 30/08/2016.
//  Copyright © 2016 Anas AIT ALI. All rights reserved.
//

import UIKit

class ExampleView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 10
    }

    @IBAction func close(sender: AnyObject) {
        self.hideBlurModalView()
    }

}
