import UIKit
import AVFoundation

class ReadBarcodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var getCode: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        self.tabBarController?.tabBar.isHidden = true

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else {
            print("Kamerani sozlashda xatolik")
            return
        }

        captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()

        guard captureSession.canAddOutput(metadataOutput) else {
            print("Output qo‘shilmadi")
            return
        }

        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .code128, .qr]

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }

    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = metadataObject.stringValue else { return }

        // Kamera vibratsiyasi
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        // Kodni uzatish va oynani yopish
        captureSession.stopRunning()
        dismiss(animated: true) {
            self.getCode?(stringValue)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
}
