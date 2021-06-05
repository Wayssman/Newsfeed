//
//  RealmService.swift
//  NewsFeed
//
//  Created by Желанов Александр Валентинович on 23.04.2021.
//

import Foundation
import RealmSwift

// Перечисление ошибок Realm
enum RealmError: Error {
  case saveError(Error)
}

final class RealmService {
  // MARK: - Public Methods
  func saveNewsData(news: [NewsResultRealm], completion: @escaping (RealmError?) -> Void) {
    do {
      let realm = try Realm()
      
      let oldNews = realm.objects(NewsResultRealm.self)
      
      realm.beginWrite()
      realm.delete(oldNews)
      realm.add(news)
      try realm.commitWrite()
      
      completion(nil)
    } catch {
      completion(RealmError.saveError(error))
    }
  }
}

extension RealmSwift.List where Element: Decodable {
  public convenience init(from decoder: Decoder) throws {
    self.init()
    let container = try decoder.singleValueContainer()
    let decodedElements = try container.decode([Element].self)
    self.append(objectsIn: decodedElements)
  }
}

extension RealmSwift.List where Element: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.map { $0 })
  }
}
