//
//  UIImageView+Invert.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 21/11/2022.
//

import UIKit

extension UIImage{
    
    ///Invert the image color
    func inverted() -> UIImage!{
        let context = CIContext()
        let beginImage = CIImage(image: self)
        
        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            if let output = filter.outputImage{
                if let retImg = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: retImg)
                }
            }
        }
        return nil
    }
}
