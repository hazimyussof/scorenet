//
//  SetTests.swift
//  TennisStarterTests
//
//  Created by Hazim on 23/11/21.
//  Copyright © 2021 University of Chester. All rights reserved.
//

import XCTest

class SetTests: XCTestCase {

    var set: Set!
    var mirror: Mirror!
    
    override func setUp() {
        super.setUp()
        set = Set()
        mirror = Mirror(reflecting: set!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMaxTwoInstanceVariables(){
        XCTAssertLessThanOrEqual(mirror.children.count, 2)
    }
    
    func testZeroPoints(){
        XCTAssertEqual(set.player1Score(), "0", "P1 score correct with 0 points")
        XCTAssertEqual(set.player2Score(), "0", "P2 score correct with 0 points")
    }
    
    func testAddOnePoint() {
        
        set.addPointToPlayer1()
        XCTAssertEqual(set.player1Score(),"1","P1 score correct with 1 point")
        
        set.addPointToPlayer2()
        XCTAssertEqual(set.player2Score(),"1","P2 score correct with 1 point")
    }
    
    func testAddTwoPoints() {
        
        set.addPointToPlayer1()
        set.addPointToPlayer1()
        
        XCTAssertEqual(set.player1Score(),"2","P1 score correct with 2 points")
        
        set.addPointToPlayer2()
        set.addPointToPlayer2()
        XCTAssertEqual(set.player2Score(),"2","P2 score correct with 2 points")
    }
    
    func testAddThreePoints() {
        
        set.addPointToPlayer1()
        set.addPointToPlayer1()
        set.addPointToPlayer1()
        XCTAssertEqual(set.player1Score(),"3","P1 score correct with 3 points")
        
        set.addPointToPlayer2()
        set.addPointToPlayer2()
        set.addPointToPlayer2()
        XCTAssertEqual(set.player2Score(),"3","P2 score correct with 3 points")
    }
    
    func testSimpleWinP1(){
        for _ in 0...2{
            set.addPointToPlayer1()
        }
        XCTAssertTrue(set.player1Won(), "P1 win after 3 consecutive points")
    }
    
    func testSimpleWinP2(){
        for _ in 0...2{
            set.addPointToPlayer2()
        }
        XCTAssertTrue(set.player2Won(), "P2 win after 3 consecutive points")
    }
    
    func testMethodsNoSideEffects(){
        set.addPointToPlayer1()
        set.addPointToPlayer1()
        _ = set.player1Won()
        _ = set.player2Won()
        set.addPointToPlayer1()
        XCTAssertEqual(set.player1Score(), "3")
        _ = set.player1Won()
        XCTAssertTrue(set.player1Won())
    }
    
}
