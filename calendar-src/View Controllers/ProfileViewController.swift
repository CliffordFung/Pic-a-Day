//
//  ProfileViewController.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-12-01.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var ProfileImage: UIButton!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func profileImageBtnPressed(_ sender: Any) {
        // segue to camera
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Logout of Pic-A-Day", message: "Are you sure that you want to log out? ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (UIAlertAction) in
            // fill in code here -- siri
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            self.close()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.popViewController(animated: false)
        }))
        
        self.present(alert, animated: false)
    
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        close()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
    private func close() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
    

}
