//
//  SetupCameraManager.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 23/06/2023.
//

import Foundation
import AVFoundation
import UIKit

final class SetupCameraManage {
    
    var setupCameraSuccess: (() -> Void)?
    var setupFailure: (() -> Void)?
    
    private let photoOutput = AVCapturePhotoOutput()
    
    private func setupCaptureSession(frame: CGRect, parentView: UIView) {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
            for: .video,
            position: .front) else {
            return
        }
        let captureSession = AVCaptureSession()
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Failed to set input device with error: \(error)")
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraLayer.frame = frame
        cameraLayer.videoGravity = .resizeAspectFill
        parentView.layer.addSublayer(cameraLayer)
        
        captureSession.startRunning()
        setupCameraSuccess?()
    }
    
    func openCamera(frame: CGRect, parentView: UIView) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // the user has already authorized to access the camera.
            self.setupCaptureSession(frame: frame, parentView: parentView)
            
        case .notDetermined: // the user has not yet asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted { // if user has granted to access the camera.
                    print("the user has granted to access the camera")
                    DispatchQueue.main.async {
                        self.setupCaptureSession(frame: frame, parentView: parentView)
                    }
                } else {
                    print("the user has not granted to access the camera")
                    self.setupFailure?()
                }
            }
            
        case .denied:
            print("the user has denied previously to access the camera.")
            self.setupFailure?()
            
        case .restricted:
            print("the user can't give camera access due to some restriction.")
            self.setupFailure?()
            
        default:
            print("something has wrong due to we can't access the camera.")
            self.setupFailure?()
        }
    }
    
}
