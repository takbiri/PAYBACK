//
//  FeedsDetailViewController.swift
//  PAYBACK
//
//  Created by Mohammad Takbiri on 6/17/21.
//

import UIKit
import AVFoundation
import AVKit

class TileDetailViewController: UIViewController {
    
    var url: URL!
    var tileDetail: Tile!{
        didSet{
            if let data = tileDetail.data{
                url = URL(string: data)!
            }
        }
    }
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var sublineLabel: UILabel!
    @IBOutlet weak var playImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDetail()
        
    }

    func updateDetail(){
        self.navigationItem.title = tileDetail.headline
        self.headlineLabel.text = tileDetail.headline
        self.sublineLabel.text = tileDetail.subline
        
        switch tileDetail.dataType {
        case .image:
            self.contentImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "notFound"))
            break
            
        case .video:
            self.contentImageView.isUserInteractionEnabled = true
            self.playImageView.alpha = 1.0
            self.contentImageView.image = UIImage(named: "notFound")
            self.showAlert()
            break
            
        default:
            break
        }
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        self.present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Error", message: "The certificate for this server is invalid. You might be connecting to a server that is pretending to be “www.sample-videos.com” which could put your confidential information at risk.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { button in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func playVideoTapGesture(_ sender: Any) {
        playVideo(url: url)
    }
    @IBAction func websiteButtonDidTouch(_ sender: Any) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
