//
//  ImageDetectionManager.swift
//  CoreML-SwiftUI-Integration
//
//  Created by Mitya Kim on 7/18/22.
//

import Foundation
import CoreML
import UIKit

class ImageDetectionManager {
    
    let model = Resnet50()
    
    func detect(_ img: UIImage) -> String? {
       
        guard let pixelBuffer = img.toCVPixelBuffer(),
              let prediction = try? model.prediction(image: pixelBuffer)
        else {
            return nil
        }
        return prediction.classLabel
    }
}
