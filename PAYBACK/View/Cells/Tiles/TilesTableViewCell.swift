//
//  FeedsTableViewCell.swift
//  PAYBACK
//
//  Created by Mohammad Takbiri on 6/16/21.
//

import UIKit
import SDWebImage

class TilesTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var sublineLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    
    @IBOutlet weak var sublineBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentBottomConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backView.layer.cornerRadius = 8
        self.backView.layer.masksToBounds = true
                
    }
    
    func configureCell(_ tile: Tile){
        
        self.headlineLabel.text = tile.headline
        self.sublineLabel.text = tile.subline
        self.playImageView.alpha = 0.0
        
        switch tile.dataType {
        case .image:
            guard let url = URL(string: tile.data!) else {break}
            self.contentImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "notFound"))
            break
            
        case .video:
            self.playImageView.alpha = 1.0
            self.contentImageView.image = UIImage(named: "notFound")
            break
            
        case .website:
            self.contentImageView.image = UIImage(named: "safari")
            break
            
        case .shopping_List:
            self.contentImageView.image = UIImage(named: "bag")
            break
            
        default:
            break
        }
        self.updateConstraints(sublineText: tile.subline ?? "")

        
    }
    
    func updateConstraints(sublineText: String){
        if sublineText == "" {
            sublineBottomConstraint.constant = 0.0
            contentBottomConstraint.constant = 8.0
            layoutIfNeeded()
        }else {
            sublineBottomConstraint.constant = 15.0
            contentBottomConstraint.constant = 10.0
        }
    }
    
}
