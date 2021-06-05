//
//  Model.swift
//  NewsFeed
//
//  Created by Желанов Александр Валентинович on 24.04.2021.
//

import Foundation
import RealmSwift

struct NewsResponse: Codable {
  let results: [NewsResultRealm]
}

@objcMembers public class NewsResultRealm: Object, Codable {
  dynamic var title: String = ""
  dynamic var abstract: String = ""
  var multimedia = List<NewsMultimediaRealm>()
}

@objcMembers public class NewsMultimediaRealm: Object, Codable {
  dynamic var caption: String = ""
  dynamic var type: String = ""
  dynamic var url: String = ""
  dynamic var height: Int = 0
  dynamic var width: Int = 0
}

