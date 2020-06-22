//
//  ClipboardViewController.swift
//  PicADay
//  Created by Takudzwa Mhonde on 2018-11-22.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.


/*  Bugs:
    -  Check and uncheck not working at the moment
 */

import UIKit

class ClipboardViewController: UIViewController {
    
    // MARK:- Variables
    
    var imagePickerController:UIImagePickerController!
    var toSetEventImage = false
    var imageProtocol:ImageProtocol?
    
    // MARK:- Outlets
    
    @IBOutlet weak var clipboardCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    var collectionData = [#imageLiteral(resourceName: "birthday-party"),#imageLiteral(resourceName: "birthday-party2"),#imageLiteral(resourceName: "classroom"),#imageLiteral(resourceName: "classroom2")] // [UIImage]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    
    @IBAction func addItem(_ sender: Any) {
        let alert = UIAlertController(title: "Choose source:", message: "Add the images to your clipboard from the any of the sources:", preferredStyle: .actionSheet)
         alert.addAction(UIAlertAction(title: "Image Search", style: .default, handler: { (UIAlertAction) in
            // MARK:- Image search VC - Creates and instance of the image search and segues to the VC --> Should return to this view controller after the user has downloaded their stuff
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ImageSearchViewController") as! SearchViewController
            vc.fromAnotherVCWithoutSegue = true
            self.open()
            self.setEditing(false, animated: false)
            self.navigationController?.pushViewController(vc, animated: false)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            print("Call camera")
            // need code
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        self.present(alert, animated: true)
    }
    
    @IBAction func deleteSelectedItems() {
        if let selected = clipboardCollectionView.indexPathsForSelectedItems{
            let items = selected.map { $0.item }.sorted().reversed()
            for item in items {
                collectionData.remove(at: item)
            }
            clipboardCollectionView.deleteItems(at: selected)
        }
        // save the state to core data here
        //navigationController?.isToolbarHidden = true
    }
    
    @IBAction func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        backButton.isEnabled = !editing

        clipboardCollectionView.allowsMultipleSelection = editing
        // ensures selected cells become deselected when done is tapped
        clipboardCollectionView.indexPathsForSelectedItems?.forEach{
            clipboardCollectionView.deselectItem(at: $0, animated: false)
        }
        let indexPaths = clipboardCollectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = clipboardCollectionView.cellForItem(at: indexPath) as! ClipboardCollectionViewCell
            cell.isEditing = editing
        }
        // change the edit button to select -> Done
        if(self.isEditing)
        {
            self.editButtonItem.title = "Cancel"
        }else
        {
            self.editButtonItem.title = "Edit"
        }
        if !editing {
            navigationController?.isToolbarHidden = true
        }
        else {
            navigationController?.isToolbarHidden = false
        }
        
    }
    
    func setupView() {
        let width = (view.frame.size.width) / 5
        let layout = clipboardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.title = "Edit"
        navigationController?.isToolbarHidden = true
    }
    
    private func open() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
}

extension ClipboardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClipboardCollectionViewCell", for: indexPath) as! ClipboardCollectionViewCell
        cell.mainImage.image = collectionData[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditing {
            navigationController?.isToolbarHidden = false
        }
        else if toSetEventImage {
            imageProtocol?.setImage(_image: collectionData[indexPath.row])
            // animation
            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromBottom
            navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if let selected = collectionView.indexPathsForSelectedItems, selected.count == 0{
                navigationController?.isToolbarHidden = true
            }
        }

    }
}
