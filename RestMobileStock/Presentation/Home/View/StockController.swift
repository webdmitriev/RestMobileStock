//
//  StockController.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 16.07.2025.
//

import UIKit
import Combine

private enum DisplayMode {
    case stocks
    case favorites
}

class StockController: UIViewController, UITextFieldDelegate {
    private let uiBuilder = UIBuilder()

    private var presenter: StockPresenterProtocol!
    private var cancellables = Set<AnyCancellable>()
    private var stocks: [Stock] = []
    private var favoriteStocks: [Stock] = []
    
    private var currentMode: DisplayMode = .stocks
    private var displayedStocks: [Stock] {
        return currentMode == .stocks ? stocks : favoriteStocks
    }
    
    private var searchBarHeightConstraint: NSLayoutConstraint!
    
    private lazy var searchBar: PaddedTextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.placeholder = "Find company or ticker"
        $0.backgroundColor = .appWhite
        $0.layer.cornerRadius = 24
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.appBlack.cgColor
        $0.clipsToBounds = true
        
        $0.addTappableIcon(
            UIImage(systemName: "magnifyingglass")!,
            position: .left,
            tintColor: .appBlack,
            tapHandler: { [weak self] in
                guard let self = self else { return }
                let searchVC = SearchController()
                searchVC.modalPresentationStyle = .fullScreen
                self.present(searchVC, animated: true)
            }
        )
        return $0
    }(PaddedTextField())

    
    private lazy var btnStackView: UIStackView = {
        $0.addArrangedSubviews(showStocksButton, showFavoriteButton)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .fillEqually
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    private lazy var showStocksButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Stocks", for: .normal)
        $0.setTitleColor(.appBlack, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 28, weight: .black)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.addTarget(self, action: #selector(stocksButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var showFavoriteButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Favorite", for: .normal)
        $0.setTitleColor(.appGray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .black)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .appWhite
        $0.contentInsetAdjustmentBehavior = .never
        $0.separatorStyle = .none
        $0.separatorInset = .zero
        $0.layoutMargins = .zero
        
        $0.dataSource = self
        $0.delegate = self
        $0.register(StockCell.self, forCellReuseIdentifier: StockCell.reuseID)
        return $0
    }(UITableView(frame: .zero, style: .plain))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchStocks()
    }
    
    private func setupUI() {
        view.backgroundColor = .appWhite
        view.addSubviews(searchBar, btnStackView, tableView)
        
        searchBarHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: 48)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBarHeightConstraint,
            
            btnStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 18),
            btnStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            btnStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: btnStackView.bottomAnchor),
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
        
        presenter.stocksPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error: \(error.localizedDescription)")
                    }
                
                },
                receiveValue: { [weak self] stocks in
                    guard let self = self, self.currentMode == .stocks else { return }
                    self.stocks = stocks
                    self.favoriteStocks = self.presenter.fetchFavorites()
                    self.tableView.reloadData()
                }
            )
            .store(in: &cancellables)
    }
    
    @objc private func stocksButtonTapped() {
        updateActiveButton(showStocksButton)
        currentMode = .stocks
        presenter.fetchStocks()
    }

    @objc private func favoriteButtonTapped() {
        updateActiveButton(showFavoriteButton)
        currentMode = .favorites
        favoriteStocks = presenter.fetchFavorites()
        tableView.reloadData()
    }
    
    @objc
    private func updateActiveButton(_ activeButton: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.showStocksButton.setTitleColor(activeButton == self.showStocksButton ? .appBlack : .appGray, for: .normal)
            self.showFavoriteButton.setTitleColor(activeButton == self.showFavoriteButton ? .appBlack : .appGray, for: .normal)
            
            self.showStocksButton.titleLabel?.font = .systemFont(
                ofSize: activeButton == self.showStocksButton ? 28 : 18,
                weight: .black
            )
            self.showFavoriteButton.titleLabel?.font = .systemFont(
                ofSize: activeButton == self.showFavoriteButton ? 28 : 18,
                weight: .black
            )
            
            // анимация изменения шрифта
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let searchVC = SearchController()
        searchVC.modalPresentationStyle = .fullScreen
        self.present(searchVC, animated: true)
        return false
    }
}

extension StockController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayedStocks.isEmpty {
            tableView.setEmptyMessage("No stocks to show")
        } else {
            tableView.restore()
        }
        return displayedStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.reuseID, for: indexPath) as! StockCell
        let stock = displayedStocks[indexPath.row]
        let isFavorite = favoriteStocks.contains(where: { $0.symbol == stock.symbol })

        cell.selectionStyle = .none
        cell.configure(stock: stock, bgc: indexPath.row % 2 == 0 ? .appBgCell : .appWhite, isFavorite: isFavorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stock = displayedStocks[indexPath.row]

        switch currentMode {
        case .stocks:
            let addFavoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [weak self] _, _, completionHandler in
                guard let self = self else { return }
                
                self.presenter.addToFavorites(stock: stock)
                
                self.favoriteStocks = self.presenter.fetchFavorites()
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
                completionHandler(true)
            }
            addFavoriteAction.backgroundColor = .systemYellow
            addFavoriteAction.image = UIImage(systemName: "star.fill")
            return UISwipeActionsConfiguration(actions: [addFavoriteAction])
            
            
        case .favorites:
            let removeFavoriteAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, completionHandler in
                guard let self = self else { return }
                self.presenter.removeFromFavorites(stock: stock)
                self.favoriteStocks = self.presenter.fetchFavorites()
                self.tableView.reloadData()
                completionHandler(true)
            }
            removeFavoriteAction.image = UIImage(systemName: "star.slash")
            return UISwipeActionsConfiguration(actions: [removeFavoriteAction])
        }
    }
}

extension StockController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let shouldHide = offsetY > 100
        
        guard searchBar.isHidden != shouldHide, view.window != nil else { return }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            self.searchBarHeightConstraint.constant = shouldHide ? 0 : 48
            self.searchBar.alpha = shouldHide ? 0 : 1
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.searchBar.isHidden = shouldHide
        })
    }
}
