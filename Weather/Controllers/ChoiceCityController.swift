//
//  ChoiceCityController.swift
//  Weather
//
//  Created by Саша Тихонов on 25/12/2023.
//

import UIKit
import SnapKit

class ChoiceCityController: UIViewController {
    
    var cities: [String] = []

    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var didSelectCityClosure: ((String) -> Void)?
    
    let searchBarCities: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.tintColor = .black
        return searchBar
    }()

    var didSelectSearchedCityClosure: ((String) -> Void)?
    
    var isSearching: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .black
        tableView.register(CityCellTableViewCell.self, forCellReuseIdentifier: "CityCellTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
       
        searchBarCities.placeholder = "Search Cities"
        searchBarCities.delegate = self
        searchBarCities.becomeFirstResponder()
  
        setupTableView()
    }
}

extension ChoiceCityController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCellTableViewCell", for: indexPath) as? CityCellTableViewCell else {
            fatalError()
        }

        let suggestion = cities[indexPath.row]
        cell.configure(withCity: suggestion)

        return cell
    }
}

extension ChoiceCityController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = "Choose your city"
        label.textColor = .lightGray
        label.font = Fonts.helveticaFont(with: 20)
        
        tableView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom).offset(-3)
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        if isSearching {
            didSelectSearchedCityClosure?(selectedCity)
            
            CoreDataManager.shared.lastChoicedCity(lastChoicedCity: selectedCity)
        } else {
            didSelectCityClosure?(selectedCity)
            
            CoreDataManager.shared.lastChoicedCity(lastChoicedCity: selectedCity)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ChoiceCityController {
    func setupTableView() {
        view.addSubview(searchBarCities)
        view.addSubview(tableView)
        
        searchBarCities.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
      
        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(searchBarCities.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        tableView.reloadData()
    }}

extension ChoiceCityController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (searchBar.text ?? "") + string
        filterContentForSearchText(searchText)
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        let suggestions = CoreDataManager.shared.fetchCitiesWithName(with: searchText)
        
        cities.removeAll()
        cities.append(contentsOf: suggestions.map { $0.name ?? "" })
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        if let searchText = searchBar.text, !searchText.isEmpty {
            if CoreDataManager.shared.cityExists(withName: searchText) {
                didSelectSearchedCityClosure?(searchText)
                CoreDataManager.shared.lastChoicedCity(lastChoicedCity: searchText)
            } else {
                showAlert(message: "Город не найден")
            }
        } else {
            showAlert(message: "Введите город")
        }
        
        searchBar.resignFirstResponder()
    }
    
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


