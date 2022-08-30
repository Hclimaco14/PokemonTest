//
//  HomePresenter.swift
//  Pokedex
//
//  Created by Hector Climaco on 27/08/22.
//  
//

import UIKit

protocol HomePresentationLogic {
    func presentListPokemons(pokemons:[Home.Pokemon])
    func presentPokemonsFilter(pokemons:[Home.Pokemon])
}

class HomePresenter: HomePresentationLogic {
    
    var view: HomeDisplayLogic?
 
    func presentListPokemons(pokemons:[Home.Pokemon]) {
        view?.displayListPokemons(pokemons: pokemons)
    }
    
    func presentPokemonsFilter(pokemons:[Home.Pokemon]) {
        view?.displayPokemonsFilter(pokemons: pokemons)
    }
    
}
