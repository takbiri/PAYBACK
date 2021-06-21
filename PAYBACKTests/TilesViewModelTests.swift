//
//  TilesViewModel.swift
//  PAYBACKTests
//
//  Created by Mohammad Takbir on 6/20/21.
//

import XCTest
@testable import PAYBACK

class TilesViewModelTests: XCTestCase, TilesViewModelDelegate {
    
    
    var tilesViewModel: TilesViewModel!
    var tiles: Tiles!
    var tilesExpectation: XCTestExpectation!
    var results: [Tile]!
    
    
    override func setUp() {
        tilesViewModel = TilesViewModel()
        tilesViewModel.delegate = self
        let tile1 = Tile(name: "website", headline: "It's test", subline: "Test again", data: "https://", score: 24, dataType: nil)
        let tile2 = Tile(name: "video", headline: "It's test 2", subline: "Test again 2", data: "https:// 2", score: 40, dataType: nil)
        tiles = Tiles(tiles: [tile1, tile2])
        
        super.setUp()
    }
    
    func testDefineDataType(){
        
        let newTiles = tilesViewModel.defineDataType(tiles)
        
        XCTAssertEqual(DataType.video, newTiles[1].dataType)
        XCTAssertEqual(DataType.website, newTiles[0].dataType)
        
    }
    
    func testFetchData(){
        tilesExpectation = expectation(description: "get tiles")
        
        tilesViewModel.fetchFeeds()
        
        waitForExpectations(timeout: 10)
        XCTAssertNotNil(self.results)
        
    }
    
    func testSort(){
        
        let newTiles = tilesViewModel.sort(tiles.tiles)
        XCTAssertLessThan(newTiles[1].score, newTiles[0].score)
        
    }
    
    override func tearDown() {
        tilesViewModel = nil
        super.tearDown()
    }

    
    // Delegate of TilesViewModel
    func didFinishFetchFeeds(_ feeds: [Tile]) {
        self.results = feeds
        tilesExpectation.fulfill()
    }
}
