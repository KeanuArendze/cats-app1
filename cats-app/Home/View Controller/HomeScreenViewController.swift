//
//  HomeScreenViewController.swift
//  CatInaApp
//
//  Created by Keanu on 2020/02/17.
//  Copyright © 2020 Keanu. All rights reserved.
//

import UIKit
import CoreData
import Reachability

class HomeScreenViewController : UIViewController, UITableViewDataSource {
    
    private lazy var viewModel = HomeViewModel(with: CatFactsService(),
                                               delegate: self)
    
    @IBOutlet private var catFactsTableView: UITableView!
    let cellReuseIdentifier = "catFactCell"
    let progressIndicator = LoadingIndicatorViewController()
    var factsArray = [CatFacts]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.catFactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        catFactsTableView.delegate = self
        catFactsTableView.dataSource = self
        showLoadingIndicator()
        
        do {
            let reachability = try Reachability()
            let reachableConnection = reachability.connection
            
            if (reachableConnection == .cellular || reachableConnection == .wifi) {
                self.removeCatFacts()
                self.viewModel.fecthCatFacts()
            } else {
                self.fetchCatFacts()
            }
            
        } catch {
            print("Unable to get connectivity status")
        }
    }
    
    private func showLoadingIndicator() {
        addChild(progressIndicator)
        progressIndicator.view.frame = view.frame
        view.addSubview(progressIndicator.view)
        progressIndicator.didMove(toParent: self)
    }
    
    private func hideLoadingIndicator() {
        self.self.progressIndicator.willMove(toParent: nil)
        self.progressIndicator.view.removeFromSuperview()
        self.progressIndicator.removeFromParent()
    }
    
    private func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving data \(error)")
        }
    }
    
    private func fetchCatFacts() {
        let request: NSFetchRequest<CatFacts> = CatFacts.fetchRequest()
        do {
            factsArray = try context.fetch(request)
            
            if(factsArray.count == 0) {
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.catFactsTableView.bounds.size.width, height: self.catFactsTableView.bounds.size.height))
                noDataLabel.text = "No Data Available"
                noDataLabel.textColor = .red
                noDataLabel.textAlignment = NSTextAlignment.center
                self.catFactsTableView.backgroundView = noDataLabel
            }
            
            hideLoadingIndicator()
        } catch {
            print("Error fetching data from context")
        }
    }
    
    private func removeCatFacts() {
        for (index, _) in factsArray.enumerated() {
            context.delete(factsArray[index])
        }
        self.saveData()
    }
}

extension HomeScreenViewController : CatDelegate {
    func updateTableWithData() {
        DispatchQueue.main.async {
            for item in self.viewModel.catFacts {
                let newItem = CatFacts(context: self.context)
                newItem.fact = item.catFact
                self.factsArray.append(newItem)
            }
            self.saveData()
            
            self.catFactsTableView.reloadData()
            self.hideLoadingIndicator()
        }
    }
}

extension HomeScreenViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.factsArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.catFactsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell? ?? UITableViewCell()
        
        let response = self.factsArray[indexPath.row]
        
        cell.textLabel?.text = response.fact
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

class LoadingIndicatorViewController: UIViewController {
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

