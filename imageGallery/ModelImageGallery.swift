//
//  ModelImageGallery.swift
//  imageGallery
//
//  Created by Alec Charbonneau on 2/1/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit



struct ModelImageGallery {
    
    var images: [UIImage]?
    
    var galleries: Dictionary<String,[UIImage]> = [
        "First Gallery": [UIImage(named: "garfield" )!, UIImage(named: "bart")!, UIImage(named:"spongebob")!, UIImage(named:"scooby")!]
    ]
    
    
    var galleryNames: [[String]] = [["First Gallery","Second Gallery", "Hi"], []]
    
    
    
    mutating func newGallery(galleryName name: String){
        self.galleries[name] = []
    }
    
    
    
}
