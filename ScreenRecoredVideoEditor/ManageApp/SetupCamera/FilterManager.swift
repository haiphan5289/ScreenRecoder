//
//  FilterManager.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 21/09/2023.
//

import Foundation
import UIKit
import CoreImage

final class FilterManager {
    
    struct FilterCIColorModel {
        let image: UIImage?
        let cifilter: CIFilter
    }
    
    static var shared = FilterManager()
    
    private init() {}
    
    func listFilter() -> [FilterCIColorModel] {
        return [
            FilterCIColorModel(image: Asset.iconCIColorClamp.image, cifilter: self.createCIColorClamp()),
            FilterCIColorModel(image: Asset.iconCIColorControls.image, cifilter: self.createCIColorControls()),
            FilterCIColorModel(image: Asset.iconCIExposureAdjust.image, cifilter: self.createCIExposureAdjust()),
            FilterCIColorModel(image: Asset.iconCIColorMatrix.image, cifilter: self.createCIHueAdjust()),
        ]
    }
    
    func createCIColorClamp() -> CIFilter {
        let filter = CIFilter(name: "CIColorClamp")!
        filter.setDefaults()
        filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputMinComponents")
        filter.setValue(CIVector(x: 1, y: 1, z: 1, w: 1), forKey: "inputMaxComponents")
        return filter
    }
    
    func createCIColorControls() -> CIFilter {
        let filter = CIFilter(name: "CIColorControls")!
        filter.setDefaults()
        let number: NSNumber = 0.5
        filter.setValue(number, forKey: "inputBrightness")
        filter.setValue(number, forKey: "inputContrast")
        return filter
    }
    
    func createCIExposureAdjust() -> CIFilter {
        let filter = CIFilter(name: "CIExposureAdjust")!
        filter.setDefaults()
        let number: NSNumber = 2
        filter.setValue(number, forKey: "inputEV")
        return filter
    }
    
    func createCIHueAdjust() -> CIFilter {
        let filter = CIFilter(name: "CIHueAdjust")!
        filter.setDefaults()
        let number: NSNumber = 1
        filter.setValue(number, forKey: "inputAngle")
        return filter
    }

}

extension NSNumber {

    // PartialRangeFrom

    func clamped(bounds: PartialRangeFrom<Float>) -> NSNumber {
        if bounds.lowerBound > self.floatValue {
            return NSNumber(value: bounds.lowerBound)
        }
        return self
    }

    @inlinable func validate(bounds: PartialRangeFrom<Float>) -> Bool {
        return bounds.lowerBound <= self.floatValue
    }

    // PartialRangeThrough

    @inlinable func clamped(bounds: PartialRangeThrough<Float>) -> NSNumber {
        if bounds.upperBound < self.floatValue {
            return NSNumber(value: bounds.upperBound)
        }
        return self
    }

    @inlinable func validate(bounds: PartialRangeThrough<Float>) -> Bool {
        return bounds.upperBound >= self.floatValue
    }

    // ClosedRange

    @inlinable func clamped(bounds: ClosedRange<Float>) -> NSNumber {
        var value = max(bounds.lowerBound, self.floatValue)
        value = min(bounds.upperBound, value)
        return NSNumber(value: value)
    }

    @inlinable func validate(bounds: ClosedRange<Float>) -> Bool {
        return self.floatValue >= bounds.lowerBound && self.floatValue <= bounds.upperBound
    }
}
