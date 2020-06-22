//
//  Gallery.swift
//  sample-calendar-views
//
//  Created by Takudzwa Mhonde on 2018-11-23.
//  Copyright © 2018 Takudzwa Mhonde. All rights reserved.
//

import UIKit

struct Picture {
    let image:UIImage
    let title:String
    let date:Date
    init(_image:UIImage, _title:String, _date:Date) {
        image=_image; title=_title; date=_date
    }
}

class Gallery {
    private var pictures = [Picture]()
    
    func save(picture:Picture){
        pictures.append(picture)
        // save the context here
    }
    
    func count() ->Int {
        return pictures.count
    }
    
    func deleteImageWith(_title: String){
        if(pictures.count>0){
            var index = 0
            for picture in pictures {
                if(picture.title == _title){
                    pictures.remove(at: index)
                }
                index=index+1
            }
        }
        return
    }
    
    func getImageWith(_title: String)->UIImage?{
        if(pictures.count>0){
            var index = 0
            for picture in pictures {
                if(picture.title == _title){
                    return pictures[index].image
                }
                index=index+1
            }
        }
        return nil
    }
}
