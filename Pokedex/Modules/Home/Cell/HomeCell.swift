//
//  HomeCell.swift
//  Pokedex
//
//  Created by Hector Climaco on 29/08/22.
//

import UIKit

class HomeCell: UITableViewCell {
    
    static let identifier:String = "HomeCell"
    
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    
    
    var pokemon: Home.Pokemon! {
        didSet {
            configureView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        self.pokemonImg.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureView() {
        self.selectionStyle = .none
        
        if let pokeImgURL = self.pokemon.sprites?.other?.officialArtwork?.frontDefault {
            self.pokemonImg.loadImageUsingCache(withUrl: pokeImgURL)
        }
        
        nameLbl.text = pokemon.name
        
        if pokemon.types.count > 1{
            typeLbl.text = pokemon.types[1]?.type?.name
        } else {
            typeLbl.isHidden = true
        }
        
        idLbl.text = "#\(pokemon.id )"
    }
}
