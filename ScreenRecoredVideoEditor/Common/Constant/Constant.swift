//
//  Constant.swift
//  CameraMakeUp
//
//  Created by haiphan on 22/09/2021.
//

import Foundation
import UIKit

final class ConstantApp {
    
    enum FolderName: String, CaseIterable {
        case folderBroadcast, folderRecordFinish
    }
    
    static var shared = ConstantApp()
    
    private init() {}
    
    static let appGroupName = "group.haiphan.ScreenRecoredVideoEditor"
    
    func parseTime() -> String {
        return self.parseDatetoString()
    }
    
    func parseDatetoString() -> String {
         let date = Date()
         let calendar = Calendar.current
         let components = calendar.dateComponents([.year, .month, .day, .second, .hour], from: date)

         let year =  components.year ?? 0
         let month = components.month ?? 0
         let day = components.day ?? 0
         let h = components.hour ?? 0
         let second = components.second ?? 0
         return "\(year)\(month)\(day)\(h)\(second)"
     }
    
    func removeFilesFolder() {
        let fileManager = FileManager.default
        guard let containerURL = fileManager.containerURL(
            forSecurityApplicationGroupIdentifier: ConstantApp.appGroupName
        )?.appendingPathComponent("\(ConstantApp.FolderName.folderBroadcast)/") else {
            fatalError("no container directory")
        }
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: containerURL , includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for filePath in contents {
                try fileManager.removeItem(at: filePath)
            }
        } catch let err {
            print("\(err.localizedDescription)")
        }
    }
    
}
