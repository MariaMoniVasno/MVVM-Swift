//
//  ImageCaches.swift
//  Shopify
//
//  Created by Trident on 07/06/22.
//

import Foundation
import UIKit

var imageCaches:NSCache<AnyObject, AnyObject>!

class ImageCaches:NSObject {
    //MARK: initializingCache
    class func initializeCache() {
        imageCaches = NSCache.init()
    }
    
    //MARK: storeImage
    class func storeImage(_ image:UIImage,url:AnyObject) {
        let checkImage:UIImage! = image
        if checkImage != nil {
            imageCaches.setObject(image, forKey:url)
            //Storing image to user defaults
            self.storeImageOnUserDefaults(image: image, url: url)
        }
    }
    
    //MARK: getImage
    class func getImage(_ url:AnyObject)->UIImage {
        if imageCaches.object(forKey: url) == nil {
            _ = self.isImageExistOnUserDefaults(url: url)
            if imageCaches.object(forKey: url) != nil {
                return imageCaches.object(forKey: url)! as! UIImage
            } else {
                return UIImage.init()
            }
        } else {
            return imageCaches.object(forKey: url)! as! UIImage
        }
    }
    
    //MARK: isImageExistOnCache
    class func isImageExistOnCache(_ url:AnyObject)->Bool {
        return (imageCaches.object(forKey: url) != nil || isImageExistOnUserDefaults(url: url)) ?  true : false
    }
    
    //MARK: storeImageOnUserDefaults
    class func storeImageOnUserDefaults(image:UIImage,url:AnyObject) {
        //Storing image to user defaults if not exist
        let imageData:Data! = image.pngData()
        UserDefaults.standard.set(imageData, forKey: url as! String)
    }
    
    //MARK: isImageExistOnUserDefaults
    class func isImageExistOnUserDefaults(url:AnyObject)->Bool {
        if UserDefaults.standard.object(forKey: url as! String) != nil {
            //Retrieving image from user defaults
            let imageData = UserDefaults.standard.object(forKey: "\(url)")
            if imageData != nil {
                if UIImage(data:imageData as! Data) != nil {
                    let image  = UIImage.init(data: imageData as! Data)
                    //Storing image to cache
                    self.storeImage(image!, url: url)
                    return true
                }
                return false
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    //MARK:- Get Images from URL
    class func getImages(imageURL:String = EmptyStr,completion:@escaping (_ downlaodedImage:UIImage)->Void) {
        let encodedUrl : String! = imageURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        // Checking image exist in the cache or not
        if ImageCaches.isImageExistOnCache(encodedUrl as AnyObject) {
            completion(ImageCaches.getImage(encodedUrl as AnyObject))
        } else {
            // Not Exist
            let queue:DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
            queue.async(execute: { () -> Void in
                let imageData:Data! = try? Data.init(contentsOf: URL.init(string:encodedUrl)!)
                DispatchQueue.main.async(execute: { () -> Void in
                    if imageData != nil {
                        if UIImage(data:imageData) != nil {
                            //Storing the image in the cache
                            ImageCaches.storeImage(UIImage(data:imageData)!, url: encodedUrl as AnyObject)
                            completion(UIImage(data:imageData)!)
                        }
                    }
                })
            })
        }
    }
}
