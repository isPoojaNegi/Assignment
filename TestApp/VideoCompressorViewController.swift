//
//  VideoCompressorViewController.swift
//  TestApp
//
//  Created by Pooja on 26/06/23.
//

import UIKit
import AVKit
import MobileCoreServices

class VideoCompressorViewController: UIViewController {
    
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeMinusButton: UIButton!
    @IBOutlet weak var volumePlusButton: UIButton!
    @IBOutlet weak var chooseGalleryButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var compressedURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player?.replaceCurrentItem(with: nil)
        playButton.isHidden = true
        volumePlusButton.isHidden = true
        volumeMinusButton.isHidden = true
        chooseGalleryButton.isHidden = false
        pauseButton.isHidden = true
        
    }
    
    
    @IBAction func openGalleryButtonTapped(_ sender: UIButton) {
        chooseGalleryButton.isHidden = true
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [UTType.movie.identifier,UTType.video.identifier]
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        player?.play()
        playButton.isHidden = true
        pauseButton.isHidden = false
    }
    
    
    @IBAction func pauseBtnTapped(_ sender: UIButton) {
        player?.pause()
        pauseButton.isHidden = true
        playButton.isHidden = false
    }
    
    @IBAction func volumeUpBtnTapped(_ sender: UIButton) {
        let desiredVolume = (player?.volume ?? 0.0) + 0.3
        player?.volume = min(desiredVolume,0.1)
    }
    
    @IBAction func volumeDownBtnTapped(_ sender: UIButton) {
        let desiredVolume = (player?.volume ?? 0.0) - 0.3
        player?.volume = max(desiredVolume,0.1)
    }
}

extension VideoCompressorViewController : UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        guard let videoURL = info[.mediaURL] as? URL else { return }
        showCompressionAlert(for: videoURL)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

extension VideoCompressorViewController {
    
    func showCompressionAlert(for videoURL: URL) {
        let alertController = UIAlertController(title: "Video Compression", message: "Select a compression quality", preferredStyle: .alert)
        
        let compressionValues = [Quality.low.rawValue, Quality.medium.rawValue, Quality.high.rawValue]
        for value in compressionValues {
            let action = UIAlertAction(title: "\(value)", style: .default) { [weak self] _ in
                self?.compressVideo(from: videoURL, with: value)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func compressVideo(from videoURL: URL, with quality: String) {
        let asset = AVAsset(url: videoURL)
        let exportQuality: [String] = [
            AVAssetExportPresetLowQuality,
            AVAssetExportPresetMediumQuality,
            AVAssetExportPresetHighestQuality
        ]
        var index = 0
        switch quality {
        case Quality.low.rawValue :
            index = 0
        case Quality.medium.rawValue :
            index = 1
        default:
            index = 2
        }
        let compressedFileName = "compressed_video_\(Date().timeIntervalSince1970).mp4"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let compressedURL = documentsDirectory.appendingPathComponent(compressedFileName)
        
        let selectedExportQuality = exportQuality[index]
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: selectedExportQuality)
        exportSession?.outputFileType = .mp4
        exportSession?.outputURL = compressedURL
        exportSession?.shouldOptimizeForNetworkUse = true
        
        exportSession?.exportAsynchronously(completionHandler: { [weak self] in
            DispatchQueue.main.async {
                self?.playVideo(from: compressedURL)
                self?.playButton.isHidden = false
                self?.volumePlusButton.isHidden = false
                self?.volumeMinusButton.isHidden = false
                
            }
        })
    }
    
    func playVideo(from url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoPlayerView.bounds
        videoPlayerView.layer.addSublayer(playerLayer!)
    }
}


enum Quality : String{
    case low = "Low Quality"
    case medium = "Medium Quality"
    case high = "High Quality"
}
