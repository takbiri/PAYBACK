//
//  FeedsViewModel.swift
//  PAYBACK
//
//  Created by Mohammad Takbiri on 6/16/21.
//

import Foundation
import Alamofire
import SVProgressHUD

protocol TilesViewModelDelegate {
    func didFinishFetchFeeds(_ feeds: [Tile])
}

class TilesViewModel {
    
    var delegate: TilesViewModelDelegate?
    
    func fetchFeeds(){
        
        SVProgressHUD.show()
        
        guard let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/payback-test.appspot.com/o/feed.json?alt=media&token=0f3f9a33-39df-4ad2-b9df-add07796a0fa") else {return}
        
        AF.request(url).response { response in
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                switch response.result {
                
                case .success:
                    do {
                        
                        let result = try JSONDecoder().decode(Tiles.self, from: response.data!)
                        let tiles = self.defineDataType(result)
                        self.delegate?.didFinishFetchFeeds(tiles)
                        
                    }catch let error {
                        print("can't decode the data: \(error.localizedDescription)")
                    }
                    break
                    
                case .failure(let error):
                    print("error for service is \(error.localizedDescription)")
                    break
                }
                
            }
            
        }
        
    }
    
    func defineDataType(_ result: Tiles) -> [Tile]{
        
        var tiles:[Tile] = []
        for var tile in result.tiles {
            
            if tile.name == "image"{
                tile.dataType = .image
            }else if tile.name == "video" {
                tile.dataType = .video
            }else if tile.name == "website"{
                tile.dataType = .website
            }else {
                tile.dataType = .shoppingList
            }
            tiles.append(tile)
        }
        return tiles
        
    }
    
}
