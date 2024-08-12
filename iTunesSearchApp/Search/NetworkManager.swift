//
//  NetworkManager.swift
//  iTunesSearchApp
//
//  Created by 박다현 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

enum NetworkError: Error {
    case invaildURL
    case unknownResponse
    case decodingFailure
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchDataWithAlamofire(query:String) -> Single<Search> {
        let result = Single<Search>.create { observer in
            let url = "https://itunes.apple.com/search?term=\(query)"
            AF.request(url).responseDecodable(of: Search.self) { response in
                switch response.result{
                case .success(let value):
                    observer(.success(value))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }.debug("네트워크")
        return result
    }
    
    func callRequest(query:String) -> Observable<Search>{
        let url = "https://itunes.apple.com/search?term=\(query)"

        let result = Observable<Search>.create { observer in
            guard let apiURL = URL(string: url) else {
                observer.onError(NetworkError.invaildURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: apiURL) { data, response, error in
                guard error == nil else {
                    observer.onError(NetworkError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(NetworkError.unknownResponse)
                    return
                }
                
                if let data = data, let searchData = try? JSONDecoder().decode(Search.self, from: data) {
                    observer.onNext(searchData)
                    observer.onCompleted()
                } else {
                    observer.onError(NetworkError.decodingFailure)
                }
            }.resume()
            
            return Disposables.create()
        }
        return result
    }
}
