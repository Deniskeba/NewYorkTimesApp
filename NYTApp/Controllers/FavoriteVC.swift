//
//  FavoriteVC.swift
//  NYTApp
//
//  Created by Denis Kobylkov on 21.05.2023.
//

import UIKit
import SnapKit
import Alamofire
import CoreData

class FavoriteVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    private let persistentContainer = NSPersistentContainer(name: "StoredCells")
    
    lazy var fetchedResultsController: NSFetchedResultsController<StoredCells> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<StoredCells> = StoredCells.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataService.shared.context, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
   
//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.SetupUI()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")

        
            }
        }
        
    }

//MARK: UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
//MARK: Setup UI
    private func SetupUI() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    


}
//MARK: TableView Delegate
extension FavoriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",  for: indexPath) as! CustomTableViewCell
        let saved = fetchedResultsController.object(at: indexPath)
        
        cell.titleLabel.text = saved.byline
        return cell
    }
}
//MARK: TableView DataSource
extension FavoriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let quotes = fetchedResultsController.fetchedObjects else { return 0 }
            return quotes.count
    }
}




