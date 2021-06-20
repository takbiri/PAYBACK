//
//  FeedsViewController.swift
//  PAYBACK
//
//  Created by Mohammad Takbiri on 6/16/21.
//

import UIKit

class TilesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tilesViewModel = TilesViewModel()
    var tiles: [Tile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tilesViewModel.delegate = self
        tilesViewModel.fetchFeeds()
        updateUI()
        
    }
    
    func updateUI(){
        
        self.navigationItem.title = "Tiles"
        tableView.register(UINib(nibName: "TilesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

}

extension TilesViewController: TilesViewModelDelegate, UITableViewDelegate, UITableViewDataSource {
    func didFinishFetchFeeds(_ feeds: [Tile]) {
        self.tiles = feeds
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TilesTableViewCell
        cell.configureCell(self.tiles[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 205
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = self.tiles[indexPath.row]
        if feed.dataType == .shopping_List {
            self.performSegue(withIdentifier: "shoppingList", sender: feed)
        }else if feed.dataType == .website {
            self.performSegue(withIdentifier: "website", sender: feed)
        }else {
            self.performSegue(withIdentifier: "showDetail", sender: feed)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! TileDetailViewController
            vc.tileDetail = sender as? Tile
        }else if segue.identifier == "website" {
            let vc = segue.destination as! WebViewController
            vc.tileDetail = sender as? Tile
        }
    }
}
