//
//  BaseViewController.swift
//  Pokemon
//
//  Created by Lo on 2024/6/16.
//

import UIKit

class BaseViewController<ViewModel: BaseViewModel>: UIViewController {
    let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    func navigationItemDidPressed(_: NavigationItemType) {}
}

// MARK: - UINavigation

extension BaseViewController {
    private func setupNavigation() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .systemBackground
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    func setNavigationTitle(_ title: String) {
        self.title = title
    }
}

// MARK: - NavigationBarItem

extension BaseViewController {
    enum NavigationItemType {
        case showFavorites, changeLayout

        var systemItem: UIBarButtonItem.SystemItem {
            switch self {
            case .showFavorites:
                return .bookmarks
            case .changeLayout:
                return .refresh
            }
        }
    }

    func setRightNavigationBarItems(_ types: [NavigationItemType]) {
        let items: [UIBarButtonItem] = types.map { type in
            let item = UIBarButtonItem(systemItem: type.systemItem,
                                       primaryAction: UIAction { [weak self] _ in
                                           self?.navigationItemDidPressed(type)
                                       })
            return item
        }
        navigationItem.rightBarButtonItems = items
    }
}
