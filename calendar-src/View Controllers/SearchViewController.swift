//
//  SearchViewController.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-23.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Variables
    
    var searchEngine = SearchEngine()
    var imagesLoaded=[UIImage]()
    var googleSearchText = ""
    var fromAnotherVCWithoutSegue = false // used for seguing -- look at CboardVC -> add()
    var refreshCtrl: UIRefreshControl!

    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    // MARK: - Actions
    
    @IBAction func backBtnPressed(_ sender: Any) {
        if !fromAnotherVCWithoutSegue{
            dismiss(animated: true, completion: nil)
        }
        else if fromAnotherVCWithoutSegue{
            fromAnotherVCWithoutSegue = false
            close()
        }
        
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
    }
    
    
    // MARK: - Functions
    private func close() {
        // animation
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
    private func load3times() {
        // only loads 20 images at a time
        imagesLoaded.append(contentsOf: searchEngine.load())
        searchEngine.nextPage()
        imagesLoaded.append(contentsOf: searchEngine.load())
        // needs caching
    }
    
    private func setupView() {
        let width = (view.frame.width) / 5
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    private func open2() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    private func setupSearchBar(){
        // delegating the search bar
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchEngine.reset()
        if let searchText = searchBar.text {
            googleSearchText = searchText
        }
        // for debugging
        print("")
        print("Search: \(googleSearchText)")
        print("")
        searchEngine.initiateSearch(_searchString: googleSearchText)
        load3times()
        collectionView.reloadData()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesLoaded.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCollectionViewCell
        cell.imageView.image = imagesLoaded[indexPath.row]
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DownloadViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DownloadImageViewController") as! DownloadImageViewController
        vc.image = imagesLoaded[indexPath.row]
        open2()
        self.navigationController?.pushViewController(vc, animated: false)
        //self.present(vc, animated: false)
    }
}
