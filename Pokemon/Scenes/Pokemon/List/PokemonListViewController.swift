//
//  PokemonListViewController.swift
//  Pokemon
//
//  Created by Lo on 2024/6/15.
//

import Combine
import SnapKit
import UIKit

protocol PokemonListViewControllerProtocol: AnyObject {
    func pushToDetailView(id: String)
}

class PokemonListViewController: BaseViewController<PokemonListViewModel> {
    // MARK: - Property

    var subscriptions = Set<AnyCancellable>()
    weak var delegate: PokemonListViewControllerProtocol?

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
        let halfSceenWidth = UIScreen.main.bounds.width / 2 - 10
        layout.itemSize = CGSize(width: halfSceenWidth, height: halfSceenWidth)
        layout.scrollDirection = .vertical
        return layout
    }()

    let listLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
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
            viewModel.showFavoritesPressed()
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

        viewModel.showFavoriteBlock.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &subscriptions)

        viewModel.favoriteChanged.sink { [weak self] indexPath in
            self?.collectionView.reloadItems(at: [indexPath])
        }.store(in: &subscriptions)
    }

    func startInteractiveTransition(_ type: PokemonListLayoutType) {
        let layout = (type == .grid) ? gridLayout : listLayout
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension PokemonListViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.getSequenceCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemon = viewModel.getSequencePokemon(indexPath.row)
        let detail = viewModel.getSequencePokemonDetail(indexPath.row)
        let cell = getCell(collectionView: collectionView, indexPath: indexPath)
        if let pokemon = pokemon {
            let hasFavorite = viewModel.hasFavorite(id: pokemon.id)
            cell.configCell(item: pokemon)
            cell.configCell(id: pokemon.id, isFavorite: hasFavorite)
        }
        if let detail = detail {
            cell.configCell(detail: detail)
        }
        cell.delegate = self
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
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard viewModel.canLoadMore(index: indexPath.row) else { return }
        viewModel.fetchMorePokemonList()
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = viewModel.getSequencePokemon(indexPath.row)
        delegate?.pushToDetailView(id: pokemon?.id ?? "")
    }
}

// MARK: - PokemonBaseCollectionViewCellDelegate

extension PokemonListViewController: PokemonBaseCollectionViewCellDelegate {
    func favoriteTapped(id: String) {
        viewModel.favoriteTapped(id: id)
    }
}
