////
////  CameraPreviewLayer.swift
////  DoubleStream
////
////  Created by Manh Pham on 10/17/20.
////  Copyright © 2020 Softvelum, LLC. All rights reserved.
////
//
import Foundation
import UIKit
import AVFoundation
import CoreImage

class CameraPreviewLayer: UIView {
    
   // var orientation: UIImage.Orientation = .up
    
    var currentCGImage: CGImage? {
        didSet {
            if let currentCGImage = currentCGImage {
                autoreleasepool {
                    layer.contents = currentCGImage
                }
                //self.image = UIImage(cgImage: currentCGImage, scale: 1, orientation: orientation)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        layer.contentsGravity = .resizeAspect
        layer.isGeometryFlipped = true
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
