//
//  UIImage+Extensions.swift
//  CoreML-SwiftUI-Integration
//
//  Created by Mitya Kim on 7/18/22.
//

import Foundation
import UIKit
import VideoToolbox


extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func toCVPixelBuffer() -> CVPixelBuffer? {
           
           let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
             var pixelBuffer : CVPixelBuffer?
             let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
             guard (status == kCVReturnSuccess) else {
               return nil
             }

             CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
             let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

             let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
             let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

             context?.translateBy(x: 0, y: self.size.height)
             context?.scaleBy(x: 1.0, y: -1.0)

             UIGraphicsPushContext(context!)
             self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
             UIGraphicsPopContext()
             CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

             return pixelBuffer
           
           
       }
    
}
