//
//  TieBreakerTests.swift
//  TennisStarterTests
//
//  Created by Hazim on 23/11/21.
//  Copyright © 2021 University of Chester. All rights reserved.
//

import XCTest

class TieBreakerTests: XCTestCase {

    var tieBreaker: TieBreaker!
    var mirror: Mirror!
    
    override func setUp() {
        super.setUp()
        tieBreaker = TieBreaker()
        mirror = Mirror(reflecting: tieBreaker!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMaxTwoInstanceVariables(){
        XCTAssertLessThanOrEqual(mirror.children.count, 2)
    }
    
    func testZeroPoints(){
        XCTAssertEqual(tieBreaker.player1Score(), "0", "P1 score correct with 0 points")
        XCTAssertEqual(tieBreaker.player2Score(), "0", "P2 score correct with 0 points")
    }
    
    func testAddOnePoint() {
        
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.player1Score(),"1","P1 score correct with 1 point")
        
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.player2Score(),"1","P2 score correct with 1 point")
    }
    
    func testAddTwoPoints() {
        
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        
        XCTAssertEqual(tieBreaker.player1Score(),"2","P1 score correct with 2 points")
        
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.player2Score(),"2","P2 score correct with 2 points")
    }
    
    func testAddThreePoints() {
        
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.player1Score(),"3","P1 score correct with 3 points")
        
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.player2Score(),"3","P2 score correct with 3 points")
    }
    
    func testAddFourPoints() {
        
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.player1Score(),"4","P1 score correct with 4 points")
        
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.player2Score(),"4","P2 score correct with 4 points")
    }
    
    func testAddFivePoints() {
        
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.player1Score(),"5","P1 score correct with 5 points")
        
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.player2Score(),"5","P2 score correct with 5 points")
    }
    
    func testAddSixPoints() {
        
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.player1Score(),"6","P1 score correct with 6 points")
        
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.player2Score(),"6","P2 score correct with 6 points")
    }
    
    func testAddSevenPoints() {
        
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.player1Score(),"7","P1 score correct with 7 points")
        
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.player2Score(),"7","P2 score correct with 7 points")
    }
    
    func testHighNumberPoints() {
        for _ in 0...4999 {
            tieBreaker.addPointToPlayer1()
        }
        XCTAssertEqual(tieBreaker.player1Score(), "5000", "P2 has 5000 Tie-Break points")
        for _ in 0...6999 {
            tieBreaker.addPointToPlayer2()
        }
        XCTAssertEqual(tieBreaker.player2Score(), "7000", "P2 has 7000 Tie-Break points")
    }
    
    func testSimpleWinP1(){
        for _ in 0...6{
            tieBreaker.addPointToPlayer1()
        }
        XCTAssertTrue(tieBreaker.player1Won(), "P1 win after 7 consecutive points")
    }
    
    func testSimpleWinP2(){
        for _ in 0...6{
            tieBreaker.addPointToPlayer2()
        }
        XCTAssertTrue(tieBreaker.player2Won(), "P2 win after 7 consecutive points")
    }
    
    func testNoGamePointsP1() {
        
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer1(), 0, "P1 has no game points at 1-0")
        
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer1(), 0, "P1 has no game points at 2-0")
        
    }
    
    func testGamePointsP1() {
        
        for _ in 0...2{
            tieBreaker.addPointToPlayer1()
        }
        XCTAssertEqual(tieBreaker.gamePointsForPlayer1(), 3, "P1 has 3 game points at 3-0")
        
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer1(), 2, "P1 has 2 game points at 3-1")
        
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer1(), 1, "P1 has 1 game point at 3-2")
        
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer1(), 0, "P1 has 0 game point at 3-3")
        
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer1(), 1, "P1 has 1 game point at 4-3")
    }
    
    func testNoGamePointsP2() {
        
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer2(), 0, "P2 has no game points at 0-1")
        
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer2(), 0, "P1 has no game points at 0-2")
        
    }
    
    func testGamePointsP2() {
        
        for _ in 0...2{
            tieBreaker.addPointToPlayer2()
        }
        XCTAssertEqual(tieBreaker.gamePointsForPlayer2(), 3, "P2 has 3 game points at 0-3")
        
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer2(), 2, "P2 has 2 game points at 1-3")
        
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer2(), 1, "P2 has 1 game point at 2-3")
        
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer2(), 0, "P2 has 0 game point at 3-3")
        
        tieBreaker.addPointToPlayer2()
        XCTAssertEqual(tieBreaker.gamePointsForPlayer2(), 1, "P2 has 1 game point at 3-4")
    }
    
    func testMethodsNoSideEffects(){
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        _ = tieBreaker.player1Won()
        _ = tieBreaker.player2Won()
        _ = tieBreaker.gamePointsForPlayer1()
        _ = tieBreaker.gamePointsForPlayer2()
        tieBreaker.addPointToPlayer1()
        XCTAssertEqual(tieBreaker.player1Score(), "3")
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        tieBreaker.addPointToPlayer1()
        _ = tieBreaker.player1Won()
        XCTAssertTrue(tieBreaker.player1Won())
    }

}
