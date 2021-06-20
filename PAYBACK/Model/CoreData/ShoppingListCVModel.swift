//
//  ShoppingListCVModel.swift
//  PAYBACK
//
//  Created by Mohammad Takbiri on 6/20/21.
//

import Foundation
import UIKit
import CoreData

protocol ShoppingListCDModelDelegate {
    func shoppingListData(_ list: [ShoppingList])
}
class ShoppingListCDModel {
    
    var delegate: ShoppingListCDModelDelegate?
    var managedObjectContext: NSManagedObjectContext!
    var entity: NSManagedObject!
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    init() {
        print("init")
        managedObjectContext = appDelegate!.persistentContainer.viewContext
    }
    
    func readData(){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping_List")
        do {
            let results = try managedObjectContext.fetch(request)
            var list: [ShoppingList] = []

            for result in results as! [NSManagedObject] {
                let shoppingItem = ShoppingList(title: "\(result.value(forKey: "title") ?? "")")
                list.append(shoppingItem)
            }
            self.delegate?.shoppingListData(list)
            
        }catch let error {
            print("error for fetching from CoreData: \(error.localizedDescription)")
        }
        
    }
    
    func saveData(_ item: ShoppingList) -> Bool{
        
        entity = NSEntityDescription.insertNewObject(forEntityName: "Shopping_List", into: managedObjectContext)
        entity.setValue(item.title, forKey: "title")
        do {
            try managedObjectContext.save()
            return true
        }catch let error {
            print("error in saving data: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteItem(_ item: ShoppingList){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping_List")
        request.predicate = NSPredicate(format: "title = %@", item.title)
        do {
            var results = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if results.count != 0 {
                managedObjectContext.delete(results[0])
                results.removeFirst()
            }
            try managedObjectContext.save()
            
        }catch let error {
            print("error for fetching from CoreData: \(error.localizedDescription)")
        }
    }
    
    func resetData() -> Bool{
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping_List")
            let request: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try managedObjectContext.execute(request)
            try managedObjectContext.save()
            return true
        } catch let error {
            print("error for reset core data: \(error.localizedDescription)")
            return false
        }
    }
}

