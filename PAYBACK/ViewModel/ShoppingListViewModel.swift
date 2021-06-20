//
//  ShoppingListViewModel.swift
//  PAYBACK
//
//  Created by Mohammad Takbiri on 6/20/21.
//

import Foundation


protocol ShoppingListViewModelDelegate {
    func didFinishFetchShoppingList(_ list: [ShoppingList])
}

class ShoppingListViewModel {
    var delegate: ShoppingListViewModelDelegate?
    var shoppingListCDModel = ShoppingListCDModel()
    
    func fetchList(){
        shoppingListCDModel.delegate = self
        shoppingListCDModel.readData()
    }
    
    func saveItem(item: ShoppingList){
        if shoppingListCDModel.saveData(item){
            fetchList()
        }
        
    }
    
    func deleteItem(item: ShoppingList){
        shoppingListCDModel.deleteItem(item)
    }
    
    func resetCoreData(){
        if shoppingListCDModel.resetData(){
            fetchList()
        }
    }
}

extension ShoppingListViewModel: ShoppingListCDModelDelegate {
    func shoppingListData(_ list: [ShoppingList]) {
        delegate?.didFinishFetchShoppingList(list)
    }
    
    
}
