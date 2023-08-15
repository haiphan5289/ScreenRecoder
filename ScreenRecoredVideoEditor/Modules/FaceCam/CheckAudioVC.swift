
//
//  
//  CheckAudioVC.swift
//  ScreenRecoredVideoEditor
//
//  Created by haiphan on 09/08/2023.
//
//
import UIKit
import RxCocoa
import RxSwift
import AVFoundation

class CheckAudioVC: UIViewController {
    
    // Add here outlets
    
    // Add here your view model
    private var viewModel: CheckAudioVM = CheckAudioVM()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    public var sessionQueue = DispatchQueue(label: "FacecameQueue")
    @IBOutlet weak var audioView: UIView!
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupRX()
    }
    
}
extension CheckAudioVC {
    
    private func setupUI() {
        // Add here the setup for the UI
        
        captureSession = AVCaptureSession()
        
        do {
                guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else {
                    print("Default audio device is unavailable.")
//                    setupResult = .configurationFailed
                    captureSession.commitConfiguration()
                    return
                }

                // Add audio input
                let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                } else {
                    print("Couldn't add audio device input to the session.")
//                    captureSession = .configurationFailed
                    captureSession.commitConfiguration()
                }
            
//            let queue = DispatchQueue(label: "AudioSessionQueue", attributes: [])
            let audioOutput = AVCaptureAudioDataOutput()
            audioOutput.setSampleBufferDelegate(self, queue: sessionQueue)
            if captureSession.canAddOutput(audioOutput) {
                captureSession.addOutput(audioOutput)
            }

            } catch {
                print("Couldn't create Audio device input: \(error)")
//                setupResult = .configurationFailed
                captureSession.commitConfiguration()
            }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = audioView.bounds
        previewLayer.videoGravity = .resizeAspect
        audioView.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    private func setupRX() {
        // Add here the setup for the RX
    }
}
extension CheckAudioVC: AVCaptureAudioDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard CMSampleBufferDataIsReady(sampleBuffer) else {
            ////DLog("sample buffer is not ready, skipping sample")
            return
        }
    }
}
