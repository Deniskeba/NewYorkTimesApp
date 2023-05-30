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
    var result:[StoredCells] = []
    
    //MARK: request to core data
    
    var context = CoreDataService.shared.context
    func fetch() {
        let request = NSFetchRequest<StoredCells>(entityName: "StoredCells")
        
        do{
          result =  try context.fetch(request)
        }
        catch{
            print(error)
        }
    }
   
   
//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.SetupUI()
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetch()
        tableView.reloadData()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailsVC = DetailsVC()
        let rslt = result[indexPath.row]
        DetailsVC.titleLabel.text = rslt.title
        DetailsVC.authorLabel.text = rslt.byline
        if rslt.image!.isEmpty == false {
            DetailsVC.imageView.downloaded(from: rslt.image!)
        } else{
            DetailsVC.imageView.image  = UIImage(named: "prapor")
        }
        DetailsVC.dateLabel.text =  rslt.publishedDate
        
        present(DetailsVC, animated: true)
        
    }
    //MARK: Editing Style cell
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let rslt = result[indexPath.row]
        if editingStyle == .delete {
            tableView.beginUpdates()
            result.remove(at: indexPath.row)
            CoreDataService.shared.deleteCell(rslt)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }

}
//MARK: TableView Delegate
extension FavoriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",  for: indexPath) as! CustomTableViewCell
        let rslt = result[indexPath.row]
        cell.titleLabel.text = rslt.title
        cell.sectionLabel.text = rslt.section
        cell.captionLabel.text = rslt.nytdsection?.uppercased()
        if rslt.image?.isEmpty == false {
            cell.myImageView.downloaded(from: rslt.image ?? "non")
        } else {
            cell.myImageView.image = UIImage(named: "prapor")
        }
        return cell
    }
}
//MARK: TableView DataSource
extension FavoriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
}




