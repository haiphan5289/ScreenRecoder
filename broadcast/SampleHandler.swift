//
//  SampleHandler.swift
//  broadcast
//
//  Created by haiphan on 28/05/2023.
//

import ReplayKit

extension FileManager {

    func removeFileIfExists(url: URL) {
        guard fileExists(atPath: url.path) else { return }
        do {
            try removeItem(at: url)
        } catch {
            print("error removing item \(url)", error)
        }
    }
}

class SampleHandler: RPBroadcastSampleHandler {
    
    private var writer: BroadcastWriter?
    private let fileManager: FileManager = .default
    let userDefault = UserDefaults(suiteName: ConstantApp.appGroupName)
    private let notificationCenter = UNUserNotificationCenter.current()
    private let nodeURL: URL

    override init() {
        nodeURL = fileManager.temporaryDirectory
            .appendingPathComponent(ConstantApp.shared.parseTime())
            .appendingPathExtension(for: .mpeg4Movie)
        

        fileManager.removeFileIfExists(url: nodeURL)

        super.init()
    }

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        let screen: UIScreen = .main
        do {
            writer = try .init(
                outputURL: nodeURL,
                screenSize: screen.bounds.size,
                screenScale: screen.scale
            )
        } catch {
            assertionFailure(error.localizedDescription)
            finishBroadcastWithError(error)
            return
        }
        do {
            try writer?.start()
            self.userDefault?.set(3, forKey: "broadcast")
            self.userDefault?.synchronize()
        } catch {
            finishBroadcastWithError(error)
        }
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        guard let writer = writer else {
            debugPrint("processSampleBuffer: Writer is nil")
            return
        }

        do {
            let captured = try writer.processSampleBuffer(sampleBuffer, with: sampleBufferType)
            debugPrint("processSampleBuffer captured", captured)
        } catch {
            debugPrint("processSampleBuffer error:", error.localizedDescription)
        }
    }

    override func broadcastPaused() {
        debugPrint("=== paused")
        writer?.pause()
    }

    override func broadcastResumed() {
        debugPrint("=== resumed")
        writer?.resume()
    }
    
    private func createImagesFolder() {
            // path to documents directory
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        var appURL = URL(fileURLWithPath: Bundle.main.bundleURL.absoluteString)
        appURL.deleteLastPathComponent()
    
            if let documentDirectoryPath = documentDirectoryPath {
                // create the custom folder path
//                let imagesDirectoryPath = appURL.path.appending("/images")
                
                let imagesDirectoryPath = documentDirectoryPath.appending("/images")
                let fileManager = FileManager.default
                if !fileManager.fileExists(atPath: imagesDirectoryPath) {
                    do {
                        try fileManager.createDirectory(atPath: imagesDirectoryPath,
                                                        withIntermediateDirectories: false,
                                                        attributes: nil)
                        print("fileManager.createDirectory ==== \(imagesDirectoryPath)")
                    } catch {
                        print("Error creating images folder in documents dir: \(error.localizedDescription)")
                    }
                }
            }
        }

    override func broadcastFinished() {
        guard let writer = writer else {
            return
        }

        let outputURL: URL
        do {
            outputURL = try writer.finish()
        } catch {
            debugPrint("writer failure", error)
            return
        }
        
        guard let containerURL = fileManager.containerURL(
            forSecurityApplicationGroupIdentifier: ConstantApp.appGroupName
        )?.appendingPathComponent("\(ConstantApp.FolderName.folderBroadcast)/") else {
            fatalError("no container directory")
        }
        do {
            try fileManager.createDirectory(
                at: containerURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            debugPrint("error creating", containerURL, error)
        }

        let destination = containerURL.appendingPathComponent(outputURL.lastPathComponent)
        do {
            debugPrint("Moving", outputURL, "to:", destination)
            try self.fileManager.moveItem(
                at: outputURL,
                to: destination
            )
            self.userDefault?.set(4, forKey: "broadcast")
            self.userDefault?.synchronize()
        } catch {
            debugPrint("ERROR", error)
        }

        debugPrint("FINISHED")
    }

    private func scheduleNotification() {
        print("scheduleNotification")
        let content: UNMutableNotificationContent = .init()
        content.title = "broadcastStarted"
        content.subtitle = Date().description

        let trigger: UNNotificationTrigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let notificationRequest: UNNotificationRequest = .init(
            identifier: "com.andrykevych.Some.broadcastStarted.notification",
            content: content,
            trigger: trigger
        )
        notificationCenter.add(notificationRequest) { (error) in
            print("add", notificationRequest, "with ", error?.localizedDescription ?? "no error")
        }
    }
}
