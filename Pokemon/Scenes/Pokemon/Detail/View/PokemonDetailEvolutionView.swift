//
//  PokemonDetailEvolutionView.swift
//  Pokemon
//
//  Created by Lo on 2024/6/18.
//

import UIKit

class PokemonDetailEvolutionView: UIView {
    // MARK: - Property

    var detail: PokemonDetail?
    var detailViewDidPressed: ((_ id: String) -> Void)?

    // MARK: - UI

    let idLabel = UILabel()
    let nameLabel = UILabel()
    let typesLabel = UILabel()
    let thumbnailImageView = UIImageView()

    init() {
        super.init(frame: .zero)
        setupUI()
        isUserInteractionEnabled = true
        setTapGesture()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSpecies(_ species: PokemonEvolutionChain.Species) {
        let lastComponent = URL(string: species.url)?.lastPathComponent ?? ""
        start(id: lastComponent)
    }

    /// Start setup view with species url string
    /// - Parameter urlStr: species url string
    private func start(id: String) {
        fetchPokemonDetail(id: id) { [weak self] model in
            guard let self = self, let model = model else { return }
            self.detail = model
            self.idLabel.text = "ID: \(model.id)"
            self.nameLabel.text = "Name: \(model.name)"
            self.typesLabel.text = "Types: \(model.types.map { $0.type.name }.joined(separator: ", "))"
            self.thumbnailImageView.sd_setImage(with: URL(string: model.sprites.front_default))
        }
    }

    private func getURLStringLastComponent(urlStr: String) -> String {
        return URL(string: urlStr)?.lastPathComponent ?? ""
    }

    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewPressed))
        addGestureRecognizer(tapGesture)
    }

    @objc
    private func viewPressed() {
        detailViewDidPressed?(detail?.id.description ?? "")
    }
}

extension PokemonDetailEvolutionView {
    func setupUI() {
        addSubview(idLabel)
        addSubview(nameLabel)
        addSubview(typesLabel)
        addSubview(thumbnailImageView)
        idLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }

        typesLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(typesLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(90)
        }
    }
}

extension PokemonDetailEvolutionView {
    func fetchPokemonDetail(id: String, completion: @escaping (PokemonDetail?) -> Void) {
        NetworkManager().requestDetail(id: id) { result in
            switch result {
            case let .success(model):
                completion(model)
            case .failure:
                completion(nil)
            }
        }
    }
}
