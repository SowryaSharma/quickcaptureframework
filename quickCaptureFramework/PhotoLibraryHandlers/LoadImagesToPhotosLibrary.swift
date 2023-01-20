//
//  LoadImagesToPhotosLibrary.swift
//  quickCaptureFramework
//
//  Created by cumulations on 27/12/22.
//

import Foundation
import UIKit

public class saveImagesToLibrary{
    public init(){}
    public func saveImages(imagesArray:[UIImage],completionHandler :@escaping (Bool)->()){
        for i in imagesArray{
            UIImageWriteToSavedPhotosAlbum(i, nil, nil, nil)
        }
        completionHandler(true)
    }
}
