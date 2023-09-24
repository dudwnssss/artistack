//
//  RecordViewController.swift
//  ARTISTACK
//
//  Created by 임영준 on 2023/08/23.
//

import UIKit
import AVFoundation

class RecordViewController: BaseViewController {

    let recordView = RecordView()
    
    override func loadView() {
        self.view = recordView
    }
    

    var captureSession = AVCaptureSession()
    var videoDevice: AVCaptureDevice!
    var videoInput: AVCaptureDeviceInput!
    var audioInput: AVCaptureDeviceInput!
    var videoOutput: AVCaptureMovieFileOutput!
    var deviceOrientation: AVCaptureVideoOrientation = .portrait
    var outputURL: URL?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
        }
    }
    
    private func setupSession() {
      do {
        captureSession.beginConfiguration()
        
        videoInput = try AVCaptureDeviceInput(device: videoDevice!)
        if captureSession.canAddInput(videoInput) {
          captureSession.addInput(videoInput)
        }

        let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
        audioInput = try AVCaptureDeviceInput(device: audioDevice)
        if captureSession.canAddInput(audioInput) {
          captureSession.addInput(audioInput)
        }

        videoOutput = AVCaptureMovieFileOutput()
        if captureSession.canAddOutput(videoOutput) {
          captureSession.addOutput(videoOutput)
        }

        captureSession.commitConfiguration()
      }
      catch let error as NSError {
        NSLog("\(error), \(error.localizedDescription)")
      }
    }
    
    private func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
      var deviceTypes: [AVCaptureDevice.DeviceType]!
      
      if #available(iOS 11.1, *) {
        deviceTypes = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
      } else {
        deviceTypes = [.builtInDualCamera, .builtInWideAngleCamera]
      }
      
      let discoverySession = AVCaptureDevice.DiscoverySession(
        deviceTypes: deviceTypes,
        mediaType: .video,
        position: .unspecified
      )
      
      let devices = discoverySession.devices
      guard !devices.isEmpty else { fatalError("Missing capture devices.")}
      
      return devices.first(where: { device in device.position == position })!
    }
    
    private func swapCameraType() {
      guard let input = captureSession.inputs.first(where: { input in
        guard let input = input as? AVCaptureDeviceInput else { return false }
        return input.device.hasMediaType(.video)
      }) as? AVCaptureDeviceInput else { return }
      
      captureSession.beginConfiguration()
      defer { captureSession.commitConfiguration() }
      
      // Create new capture device
      var newDevice: AVCaptureDevice?
      if input.device.position == .back {
        newDevice = bestDevice(in: .front)
      } else {
        newDevice = bestDevice(in: .back)
      }
      
      do {
        videoInput = try AVCaptureDeviceInput(device: newDevice!)
      } catch let error {
        NSLog("\(error), \(error.localizedDescription)")
        return
      }
      
      // Swap capture device inputs
      captureSession.removeInput(input)
      captureSession.addInput(videoInput!)
    }
    
    
    // MARK:- Recording Methods
    
    private func startRecording() {
      let connection = videoOutput.connection(with: AVMediaType.video)
      
      // orientation을 설정해야 가로/세로 방향에 따른 레코딩 출력이 잘 나옴.
      if (connection?.isVideoOrientationSupported)! {
        connection?.videoOrientation = self.deviceOrientation
      }
      
      let device = videoInput.device
      if (device.isSmoothAutoFocusSupported) {
        do {
          try device.lockForConfiguration()
          device.isSmoothAutoFocusEnabled = false
          device.unlockForConfiguration()
        } catch {
          print("Error setting configuration: \(error)")
        }
      }
      
      outputURL = tempURL()
      videoOutput.startRecording(to: outputURL!, recordingDelegate: self)
    }
    
    private func stopRecording() {
      if videoOutput.isRecording {
        videoOutput.stopRecording()
      }
    }
    
    
    private func tempURL() -> URL? {
      let directory = NSTemporaryDirectory() as NSString
      
      if directory != "" {
        let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
        return URL(fileURLWithPath: path)
      }
      
      return nil
    }
    
    @objc func dismissButtonDidTap(){
        dismiss(animated: true)
    }
    
    @objc func recordButtonDidTap(){
        let vc = CheckRecordViewController()
        navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func setNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dismiss"), style: .plain, target: self, action: #selector(dismissButtonDidTap))
    }
    
    override func setProperties() {
        setNavigationBar()
        view.backgroundColor = .black
        recordView.recordButton.addTarget(self, action: #selector(recordButtonDidTap), for: .touchUpInside)
        videoDevice = bestDevice(in: .back)
        recordView.previewlayer.session = captureSession
        setupSession()
    }
}

extension RecordViewController: AVCaptureFileOutputRecordingDelegate {
  
  // 레코딩이 시작되면 호출
  func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
    
  }
  
  // 레코딩이 끝나면 호출
  func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    if (error != nil) {
      print("Error recording movie: \(error!.localizedDescription)")
    } else {
      let videoRecorded = outputURL! as URL
      UISaveVideoAtPathToSavedPhotosAlbum(videoRecorded.path, nil, nil, nil)
    }
  }
  
}
