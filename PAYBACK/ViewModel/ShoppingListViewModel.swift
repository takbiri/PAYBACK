//
//  ShoppingListViewModel.swift
//  PAYBACK
//
//  Created by Mohammad Takbir on 6/20/21.
//

import Foundation


protocol ShoppingListViewModelDelegate {
    func didFinishFetchShoppingList(_ list: [ShoppingItem])
}

class ShoppingListViewModel {
    var delegate: ShoppingListViewModelDelegate?
    var shoppingListCDModel = ShoppingListCDModel()
    
    func fetchList(){
        shoppingListCDModel.delegate = self
        shoppingListCDModel.readData()
    }
    
    func saveItem(item: ShoppingItem){
        if shoppingListCDModel.saveData(item){
            fetchList()
        }
        
    }
    
    func deleteItem(item: ShoppingItem){
        shoppingListCDModel.deleteItem(item)
    }
}

extension ShoppingListViewModel: ShoppingListCDModelDelegate {
    func shoppingListData(_ list: [ShoppingItem]) {
        delegate?.didFinishFetchShoppingList(list)
    }
    
    
}
