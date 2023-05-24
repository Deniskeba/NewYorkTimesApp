//
//  MostViewedVC.swift
//  NYTApp
//
//  Created by Denis Kobylkov on 16.05.2023.
//

import UIKit
import SnapKit
import Alamofire
import CoreData

class MostViewedVC: UIViewController {
    let networkService = NetworkService()
    var newsResponse: NewsResponse? = nil
    var appNews : [AppNew] = []
    
    

//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.SetupUI()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        

//MARK: - request
        networkService.fetchData(url: "https://api.nytimes.com/svc/mostpopular/v2/viewed/30.json?api-key=0p0l10fitHGV5QReOPAbOxf00hWmN0Dr") { [self] (result) in
            switch result {
            case .success(let newsResponse):
                self.newsResponse = newsResponse
                
                guard let results = newsResponse.results else {return}
                for item in results {
                    let i = AppNew(new: item)
                    appNews.append(i)
                }
                tableView.reloadData()
                
            case .failure(let error):
                print("error", error)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailsVC = DetailsVC()
        DetailsVC.titleLabel.text = appNews[indexPath.row].new.title
        DetailsVC.authorLabel.text = appNews[indexPath.row].new.byline
        if appNews[indexPath.row].new.media?.isEmpty == false {
            DetailsVC.imageView.downloaded(from: appNews[indexPath.row].new.media![0].mediaMetadata![2].url!)
        } else{
            DetailsVC.imageView.image  = UIImage(named: "prapor")
        }
        DetailsVC.dateLabel.text = appNews[indexPath.row].new.publishedDate
        
        
        present(DetailsVC, animated: true)

    }
    
}
//MARK: TableView Delegate
extension MostViewedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",  for: indexPath) as! CustomTableViewCell
        cell.titleLabel.text = appNews[indexPath.row].new.title
        cell.captionLabel.text = appNews[indexPath.row].new.nytdsection!.uppercased()
        cell.sectionLabel.text = appNews[indexPath.row].new.section
        if appNews[indexPath.row].new.media?.isEmpty == false {
            cell.myImageView.downloaded(from: appNews[indexPath.row].new.media![0].mediaMetadata![1].url!)
        } else {
            cell.myImageView.image = UIImage(named: "prapor")
        }
        cell.didTapFavoriteClosure = { [weak self, indexPath] in
        guard let self = self else { return }
            self.appNews[indexPath.row].isFavorite.toggle()
            
            CoreDataService.shared.createCard(self.appNews[indexPath.row].new)
            
        }
        return cell
    }
}
//MARK: TableView DataSource
extension MostViewedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsResponse?.results?.count ?? 0
    }
}
//MARK: Download Images from API
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
