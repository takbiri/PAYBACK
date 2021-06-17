//
//  ThumbnailImageForVideo.swift
//  PAYBACK
//
//  Created by Mohammad Takbiri on 6/17/21.
//

import Foundation
import AVFoundation
import UIKit

class ThumbnailImageForVideo: NSObject{
    
    class func getThumbnailFromUrl(_ url: String?, _ completion: @escaping ((_ image: UIImage?)->Void)) {
        
        guard let url = URL(string: url ?? "") else { return }
        DispatchQueue.main.async {
            let asset = AVAsset(url: url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            
            let time = CMTimeMake(value: 2, timescale: 1)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                completion(thumbnail)
            } catch {
                print("Error :: ", error.localizedDescription)
                completion(nil)
            }
        }
    }
}
