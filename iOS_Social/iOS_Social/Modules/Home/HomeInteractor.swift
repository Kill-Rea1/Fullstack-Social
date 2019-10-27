//
//  HomeInteractor.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 27.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

protocol HomeInteractorProtocol: class {
    func fetchPosts()
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
    
    func fetchPosts() {
        guard let url = URL(string: "http://localhost:1337/post") else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to hit server: ", err)
                    return
                } else if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                    print("Failed to fetch posts, statusCode: ", resp.statusCode)
                    return
                } else {
                    print("Successfully fetched posts, response data:")
                    let _html = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    print(_html)
                    self.html = _html
                }
            }
        }.resume()
    }
}
