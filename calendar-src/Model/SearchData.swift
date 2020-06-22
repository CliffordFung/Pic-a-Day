//
//  SearchData.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-22.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

struct SearchItem {
    //var image:UIImage
    var link:String
    var title:String
    init(_link:String, _title:String) {
        link=_link
        title=_title
    }
}

struct imageItem {
    var image:UIImage
    var title:String
    init(_image:UIImage, _title:String) {
        image=_image; title=_title
    }
}

class SearchEngine {
    
    var searchResults = [SearchItem]()
    
    var start = 1
    
    var images = [imageItem]()
    
    var searchString = ""
    
    func initiateSearch(_searchString: String){
        searchString = _searchString
    }
    
    func fetchImagesUsing() {
        let group = DispatchGroup()
        group.enter()
        
        // avoid deadlocks by not using .main queue here
        DispatchQueue.global(qos: .default).async {
            let _searchString = self.searchString.replacingOccurrences(of: " ", with: "-")
            // API parameters
            let APIKey = "AIzaSyCcTqV0AsXdh59NTnjuwyKwF1ldSZolnTY"
            let imageSize = "large"
            let searchType = "image"
            let searchEngineID = "005406719548644067011:op_zwse_kxk"
            // create url obj with parameteers above
            let url = URL(string: "https://www.googleapis.com/customsearch/v1?key=\(APIKey)&cx=\(searchEngineID)&q=\(_searchString)&searchType=\(searchType)&imgSize=\(imageSize)&start=\(self.start)")
            print(url!)
            // create a task passing in url
            // if you alter ui do it on main thread
            URLSession.shared.dataTask(with: url!) {
                (data, response, error) in
                // check if we received a response
                // cast response to HTTPResponse
                // check status code :- 200: means all is good!
                if error != nil{
                    print("error")
                }
                
                guard let httpResponse = response as? HTTPURLResponse,      httpResponse.statusCode == 200 else{
                    print("Could not  receive response")
                    return
                }
                
                // check if we received valid data
                guard let data = data else {
                    print(error.debugDescription)
                    return
                }
                // take and convert data to string and print result
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    for (key, value) in parsedData{
                        if key == "items"{
                            if let items:[[String:Any]] = value as? [[String:Any]]{
                                for item in items{
                                    let link = item["link"]! as! String
                                    let title = item["title"]! as! String
                                    // making an imagedata item
                                    let searchItem = SearchItem(_link: link, _title: title)
                                    self.searchResults.append(searchItem)
                                    
                                }
                            }
                        }
                    }
                    // download images here
                    group.leave()
                }catch{
                    print("Could not convert data")
                    
                }}.resume()
        }
        // wait
        group.wait()
        //
    }
    
    func downloadImagseFromUrls()
    {
        let group = DispatchGroup()
        group.enter()
        
        // avoid deadlocks by not using .main queue here
        DispatchQueue.global(qos: .default).async {
            for result in self.searchResults {
                if let image = self.getImage(link: result.link) {
                    self.images.append(imageItem(_image: image, _title: result.title))
                }
            }
            group.leave()
        }
        // wait ...
        group.wait()
    }
    
    func load() -> [UIImage]{
        let group = DispatchGroup()
        var _images = [UIImage]()
        group.enter()
        DispatchQueue.global(qos: .default).async {
            self.fetchImagesUsing()
            self.downloadImagseFromUrls()
            _images = self.getImages()
            group.leave()
        }
        group.wait()
        return _images
    }
    
    func nextPage() {
        searchResults.removeAll()
        images.removeAll()
        start += 11
    }
    
    func reset() {
        start = 1
        searchResults.removeAll()
        images.removeAll()
    }
    
    private func getImages() -> [UIImage] {
        var _images = [UIImage]()
        for image in images {
            _images.append(image.image)
        }
        return _images
    }
    
    private func getImage(link:String) -> UIImage?{
        var image:UIImage?
        print("image url: \(link)")
        if let url = NSURL(string: link){
            if let data = NSData(contentsOf: url as URL) {
                image = UIImage(data: data as Data)
            }
        }
        if image != nil {
            return image
        }
        print("Nothing found")
        return nil
    }
}
