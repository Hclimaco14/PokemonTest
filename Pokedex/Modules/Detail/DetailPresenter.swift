//
//  DetailPresenter.swift
//  Pokedex
//
//  Created by Hector Climaco on 29/08/22.
//  
//

import UIKit

protocol DetailPresentationLogic {
    func presentSomething(response: Detail.Something.Response)
}

class DetailPresenter: DetailPresentationLogic {
    
    var view: DetailDisplayLogic?
    
    func presentSomething(response: Detail.Something.Response) {
        let viewModel = Detail.Something.ViewModel()
        view?.displaySomething(viewModel: viewModel)
    }
}
