//
//  CDModel.swift
//  PAYBACK
//
//  Created by Mohammad Takbiri on 6/18/21.
//

import Foundation
import UIKit
import CoreData

protocol TilesCDModelDelegate {
    func tilesOfflineData(_ feeds: [Tile])
}
class TilesCDModel {
    
    var delegate: TilesCDModelDelegate?
    var managedObjectContext: NSManagedObjectContext!
    var entity: NSManagedObject!
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    init() {
        print("init")
        managedObjectContext = appDelegate!.persistentContainer.viewContext
    }
    
    func readData(){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        do {
            let results = try managedObjectContext.fetch(request)
            var feeds: [Tile] = []

            for result in results as! [NSManagedObject] {
                let tile = Tile(name: "\(result.value(forKey: "name") ?? "")",
                                headline: "\(result.value(forKey: "headline") ?? "")",
                                subline: "\(result.value(forKey: "subline") ?? "")",
                                data: "\(result.value(forKey: "data") ?? "")",
                                score: result.value(forKey: "score") as! Int,
                                dataType: nil)
                feeds.append(tile)
            }
            self.delegate?.tilesOfflineData(feeds)
            
        }catch let error {
            print("error for fetching from CoreData: \(error.localizedDescription)")
        }
        
    }
    
    func saveData(_ feeds: [Tile]){
        
        for tile in feeds {
            entity = NSEntityDescription.insertNewObject(forEntityName: "Feed", into: managedObjectContext)
            entity.setValue(tile.name, forKey: "name")
            entity.setValue(tile.headline, forKey: "headline")
            entity.setValue(tile.subline, forKey: "subline")
            entity.setValue(tile.data, forKey: "data")
            entity.setValue(tile.score, forKey: "score")
            do {
                try managedObjectContext.save()
            }catch let error {
                print("error in saving data: \(error.localizedDescription)")
            }
        }
    }
    
    func resetData(){
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
            let request: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try managedObjectContext.execute(request)
            try managedObjectContext.save()
        } catch let error {
            print("error for reset core data: \(error.localizedDescription)")
        }
    }
}

