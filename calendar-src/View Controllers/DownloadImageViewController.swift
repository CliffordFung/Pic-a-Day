//
//  DownloadImageViewController.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-12-01.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

class DownloadImageViewController: UIViewController {
    var image :UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.isNavigationBarHidden = true
        imageView.image = image
    }
    @IBAction func downloadButtonPressed () {
        // add image to the gallery
        let alert = UIAlertController(title: "Download complete", message: "Image successfully added to gallery", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (UIAlertAction) in
            
            self.close2()
            
            self.navigationController?.popViewController(animated: false)
        }))
        self.present(alert, animated: false)
    }
    
    @IBAction func cancelButtonPressed() {
        close2()
        
        self.navigationController?.popViewController(animated: false)
    }
    
    private func close2() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
}
