//
//  SetPointsTests.swift
//  TennisStarterTests
//
//  Created by Hazim on 23/11/21.
//  Copyright © 2021 University of Chester. All rights reserved.
//

import XCTest

class SetPointsTests: XCTestCase {
    
    var setPoints: SetPoints!
    var mirror: Mirror!
    
    override func setUp() {
        super.setUp()
        setPoints = SetPoints()
        mirror = Mirror(reflecting: setPoints!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTieBreaker(){
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.tieBreaker(), true, "P1 and P2 both have 6 - 6 scores")
    }
    
    func testMaxTwoInstanceVariables(){
        XCTAssertLessThanOrEqual(mirror.children.count, 2)
    }
    
    func testZeroPoints(){
        XCTAssertEqual(setPoints.player1Score(), "0", "P1 score correct with 0 points")
        XCTAssertEqual(setPoints.player2Score(), "0", "P2 score correct with 0 points")
    }
    
    func testAddOnePoint() {
        
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.player1Score(),"1","P1 score correct with 1 point")
        
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.player2Score(),"1","P2 score correct with 1 point")
    }
    
    func testAddTwoPoints() {
        
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        
        XCTAssertEqual(setPoints.player1Score(),"2","P1 score correct with 2 points")
        
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.player2Score(),"2","P2 score correct with 2 points")
    }
    
    func testAddThreePoints() {
        
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.player1Score(),"3","P1 score correct with 3 points")
        
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.player2Score(),"3","P2 score correct with 3 points")
    }
    
    func testAddFourPoints() {
        
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.player1Score(),"4","P1 score correct with 4 points")
        
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.player2Score(),"4","P2 score correct with 4 points")
    }
    
    func testAddFivePoints() {
        
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.player1Score(),"5","P1 score correct with 5 points")
        
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.player2Score(),"5","P2 score correct with 5 points")
    }
    
    func testAddSixPoints() {
        
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.player1Score(),"6","P1 score correct with 6 points")
        
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.player2Score(),"6","P2 score correct with 6 points")
    }
    
    func testSimpleWinP1(){
        for _ in 0...5{
            setPoints.addPointToPlayer1()
        }
        XCTAssertTrue(setPoints.player1Won(), "P1 win after 6 consecutive points")
    }
    
    func testSimpleWinP2(){
        for _ in 0...5{
            setPoints.addPointToPlayer2()
        }
        XCTAssertTrue(setPoints.player2Won(), "P2 win after 6 consecutive points")
    }
    
    func testGameCompleteP1Win(){
        for _ in 0...5{
            setPoints.addPointToPlayer1()
        }
        XCTAssertTrue(setPoints.complete(), "Game complete with P1 win")
    }
    
    func testGameCompleteP2Win(){
        for _ in 0...5{
            setPoints.addPointToPlayer2()
        }
        XCTAssertTrue(setPoints.complete(), "Game complete with P2 win")
    }
    
    func testNoGamePointsP1() {
        
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.gamePointsForPlayer1(), 0, "P1 has no game points at 1-0")
        
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.gamePointsForPlayer1(), 0, "P1 has no game points at 2-0")
        
    }
    
    func testGamePointsP1() {
        
        for _ in 0...2{
            setPoints.addPointToPlayer1()
        }
        XCTAssertEqual(setPoints.gamePointsForPlayer1(), 3, "P1 has 3 game points at 3-0")
        
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.gamePointsForPlayer1(), 2, "P1 has 2 game points at 3-1")
        
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.gamePointsForPlayer1(), 1, "P1 has 1 game point at 3-2")
        
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.gamePointsForPlayer1(), 0, "P1 has 0 game point at 3-3")
        
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.gamePointsForPlayer1(), 1, "P1 has 1 game point at 4-3")
    }
    
    func testNoGamePointsP2() {
        
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.gamePointsForPlayer2(), 0, "P2 has no game points at 0-1")
        
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.gamePointsForPlayer2(), 0, "P1 has no game points at 0-2")
        
    }
    
    
    
    func testGamePointsP2() {
        
        for _ in 0...2{
            setPoints.addPointToPlayer2()
        }
        XCTAssertEqual(setPoints.gamePointsForPlayer2(), 3, "P2 has 3 game points at 0-3")
        
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.gamePointsForPlayer2(), 2, "P2 has 2 game points at 1-3")
        
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.gamePointsForPlayer2(), 1, "P2 has 1 game point at 2-3")
        
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.gamePointsForPlayer2(), 0, "P2 has 0 game point at 3-3")
        
        setPoints.addPointToPlayer2()
        XCTAssertEqual(setPoints.gamePointsForPlayer2(), 1, "P2 has 1 game point at 3-4")
    }
    
    func testMethodsNoSideEffects(){
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        _ = setPoints.complete()
        _ = setPoints.player1Won()
        _ = setPoints.player2Won()
        _ = setPoints.gamePointsForPlayer1()
        _ = setPoints.gamePointsForPlayer2()
        setPoints.addPointToPlayer1()
        XCTAssertEqual(setPoints.player1Score(), "3")
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        setPoints.addPointToPlayer1()
        _ = setPoints.complete()
        _ = setPoints.player1Won()
        XCTAssertTrue(setPoints.player1Won())
        XCTAssertTrue(setPoints.complete())
    }
    
}
