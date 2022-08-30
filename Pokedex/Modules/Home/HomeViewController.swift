//
//  HomeViewController.swift
//  Pokedex
//
//  Created by Hector Climaco on 27/08/22.
//  
//

import UIKit

protocol HomeDisplayLogic {
    func displayListPokemons(pokemons: [Home.Pokemon])
    func displayPokemonsFilter(pokemons: [Home.Pokemon])
}

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let search = UISearchController(searchResultsController: nil)
    
    // MARK: - Variables
    
    var pokemonList:[Home.Pokemon] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var pokemonFilter:[Home.Pokemon] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    var interactor: HomeBusinessLogic?
    var router: HomeRoutingLogic?
    var isFiltered:Bool = false
    
    // MARK: - Object Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pokedex"
        configTable()
        configSearch()
        interactor?.getList(startIndex: 0)
    }
    
    // MARK: - Configurators
    
    
    fileprivate func setup() {
        
        let viewcontroller   = self
        let interactor      = HomeInteractor()
        let presenter       = HomePresenter()
        let router          = HomeRouter()
        
        viewcontroller.interactor = interactor
        viewcontroller.router     = router
        interactor.presenter      = presenter
        presenter.view            = viewcontroller
        router.view               = viewcontroller
    }
    
    fileprivate func configTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        self.tableView.register(UINib(nibName: HomeCell.identifier, bundle: nil), forCellReuseIdentifier: HomeCell.identifier)
    }
    
    fileprivate func configSearch(){
        self.search.delegate = self
        self.search.searchBar.delegate = self
        self.search.searchBar.placeholder = "Find by Name or Id"
        self.navigationItem.searchController = search
    }
    // MARK: - Private
    
    
    // MARK: - Actions
    
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate,UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isFiltered {
            return self.pokemonFilter.count
        } else {
            return self.pokemonList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.identifier, for: indexPath) as? HomeCell else {
            return UITableViewCell()
        }
       
        if self.isFiltered {
            cell.pokemon = self.pokemonFilter[indexPath.row]
        } else {
            cell.pokemon = self.pokemonList[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var pokemon = Home.Pokemon()
        if self.isFiltered {
            pokemon = self.pokemonFilter[indexPath.row]
        } else {
            pokemon = self.pokemonList[indexPath.row]
        }
        
        self.router?.routeToDetail(pokemon: pokemon)
        
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths[0].row >= self.pokemonList.count - 5,!isFiltered {
            interactor?.getList(startIndex: indexPaths[0].row)
        }
    }
}

extension HomeViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.tableView.reloadData()
            isFiltered = false
            return
        }
        
        isFiltered = true
        interactor?.findPokemon(value: searchText)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltered = false
        self.tableView.reloadData()
    }
}

extension HomeViewController: HomeDisplayLogic {
    func displayPokemonsFilter(pokemons: [Home.Pokemon]) {
        self.pokemonFilter = pokemons
    }
    
    func displayListPokemons(pokemons: [Home.Pokemon]) {
        self.pokemonList = pokemons
    }
}
