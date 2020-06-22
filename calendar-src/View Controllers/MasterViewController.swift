//
//  ViewController.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-21.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//  Resource: https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/
// 

import UIKit
import AMPopTip
class MasterViewController: UIViewController {
    
    // MARK: - Variables
    
    var menuIsHidden:Bool!
    var imagePickerController:UIImagePickerController!
    
    private lazy var monthViewController: MonthViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "MonthViewController") as! MonthViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var weekViewController: WeekViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "WeekViewController") as! WeekViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var segmentedController:UISegmentedControl!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var mainViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var clipBoard: UIButton!
    @IBOutlet weak var emojis: UIButton!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var setting: UIButton!
    let poptip = PopTip()
    let popclipBoard = PopTip()
    let popCamera = PopTip()
    let popSearch = PopTip()
    let popEmojis = PopTip()
    let popSetting = PopTip()
    let popTips = PopTip()
    var tapNumber = 1
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup default view
        self.navigationController?.isNavigationBarHidden = false
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        defaultView()
    }
    
    // MARK:- Functions
    func defaultView() {
//        setConstraintsToHave(_length: 0)
        menuIsHidden=true
    }
    func setupSegmentedController(){
        // setup the view
        // Configure Segmented Control
        segmentedController.removeAllSegments()
        segmentedController.insertSegment(withTitle: "Month", at: 0, animated: false)
        segmentedController.insertSegment(withTitle: "Week", at: 1, animated: false)
        segmentedController.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedController.selectedSegmentIndex = 0
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    // MARK:- Action methods
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        if tapNumber == 1
        {
            
            
            popclipBoard.show(text: "Open clip-arts board", direction: .right, maxWidth: 200, in: view, from: clipBoard.frame)
            popEmojis.show(text: "Browse emojis", direction: .right, maxWidth: 200, in: view, from: emojis.frame)
            popSearch.show(text: "Search clip-arts from google", direction: .right, maxWidth: 200, in: view, from: search.frame)
            popCamera.show(text: "Take clip-arts with camera", direction: .right, maxWidth: 200, in: view, from: camera.frame )
            popSetting.show(text: "Change settings", direction: .right, maxWidth: 200, in: view, from: setting.frame)
            tapNumber = tapNumber + 1
        }
        var lengthOfSliding:CGFloat!
        if menuIsHidden {
            lengthOfSliding = 90.0
            menuIsHidden = false
            
        }else{
            lengthOfSliding = 0
            menuIsHidden = true
        }
//        setConstraintsToHave(_length: lengthOfSliding)
        // animate
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            // for debugging
            print("The animation is complete!")
        }
    }
    
//    func setConstraintsToHave(_length:CGFloat) {
//
//        mainViewLeadingConstraint.constant = _length
//        mainViewTrailingConstraint.constant = -1*_length
//    }
    
    @IBAction func cameraBtnPressed () {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
           
            let alert = UIAlertController(title: "Camera not available.", message: "The camera is not available. Please check the device settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            defaultView()
            return
        }
        // create an instance of the UIImagePickerController
        imagePickerController = UIImagePickerController()
        //assign the delegate
        imagePickerController.delegate = self
        //specify the camera to be used
        imagePickerController.sourceType = .camera
    }
    
    @IBAction func profileBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        menuBtnPressed(self)
        open()
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
//       mainView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func updateView() {
        if segmentedController.selectedSegmentIndex == 0 {
            remove(asChildViewController: weekViewController)
            add(asChildViewController: monthViewController)
        } else {
            remove(asChildViewController: monthViewController)
            add(asChildViewController: weekViewController)
        }
    }
    
    private func setupView() {
        setupSegmentedController()
        updateView()
    }
    
    private func open() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
    
    
}

extension MasterViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // when a photo is taken you can access photo -> This is for saving photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
         if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
         // create an image item
         let photo = Photo(context: PersistanceService.context)
         photo.image = pickedImage.pngData()! as NSData// only error
         // saving to data
         PersistanceService.saveContext()
         self.photoLibrary.append(photo)
         }
         //MARK:- For debugging purposes, counting number of pictures in the store
         print(photoLibrary.count)*/
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tooltipPresenter()
        
    }
    
    
    func tooltipPresenter()
    {
        if tapNumber == 1
        {
            popTips.show(text: "Click on days to create activities\n \n Tap on tip/blank to dismiss", direction: .none, maxWidth: 400, in: view, from: view.frame)
            popTips.actionAnimation = .pulse(1.0)
        }
    }
}
