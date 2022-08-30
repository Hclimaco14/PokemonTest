//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by Hector Climaco on 27/08/22.
//

import XCTest
@testable import Pokedex

class PokedexTests: XCTestCase {
    
    private var expectation:XCTestExpectation!
    private let customInterval:TimeInterval =  60
    let worker = HomeWorker()
    
    override func setUpWithError() throws {
      expectation = self.expectation(description: "waitingRespons")
    }
    


    func testListPokemon() {
        let request =  Home.Request.PokemonList(startValue: 0, paginationSize: Constants.paginationSize)
        
        worker.getList(request: request) { result in
            switch result {
            case .success(let response):
                XCTAssert(true, "Test for worker succes \(response)")
                break
            case .failure(let error):
                XCTAssert(false, "Test for worker fail \(error.description)")
                break
            }
            
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: customInterval, handler: nil)
    }
    
    func testFechPokemon() {
        let request = Home.Request.Pokemon(url: "https://pokeapi.co/api/v2/pokemon/1/", name: nil)
        
        worker.fetchPokemon(request: request) { result in
            switch result {
            case .success(let response):
                XCTAssert(true, "Test for worker succes \(response)")
                break
            case .failure(let error):
                XCTAssert(false, "Test for worker fail \(error.description)")
                break
            }
            
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: customInterval, handler: nil)
    }
    
    
    func testMockListPokemon() {
        let worker = HomeWorker(serviceManager: MockServiceManager(nameFile: "ListPokemons"))
        let request =  Home.Request.PokemonList(startValue: 0, paginationSize: Constants.paginationSize)
        
        worker.getList(request: request) { result in
            switch result {
            case .success(let response):
                XCTAssert(true, "Test for worker succes \(response)")
                break
            case .failure(let error):
                XCTAssert(false, "Test for worker fail \(error.description)")
                break
            }
            
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: customInterval, handler: nil)
        
    }
    
    func testMockFechPokemon() {
        let worker = HomeWorker(serviceManager: MockServiceManager(nameFile: "Pokemon1"))
        let request = Home.Request.Pokemon(url: "", name: nil)
        worker.fetchPokemon(request: request) { result in
            switch result {
            case .success(let response):
                XCTAssert(true, "Test for worker succes \(response)")
                break
            case .failure(let error):
                XCTAssert(false, "Test for worker fail \(error.description)")
                break
            }
            
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: customInterval, handler: nil)
    }

}
