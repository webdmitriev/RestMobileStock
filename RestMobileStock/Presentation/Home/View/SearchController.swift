//
//  SearchController.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 17.07.2025.
//

import UIKit
import Combine

class SearchController: UIViewController, UITextFieldDelegate {
    
    private var presenter: StockPresenterProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    private var searchResults: [Stock] = []
    
    private lazy var searchBar: PaddedTextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.placeholder = "Find company or ticker"
        $0.backgroundColor = .appWhite
        $0.layer.cornerRadius = 24
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.appBlack.cgColor
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        $0.addTappableIcon(
            UIImage(systemName: "chevron.left")!,
            position: .left,
            tintColor: .appBlack,
            tapHandler: { [weak self] in
                self?.handleBack()
            }
        )
        return $0
    }(PaddedTextField())


    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(StockCell.self, forCellReuseIdentifier: StockCell.reuseID)
        $0.separatorStyle = .none
        return $0
    }(UITableView())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appWhite
        setupUI()
        setupPresenter()
    }

    private func setupUI() {
        view.addSubviews(searchBar, tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupPresenter() {
        let dataSource = RemoteStockDataSourceImpl(session: .shared)
        let favoriteRepository = CoreDataFavoriteStockRepository()
        let addFavoriteUseCase = AddFavoriteStockUseCaseImpl(repository: favoriteRepository)
        
        presenter = StockPresenter(
            dataSource: dataSource,
            favoriteRepository: favoriteRepository,
            addFavoriteUseCase: addFavoriteUseCase
        )
    }

    @objc private func textFieldDidChange() {
        guard let query = searchBar.text?.lowercased(), !query.isEmpty else {
            searchResults = []
            tableView.reloadData()
            return
        }

        presenter.stocksPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] stocks in
                self?.searchResults = stocks.filter {
                    $0.symbol.lowercased().contains(query) || $0.name.lowercased().contains(query)
                }
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
        
        presenter.fetchStocks()
    }
    
    @objc
    private func handleBack() {
        view.endEditing(true)
        dismiss(animated: true)
    }
}

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.reuseID, for: indexPath) as! StockCell
        let stock = searchResults[indexPath.row]
        let isFavorite = presenter.fetchFavorites().contains(where: { $0.symbol == stock.symbol })
        cell.configure(stock: stock, bgc: .appWhite, isFavorite: isFavorite)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let stock = searchResults[indexPath.row]
    }
}

extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
}
