//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Hector Climaco on 29/08/22.
//  
//

import UIKit

protocol DetailDisplayLogic {
    func displaySomething(viewModel: Detail.Something.ViewModel)
}

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonXPLbl: UILabel!
    @IBOutlet weak var pokemonHPLbl: UILabel!
    @IBOutlet weak var pokemonTypeLbl: UILabel!
    @IBOutlet weak var pokemonTypeDescriptionLbl: UILabel!
    @IBOutlet weak var pokemonHeightLbl: UILabel!
    @IBOutlet weak var pokemonWeightLbl: UILabel!
    @IBOutlet weak var pokemonRandomMoveValueLbl: UILabel!
    @IBOutlet weak var pokemonAbilitiesValueLbl: UILabel!
    
    @IBOutlet weak var pokemonAttackValueLbl: UILabel!
    @IBOutlet weak var pokemonDefenseValueLbl: UILabel!
    @IBOutlet weak var pokemonSpecialAttackValueLbl: UILabel!
    @IBOutlet weak var pokemonSpecialDefenseValueLbl: UILabel!
    @IBOutlet weak var pokemonSpeedValueLbl: UILabel!
    
    // MARK: - Variables
    var pokemon: Home.Pokemon?
    
    var interactor: DetailBusinessLogic?
    var router: DetailRoutingLogic?
    
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
        loadData()
    }
    
    // MARK: - Configurators
    
    fileprivate func setup() {
        
        let viewcontroller   = self
        let interactor      = DetailInteractor()
        let presenter       = DetailPresenter()
        let router          = DetailRouter()
        
        viewcontroller.interactor = interactor
        viewcontroller.router     = router
        interactor.presenter      = presenter
        presenter.view            = viewcontroller
        router.view               = viewcontroller
    }
    
    // MARK: - Private
    
    
    // MARK: - Actions
    func loadData(){
        if let safePokemon = pokemon{
            if let pokeName = safePokemon.name?.capitalizingFirstLetter(){
                self.title = pokeName
            }
            
            if let pokeImgURL = safePokemon.sprites?.other?.officialArtwork?.frontDefault{
                self.pokemonImg.loadImageUsingCache(withUrl: pokeImgURL)
            } else if let defaultURL = safePokemon.sprites?.frontDefault{
                self.pokemonImg.loadImageUsingCache(withUrl: defaultURL)
            }
            //        stats
            if let pokeHp = safePokemon.stats?.filter({ $0.stat?.name == "hp" }) {
                pokemonHPLbl.text = "\(pokeHp[0].baseStat ?? 0) HP"
            }
            if let pokeAttack = safePokemon.stats?.filter({ $0.stat?.name == "attack" }) {
                pokemonAttackValueLbl.text = pokeAttack[0].baseStat?.description
            }
            if let pokeDefense = safePokemon.stats?.filter({ $0.stat?.name == "defense" }) {
                pokemonDefenseValueLbl.text = pokeDefense[0].baseStat?.description
            }
            if let pokeSpecAttack = safePokemon.stats?.filter({$0.stat?.name == "special-attack"}) {
                pokemonSpecialAttackValueLbl.text = pokeSpecAttack[0].baseStat?.description
            }
            if let pokeSpecDefense = safePokemon.stats?.filter({$0.stat?.name == "special-defense"}) {
                pokemonSpecialDefenseValueLbl.text = pokeSpecDefense[0].baseStat?.description
            }
            if let pokeSpecDefense = safePokemon.stats?.filter({$0.stat?.name == "speed"}) {
                pokemonSpeedValueLbl.text = pokeSpecDefense[0].baseStat?.description
            }
            pokemonXPLbl.text = "\(safePokemon.baseExperience ?? 0) XP"
            //type
            pokemonTypeLbl.text = safePokemon.types[0]?.type?.name?.capitalizingFirstLetter()
            if safePokemon.types.count > 1{
                pokemonTypeDescriptionLbl.text = safePokemon.types[1]?.type?.name?.capitalizingFirstLetter()
            } else {
                pokemonTypeDescriptionLbl.isHidden = true
            }
            //size
            pokemonHeightLbl.text = "\(String(safePokemon.height!)), m"
            pokemonWeightLbl.text = "\(String(safePokemon.weight!)), kg"
            //Abilities
            pokemonAbilitiesValueLbl.text = safePokemon.abilities[0]?.ability?.name?.capitalizingFirstLetter()
            //Random Move
            if let randomMove = safePokemon.moves?.randomElement(){
                pokemonRandomMoveValueLbl.text = randomMove.move?.name?.capitalizingFirstLetter()
            }

        }
    }
    
}

extension DetailViewController: DetailDisplayLogic {
    func displaySomething(viewModel: Detail.Something.ViewModel) {}
}
