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

protocol ServerServiceProtocol: class {
    func login(email: String, password: String, completion: @escaping (Result<Data>) -> ())
    func register(fullName: String, email: String, password: String, completion: @escaping (Result<Data>) -> ())
    func fetchPosts(completion: @escaping (Result<[Post]>) -> ())
    func uploadImage(info: Any)
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
    
    func uploadImage(info: Any) {
        guard let infoDict = info as? [UIImagePickerController.InfoKey : Any] else { return }
        guard let image = infoDict[.originalImage] as? UIImage else { return }
        let url = "\(baseUrl)/post"
        Alamofire.upload(multipartFormData: { (formData) in
            // post text
            formData.append(Data("Coming from iPhone sim".utf8), withName: "postBody")
            
            // post image
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            formData.append(imageData, withName: "imagefile", fileName: "DontCare", mimeType: "image/jpg")
        }, to: url) { (res) in
            switch res {
            case .failure(let err):
                print("Failed to hit server: ", err)
            case .success(let uploadRequest, _, _):
                uploadRequest.uploadProgress { (progress) in
                    print("Upload progress: \(progress.fractionCompleted)")
                }
                
                uploadRequest.responseJSON { (dataResp) in
                    if let err = dataResp.error {
                        print("Failed to hit server: ", err)
                        return
                    }
                    
                    if let code = dataResp.response?.statusCode, code >= 300 {
                        print("Failed upload with status: ", code)
                        return
                    }
                    
                    let respString = String(data: dataResp.data ?? Data(), encoding: .utf8)
                    print("Successfully created post, here is response: ")
                    print(respString ?? "")
                    
                    
                }
            }
        }
    }
}
