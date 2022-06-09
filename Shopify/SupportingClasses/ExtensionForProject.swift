//
//  ExtensionForProject.swift
//  Shopify
//
//  Created by Trident on 08/06/22.
//

import Foundation
import UIKit
import WebKit

var indicator = UIActivityIndicatorView()

extension UIViewController{
    
    //MARK: setActivityIndicator
    func setUpActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: zero, y: zero, width: forty, height: forty))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    func startActivityIndicator(backgroundColor:UIColor){
        setUpActivityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = backgroundColor
    }
    func stopActivityIndicator(){
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    
}

extension UIFont {
    
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func InterBold(ofSize size: CGFloat) -> UIFont {
        return customFont(name: InterBoldStr, size: size)
    }
    
    static func InterRegular(ofSize size: CGFloat) -> UIFont {
        return customFont(name: InterRegularStr, size: size)
    }
    
}


extension UIColor {
    
    struct AppBlack {
        static let Base = UIColor(named: AppBlackStr)
    }
    struct AppTextGray {
        static let Base = UIColor(named: AppTextGrayStr)
    }
    struct AppWhite {
        static let Base = UIColor(named: AppWhiteStr)
    }
    struct AppBackGround {
        static let Base = UIColor(named: AppBackGroundStr)
    }
}


extension WKWebView {
    
    func loadHTMLStringWithMagic(content:String,baseURL:URL?){
        let headerString = HTMLFontSizeIncrease
        loadHTMLString(headerString + content, baseURL: baseURL)
    }
}
