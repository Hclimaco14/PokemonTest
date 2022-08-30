//
//  DetailRouter.swift
//  Pokedex
//
//  Created by Hector Climaco on 29/08/22.
//  
//


import UIKit

protocol DetailRoutingLogic {
    func routeToSomewhere()
}

class DetailRouter: DetailRoutingLogic {
    
    var view: DetailViewController?
    
    func routeToSomewhere() {
        
    }
    
}
