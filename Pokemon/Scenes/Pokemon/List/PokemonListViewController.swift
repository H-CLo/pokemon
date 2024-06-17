//
//  PokemonListViewController.swift
//  Pokemon
//
//  Created by Lo on 2024/6/15.
//

import Combine
import SnapKit
import UIKit

class PokemonListViewController: BaseViewController<PokemonListViewModel> {
    // MARK: - Property

    var subscriptions = Set<AnyCancellable>()

    // MARK: - UI

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.setCollectionViewLayout(gridLayout, animated: true)
        collectionView.register(PokemonGridCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PokemonGridCollectionViewCell.self))
        collectionView.register(PokemonListCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PokemonListCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    let gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let halfSceenWidth = UIScreen.main.bounds.width / 2
        layout.itemSize = CGSize(width: halfSceenWidth, height: halfSceenWidth)
        layout.scrollDirection = .vertical
        return layout
    }()

    let listLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 90)
        layout.scrollDirection = .vertical
        return layout
    }()

    deinit {
        subscriptions.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("PokemonList")
        setRightNavigationBarItems([.showFavorites, .changeLayout])
        setupUI()
        bindViewModel()
        viewModel.fetchPokemonList()
    }

    override func navigationItemDidPressed(_ type: BaseViewController<PokemonListViewModel>.NavigationItemType) {
        debugPrint("Item type didPressed = \(type)")

        switch type {
        case .showFavorites:
            break
        case .changeLayout:
            viewModel.exchangeGridListLayout()
        }
    }
}

// MARK: - UI

private extension PokemonListViewController {
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - ViewModel

private extension PokemonListViewController {
    func bindViewModel() {
        viewModel.layoutTypeBlock.sink { [weak self] type in
            self?.startInteractiveTransition(type)
        }.store(in: &subscriptions)

        viewModel.pokemonsBlock.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &subscriptions)

        viewModel.pokemonDetailBlock.sink { [weak self] id, detail in
            guard let self = self else { return }
            guard let index = viewModel.getPokemonIndex(byID: id) else { return }
            let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0))
            (cell as? PokemonBaseCollectionViewCell)?.configCell(detail: detail)
        }.store(in: &subscriptions)
    }

    func startInteractiveTransition(_ type: PokemonListLayoutType) {
        switch type {
        case .grid:
            collectionView.startInteractiveTransition(to: listLayout)
            collectionView.finishInteractiveTransition()
            collectionView.reloadData()
        case .list:
            collectionView.startInteractiveTransition(to: gridLayout)
            collectionView.finishInteractiveTransition()
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PokemonListViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.pokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemon = viewModel.getSequencePokemon(indexPath.row)
        let detail = viewModel.getSequencePokemonDetail(indexPath.row)
        let cell = getCell(collectionView: collectionView, indexPath: indexPath)
        if let pokemon = pokemon {
            cell.configCell(item: pokemon)
        }
        if let detail = detail {
            cell.configCell(detail: detail)
        }
        return cell
    }

    private func getCell(collectionView: UICollectionView, indexPath: IndexPath) -> PokemonBaseCollectionViewCell {
        switch viewModel.layoutType {
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PokemonGridCollectionViewCell.self), for: indexPath) as? PokemonGridCollectionViewCell else { return PokemonBaseCollectionViewCell() }
            return cell
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PokemonListCollectionViewCell.self), for: indexPath) as? PokemonListCollectionViewCell else { return PokemonBaseCollectionViewCell() }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PokemonListViewController: UICollectionViewDelegate {
    // Using willDisplay to detect load more mechanism
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard viewModel.canLoadMore(index: indexPath.row) else { return }
        viewModel.fetchMorePokemonList()
    }
}
