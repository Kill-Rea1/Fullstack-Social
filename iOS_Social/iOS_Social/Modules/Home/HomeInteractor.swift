//
//  HomeInteractor.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Alamofire

protocol HomeInteractorProtocol: class {
    func fetchPosts(completionHandler: @escaping ([Post]?, Error?) -> ())
}

class HomeInteractor: HomeInteractorProtocol {
    
    weak var presenter: HomePresenterProtocol?
    
    required init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
    }
    
    var html: String! {
        didSet {
            presenter?.html = html
        }
    }
    
    func fetchPosts(completionHandler: @escaping ([Post]?, Error?) -> ()) {
        let url = "http://localhost:1337/post"
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    print("Failed to fetch posts: ", err)
                    completionHandler(nil, err)
                    return
                }
                guard let data = dataResponse.data else { return }
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    print("Success")
                    completionHandler(posts, nil)
                } catch let jsonErr {
                    print("Failed to decode JSON: ", jsonErr)
                    completionHandler(nil, jsonErr)
                }
        }
    }
}
