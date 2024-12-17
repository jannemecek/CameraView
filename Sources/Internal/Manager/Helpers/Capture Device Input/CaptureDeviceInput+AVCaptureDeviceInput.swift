//
//  CaptureDeviceInput+AVCaptureDeviceInput.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import AVKit

extension AVCaptureDeviceInput: CaptureDeviceInput {
    static func get(mediaType: AVMediaType, position: AVCaptureDevice.Position?) -> Self? {
        let device = {
            switch mediaType {
            case .audio:
                return AVCaptureDevice.default(for: .audio)
            case .video where position == .front:
                let devices = videoDeviceType(mediaType: mediaType, position: position!)
                return devices.first ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            case .video where position == .back:
                let devices = videoDeviceType(mediaType: mediaType, position: position!)
                return devices.first ?? AVCaptureDevice.default(for: .video)
            default:
                fatalError()
            }
        }()

        guard let device, let deviceInput = try? Self(device: device) else { return nil }
        return deviceInput
    }
    
    var defaultZoomLevel: CGFloat {
        if #available(iOS 18.0, *) {
            if device.displayVideoZoomFactorMultiplier != 1.0 {
                return device.videoZoomFactor/device.displayVideoZoomFactorMultiplier
            }
        }
        return 1
    }
    
    private static func videoDeviceType(mediaType: AVMediaType, position: AVCaptureDevice.Position) -> [AVCaptureDevice] {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            // TODO: Extract preferred device types to be a public API
            deviceTypes: [.builtInTripleCamera, .builtInDualCamera, .builtInWideAngleCamera],
            mediaType: mediaType,
            position: position
        )
        let devices = discoverySession.devices
        
        print("Available camera devices:")
        for device in devices {
            print("Device name: \(device.localizedName)")
        }
        return devices
    }
}
