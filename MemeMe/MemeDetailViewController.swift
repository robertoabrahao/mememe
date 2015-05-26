//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Roberto Abrahao on 5/24/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    //Memed Image to be displayed
    var memedImage : UIImage!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //sets up the memed image to the image view controller
        imageView.image = memedImage
        
    }

    
}
