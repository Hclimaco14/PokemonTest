//
//  Extensions.swift
//  Utils Hector
//
//  Created by Hector Climaco on 12/07/22.
//

import Foundation
import UIKit


let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String,imgDefault: UIImage = UIImage()) {
        let url = URL(string: urlString)
        if url == nil { return }
        
        DispatchQueue.main.async {
            self.image = nil
            self.image = imgDefault
            self.contentMode = .scaleAspectFit
            if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
                self.image = cachedImage
                self.contentMode = .scaleAspectFill
                return
            }
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
            
                if error != nil {
                    self.image = imgDefault
                    self.contentMode = .scaleAspectFit
                    print(error!)
                    return
                }
                
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    self.contentMode = .scaleAspectFit
                }
            }
            
        }).resume()
        
        
    }
    
}

extension UIView {
    func addBlurEffect() {
        DispatchQueue.main.async {
          let blurEffect = UIBlurEffect(style: .light)
          let blurEffectView = UIVisualEffectView(effect: blurEffect)
          blurEffectView.frame = self.bounds

          blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
          self.addSubview(blurEffectView)
        }
      }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
