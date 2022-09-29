//
//  ViewController.swift
//  Pokedex
//
//  Created by Riandro Proença on 22/09/22.
//

import UIKit
enum CustomError: Error {
    case invalidURL
    case requestError
    case dataEmpty
    case decodedError
}

class ViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pokemonId: UILabel!
    @IBOutlet weak var buttonStepper: UIStepper!
    var id = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonStepper.value = 1
        buttonStepper.minimumValue = 1
        buttonStepper.maximumValue = 151
        makeRequest { result in
            switch result {
            case .success(let pokemon):
                self.handleSuccess(pokemon: pokemon)
            case .failure(_):
                print("Error")
                //TODO: Show alert
            }
        }
        id = Int(buttonStepper.value)
        pokemonId.text = "Pokemon ID: \(id)"

    }
    @IBAction func stepperPlus(_ sender: UIStepper) {
        id = Int(sender.value)
        pokemonId.text = "Pokemon ID: \(id)"
        makeRequest { result in
            switch result {
            case .success(let pokemon):
                self.handleSuccess(pokemon: pokemon)
            case .failure(_):
                print("Error")
                //TODO: Show alert
            }
        }
    }

    private func makeRequest(completion: @escaping (Result<Pokemon, CustomError>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/") else {
            completion(.failure(.invalidURL))
            return
        }

        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.requestError))
                    return
                }

                guard let data = data else {
                    completion(.failure(.dataEmpty))
                    return
                }

                if let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data) {
                    completion(.success(pokemon))
                } else {
                    completion(.failure(.decodedError))
                }
            }

        }.resume()
    }

    private func makeRequestImage(url: String) {
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if error != nil { return }

            guard let data = data else { return }

            let uiImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.image.image = uiImage
            }
        }.resume()
    }

    private func handleSuccess(pokemon: Pokemon) {
        name.text = pokemon.name.uppercased()
        makeRequestImage(url: pokemon.sprites.other.official.urlImage)
    }
}

