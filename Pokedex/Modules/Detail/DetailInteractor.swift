//
//  DetailInteractor.swift
//  Pokedex
//
//  Created by Hector Climaco on 29/08/22.
//  
//


import Foundation


protocol DetailBusinessLogic {
    func doSomething(request: Detail.Something.Request)
}

class DetailInteractor:  DetailBusinessLogic {
    
    var presenter: DetailPresentationLogic?
    
    let worker = DetailWorker()
    
    func doSomething(request: Detail.Something.Request) {
        let response = Detail.Something.Response()
        presenter?.presentSomething(response: response)
    }
    
}
