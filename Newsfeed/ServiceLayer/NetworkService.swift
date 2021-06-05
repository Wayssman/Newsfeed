//
//  NetworkService.swift
//  NewsFeed
//
//  Created by Желанов Александр Валентинович on 23.04.2021.
//

import Foundation

// Перечисление с типами ошибок
enum TaskError: Error {
  case transportError(Error)
  case serverError(Int)
  case nilResponse
  case mimeError
  case jsonError(Error)
  case parseError(Error)
}

// Типы возвращаемого результата
typealias DataTaskResult = Result<Data?, TaskError>
typealias LoadResult = Result<NewsResponse, TaskError>

final class NetworkService {
  // MARK: - Public Methods
  func loadNews(completion: @escaping (LoadResult) -> Void) {
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    let url = constructUrl(withApiKey: "UCy2HZhT0pkEstci5dIYxLjA2Oj1PfLP")
    
    self.doTask(session: session, with: url, completion: { result in
      switch result {
      case .failure(let error):
        completion(Result.failure(error))
      case .success(let data):
        do {
          let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
        } catch {
          completion(Result.failure(TaskError.jsonError(error)))
        }
        
        let decoder = JSONDecoder()
        do {
          let result = try decoder.decode(NewsResponse.self, from: data!)
          completion(Result.success(result))
        } catch {
          completion(Result.failure(TaskError.parseError(error)))
        }
      }
    }).resume()
  }
  
  // MARK: - Private Methods
  private func constructUrl(withApiKey key: String) -> URL {
    var urlConstructor = URLComponents()
    urlConstructor.scheme = "https"
    urlConstructor.host = "api.nytimes.com"
    urlConstructor.path = "/svc/topstories/v2/world.json"
    urlConstructor.queryItems = [
      URLQueryItem(name: "api-key", value: "\(key)")
    ]
    
    return urlConstructor.url!
  }
  
  private func doTask(session: URLSession, with url: URL,
              completion: @escaping (DataTaskResult) -> Void) -> URLSessionDataTask {
    return session.dataTask(with: url) { (data, response, error) in
      // Проверка Transport errors
      if let error = error {
        completion(Result.failure(TaskError.transportError(error)))
        return
      }
      
      // Проверка HTTP status codes
      guard let response = response as? HTTPURLResponse else {
        completion(Result.failure(TaskError.nilResponse))
        return
      }
      
      guard (200...299).contains(response.statusCode) else {
        completion(Result.failure(TaskError.serverError(response.statusCode)))
        return
      }
      
      // Запрашиваем формат JSON и выдаем ошибку при несовпадении
      guard let mime = response.mimeType, mime == "application/json" else {
        completion(Result.failure(TaskError.mimeError))
        return
      }
      
      completion(Result.success(data))
    }
  }
}
