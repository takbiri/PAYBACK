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
    var cdModel = TilesCDModel()
    
    func fetchFeeds(){
        
        SVProgressHUD.show()
        cdModel.delegate = self
        
        guard let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/payback-test.appspot.com/o/feed.json?alt=media&token=0f3f9a33-39df-4ad2-b9df-add07796a0fa") else {return}
        
        AF.request(url).response { response in
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                switch response.result {
                
                case .success:
                    do {
                        
                        let result = try JSONDecoder().decode(Tiles.self, from: response.data!)
                        var tiles = self.defineDataType(result)
                        tiles = self.sort(tiles)
                        
                        self.delegate?.didFinishFetchFeeds(tiles)
                        self.cdModel.resetData()
                        self.cdModel.saveData(tiles)
                        
                    }catch let error {
                        print("can't decode the data: \(error.localizedDescription)")
                        self.cdModel.readData()
                    }
                    break
                    
                case .failure(let error):
                    print("error for service is \(error.localizedDescription)")
                    self.cdModel.readData()
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
                tile.dataType = .shopping_List
            }
            tiles.append(tile)
        }
        return tiles
        
    }
    
}

extension TilesViewModel: TilesCDModelDelegate {
    func tilesOfflineData(_ feeds: [Tile]) {
        if feeds.count != 0 {
            self.delegate?.didFinishFetchFeeds(feeds)
        }
    }
    
    func sort(_ tiles: [Tile]) -> [Tile]{
        return tiles.sorted { (tile1,tile2) -> Bool in
            tile1.score > tile2.score
        }
    }
}
