//
//  PokemonDetailViewController.swift
//  Pokemon
//
//  Created by Lo on 2024/6/18.
//

import Combine
import UIKit

protocol PokemonDetailViewProtocol: AnyObject {
    func pushToDetailView(id: String)
}

class PokemonDetailViewController: BaseViewController<PokemonDetailViewModel> {
    // MARK: - Property

    var subscriptions = Set<AnyCancellable>()
    weak var delegate: PokemonDetailViewProtocol?

    // MARK: - UI

    let scrollView = UIScrollView()
    let idLabel = UILabel()
    let nameLabel = UILabel()
    let typesLabel = UILabel()
    let thumbnailImageView = UIImageView()
    let evolutionLabel: UILabel = {
        let label = UILabel()
        label.text = "Evolution"
        return label
    }()

    let evolutionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    let favoriteButton = FavoriteButton()

    deinit {
        subscriptions.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.start()
    }
}

// MARK: - ViewModel

extension PokemonDetailViewController {
    func bindViewModel() {
        viewModel.pokemonDetailBlock.sink { [weak self] model in
            self?.idLabel.text = "ID: \(model.id)"
            self?.nameLabel.text = "Name: \(model.name)"
            self?.typesLabel.text = "Types: \(model.types.map { $0.type.name }.joined(separator: ", "))"
            self?.thumbnailImageView.sd_setImage(with: URL(string: model.sprites.front_default))
            self?.setupFavoriteItem(model: model)
        }.store(in: &subscriptions)

        viewModel.flavorTextBlock.sink { [weak self] text in
            self?.descriptionLabel.text = "Description: \(text)"
        }.store(in: &subscriptions)

        viewModel.evolutionBlock.sink { [weak self] species in
            self?.setupEvolutionViews(species: species)
        }.store(in: &subscriptions)
    }

    func setupEvolutionViews(species: [PokemonEvolutionChain.Species]) {
        species.forEach {
            let view = PokemonDetailEvolutionView()
            evolutionStackView.addArrangedSubview(view)
            view.setSpecies($0)
            view.detailViewDidPressed = { [weak self] id in
                self?.delegate?.pushToDetailView(id: id)
            }
        }
    }

    func setupFavoriteItem(model: PokemonDetail) {
        let target = Target.pokemonDetail(id: model.id.description)
        let pokemon = Pokemon(name: model.name, url: target.baseURL+target.path+"/")
        favoriteButton.setFavoriteItem(pokemon: pokemon)
    }
}

extension PokemonDetailViewController {
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(idLabel)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(typesLabel)
        scrollView.addSubview(thumbnailImageView)
        scrollView.addSubview(evolutionLabel)
        scrollView.addSubview(evolutionStackView)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(favoriteButton)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        idLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }

        typesLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(typesLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(90)
        }

        evolutionLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }

        evolutionStackView.snp.makeConstraints {
            $0.top.equalTo(evolutionLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(180)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(evolutionStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
        }

        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(45)
        }
    }
}
