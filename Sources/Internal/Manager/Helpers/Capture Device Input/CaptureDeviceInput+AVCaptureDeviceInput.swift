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
                return AVCaptureDevice.default(devices.first ?? .builtInWideAngleCamera, for: .video, position: .front)
            case .video where position == .back:
                let devices = videoDeviceType(mediaType: mediaType, position: position!)
                return AVCaptureDevice.default(devices.first ?? .builtInWideAngleCamera, for: .video, position: .back)
            default:
                fatalError()
            }
        }()

        guard let device, let deviceInput = try? Self(device: device) else { return nil }
        return deviceInput
    }
    
    private static func videoDeviceType(mediaType: AVMediaType, position: AVCaptureDevice.Position) -> [AVCaptureDevice.DeviceType] {
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
        return devices.map { $0.deviceType }
    }
}
