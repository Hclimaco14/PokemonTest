//
//  HomeRouter.swift
//  Pokedex
//
//  Created by Hector Climaco on 27/08/22.
//  
//


import UIKit

protocol HomeRoutingLogic {
    func routeToDetail(pokemon: Home.Pokemon)
}

class HomeRouter: HomeRoutingLogic {
    
    var view: HomeViewController?
    
    func routeToDetail(pokemon: Home.Pokemon) {
        let vc = DetailViewController()
        vc.pokemon = pokemon
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
