//
//  ServerService.swift
//  iOS_Social
//
//  Created by Кирилл Иванов on 28.10.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

enum Err: Error {
    case BadCode
}

protocol ServerServiceProtocol: class {
    func login(email: String, password: String, completion: @escaping (Result<Data>) -> ())
    func register(fullName: String, email: String, password: String, completion: @escaping (Result<Data>) -> ())
    func fetchPosts(completion: @escaping (Result<[Post]>) -> ())
    func uploadPost(postText: String, imageData: Data, completion: @escaping (Result<Data>) -> ())
}

class ServerService: ServerServiceProtocol {
    
    let baseUrl = "http://localhost:1337"
    
    func login(email: String, password: String, completion: @escaping (Result<Data>) -> ()) {
        print("Performing login")
        let params = ["emailAddress": email, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/login"
        Alamofire.request(url, method: .put, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    completion(.failure(err))
                } else {
                    completion(.success(dataResponse.data ?? Data()))
                }
        }
    }
    
    func register(fullName: String, email: String, password: String, completion: @escaping (Result<Data>) -> ()) {
        print("Performing register")
        let params = ["fullName": fullName, "emailAddress": email, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/signup"
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    completion(.failure(err))
                } else {
                    completion(.success(dataResponse.data ?? Data()))
                }
        }
    }
    
    func fetchPosts(completion: @escaping (Result<[Post]>) -> ()) {
        let url = "\(baseUrl)/post"
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    completion(.failure(err))
                    return
                }
                
                guard let data = dataResponse.data else { return }
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))
                } catch let jsonErr {
                    completion(.failure(jsonErr))
                }
        }
    }
    
    func uploadPost(postText: String, imageData: Data, completion: @escaping (Result<Data>) -> ()) {
        let url = "\(baseUrl)/post"
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(Data(postText.utf8), withName: "postBody")
            formData.append(imageData, withName: "imagefile", fileName: "DontCare", mimeType: "image/jpg")
        }, to: url) { (res) in
            switch res {
            case .failure(let err):
                print("Failed to hit server: ", err)
                completion(.failure(err))
            case .success(let uploadRequest, _, _):
                uploadRequest.uploadProgress { (progress) in
//                    print("Upload progress: \(progress.fractionCompleted)")
                    NotificationCenter.default.post(name: .uploadProgress, object: nil, userInfo: ["uploadProgress": progress.fractionCompleted])
                }
                
                uploadRequest.responseJSON { (dataResp) in
                    if let err = dataResp.error {
                        print("Failed to hit server: ", err)
                        completion(.failure(err))
                        return
                    }
                    
                    if let code = dataResp.response?.statusCode, code >= 300 {
                        print("Failed upload with status: ", code)
                        completion(.failure(Err.BadCode))
                        return
                    }
                    
                    let respString = String(data: dataResp.data ?? Data(), encoding: .utf8)
                    print("Successfully created post, here is response: ")
                    completion(.success(Data(respString?.utf8 ?? "".utf8)))
                }
            }
        }
    }
}
