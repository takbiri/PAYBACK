//
//  ShoppingListViewModelTests.swift
//  PAYBACKTests
//
//  Created by Mohammad Takbir on 6/20/21.
//

import XCTest
@testable import PAYBACK

class ShoppingListCDModelTests: XCTestCase, ShoppingListCDModelDelegate {
   
    var shoppingListCDModel: ShoppingListCDModel!
    var shoppingExpectation: XCTestExpectation!
    var results: [ShoppingItem]!
    
    override func setUp() {
        shoppingListCDModel = ShoppingListCDModel()
        shoppingListCDModel.delegate = self
                
        super.setUp()
    }
    
    func testSaveData(){
        
        let shoppingItem = ShoppingItem(title: "test 1")
        let status = shoppingListCDModel.saveData(shoppingItem)
        
        XCTAssertTrue(status)
    }
    
    func testReadData(){
        shoppingExpectation = expectation(description: "Shopping")
        
        shoppingListCDModel.readData()
        
        waitForExpectations(timeout: 6)
        XCTAssertEqual(self.results[0].title, "test 1")
        
    }
    
    
    func testDeleteItem(){
        let item = ShoppingItem(title: "test 1")
        shoppingListCDModel.deleteItem(item)
    }
    
    override func tearDown() {
        shoppingListCDModel = nil
        super.tearDown()
    }

    
    // Delegate of ShoppingListCDModel
    func shoppingListData(_ list: [ShoppingItem]) {
        self.results = list
        shoppingExpectation.fulfill()
    }
    

}
