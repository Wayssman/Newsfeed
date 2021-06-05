//
//  ViewController.swift
//  NewsFeed
//
//  Created by Желанов Александр Валентинович on 23.04.2021.
//

import UIKit
import RealmSwift

final class NewsfeedViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet private weak var tableView: UITableView!
  
  // MARK: - Private Properties
  private var realmToken: NotificationToken?
  private var realmNews: Results<NewsResultRealm>?
  
  private let networkService = NetworkService()
  private let realmService = RealmService()
  
  private let myRefreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    
    return refreshControl
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupRealm()
    reloadNewsfeed()
  }
  
  // MARK: - Private Methods
  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    tableView.refreshControl = myRefreshControl
  }
  
  private func setupRealm() {
    guard let realm = try? Realm() else { return }
    
    realmNews = realm.objects(NewsResultRealm.self)
    
    realmToken = realmNews?.observe { [weak self] change in
      guard let self = self else { return }
      guard let tableView = self.tableView else { return }
      
      //Обновляем всю таблицу
      switch change {
      case .initial:
        tableView.reloadData()
      case .update:
        tableView.reloadData()
      case .error(let error):
        fatalError("\(error)")
      }
    }
  }
  
  private func reloadNewsfeed() {
    title = "Загрузка..."
    networkService.loadNews(completion: { [weak self] loadResult in
      guard let self = self else { return }
      
      switch loadResult {
      case .success(let response):
        self.realmService.saveNewsData(news: response.results, completion: { error in
          if error == nil {
            self.changeNewsScreenState(withTitle: "Новости")
          }
        })
      case .failure(let error): // Можно через switch распарсить все типы ошибок
        print(error)
        self.changeNewsScreenState(withTitle: "Не удалось загрузить данные...")
      }
    })
  }
  
  private func changeNewsScreenState(withTitle title: String) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.title = title
    }
  }
  
  @objc private func refresh(sender: UIRefreshControl) {
    reloadNewsfeed()
    sender.endRefreshing()
  }
  
  // MARK: - Deinitializers
  deinit {
    realmToken?.invalidate()
  }
}

// MARK: - UITableViewDataSource
extension NewsfeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    realmNews?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NewsfeedCell", for: indexPath) as! NewsfeedCell
    if let realmNews = realmNews {
      cell.configurateCell(with: realmNews[indexPath.row])
    }
    return cell
  }
}

// MARK: - UITableViewDelegate
extension NewsfeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let realmNews = realmNews else { return }
    
    let data = realmNews[indexPath.row]
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let detailVC = storyboard.instantiateViewController(identifier: "DetailedBoard")
    
    if let detail = detailVC as? DetailViewController {
      detail.configureDetailViewController(with: data)
      navigationController?.pushViewController(detail, animated: true)
    }
  }
}
