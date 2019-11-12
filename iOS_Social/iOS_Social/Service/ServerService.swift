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

struct Success: Decodable {}

enum Err: Error {
    case BadCode
}

protocol UploadProgressProtocol: class {
    func progressDidChange(progress: Double)
}

protocol ServerServiceProtocol: class {
    var delegate: UploadProgressProtocol? { get set }
    func searchForUsers(completion: @escaping ([User]?, Error?) -> ())
    func changeFollowState(of userId: String, state isFollow: Bool, completion: @escaping (Success?, Error?) -> ())
    func login(email: String, password: String, completion: @escaping (Success?, Error?) -> ())
    func register(fullName: String, email: String, password: String, completion: @escaping (Success?, Error?) -> ())
    func fetchPosts(completion: @escaping ([Post]?, Error?) -> ())
    func uploadPost(postText: String, imageData: Data, completion: @escaping (Result<Data>) -> ())
    func deletePost(with id: String, completion: @escaping (Success?, Error?) -> ())
    func fetchUser(with id: String, completion: @escaping (User?, Error?) -> ())
    func uploadNewAvatar(with info: Any, fullName: String, bio: String, completion: @escaping (Result<Data>) -> ())
    func fetchPostComments(with id: String, completion: @escaping ([Comment]?, Error?) -> ())
    func uploadComment(with text: String, postId: String, completion: @escaping (Success?, Error?) -> ())
    func deleteFeedItem(with id: String, completion: @escaping (Success?, Error?) -> ())
    func didLikedPost(with id: String, likeState: Bool, completion: @escaping (Success?, Error?) -> ())
    func fetchPostsLikes(with id: String, completion: @escaping ([User]?, Error?) -> ())
}

class ServerService: ServerServiceProtocol {
    
//    #if targetEnvironment(simulator)
//        let baseUrl = "http://localhost:1337"
//    #else
//        let baseUrl = "http://192.168.0.103:1337"
//    #endif
    private let baseUrl = "https://fullstack-social-ivanoff.herokuapp.com"
    
    private func fetchGenericJSONData<T: Decodable>(url: String, method: HTTPMethod = .get, params: Parameters? = nil, completion: @escaping (T?, Error?)->()) {
        Alamofire.request(url, method: method, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    completion(nil, err)
                    return
                }
                guard let data = dataResp.data else { return }
                let dataStr = String(data: data, encoding: .utf8) ?? ""
                if data == Data() || dataStr == "OK" {
                    completion(nil, nil)
                    return
                }
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(object, nil)
                } catch let jsonErr {
                    completion(nil, jsonErr)
                }
        }
    }
    
    // MARK:- ServerServiceProtocol
    
    weak var delegate: UploadProgressProtocol?
    
    func login(email: String, password: String, completion: @escaping (Success?, Error?) -> ()) {
        print("Performing login")
        let params = ["emailAddress": email, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/login"
        fetchGenericJSONData(url: url, method: .put, params: params, completion: completion)
    }
    
    func register(fullName: String, email: String, password: String, completion: @escaping (Success?, Error?) -> ()) {
        let params = ["fullName": fullName, "emailAddress": email, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/signup"
        fetchGenericJSONData(url: url, method: .post, params: params, completion: completion)
    }
    
    func fetchPosts(completion: @escaping ([Post]?, Error?) -> ()) {
        let url = "\(baseUrl)/post"
        fetchGenericJSONData(url: url, completion: completion)
    }
    
    func deletePost(with id: String, completion: @escaping (Success?, Error?) -> ()) {
        let url = "\(baseUrl)/post/\(id)"
        fetchGenericJSONData(url: url, method: .delete, completion: completion)
    }
    
    func searchForUsers(completion: @escaping ([User]?, Error?) -> ()) {
        let url = "\(baseUrl)/search"
        fetchGenericJSONData(url: url, completion: completion)
    }
    
    func changeFollowState(of userId: String, state isFollow: Bool, completion: @escaping (Success?, Error?) -> ()) {
        let url = "\(baseUrl)/\(isFollow ? "unfollow" : "follow")/\(userId)"
        fetchGenericJSONData(url: url, method: .post, completion: completion)
    }
    
    func fetchUser(with id: String, completion: @escaping (User?, Error?) -> ()) {
        let currentUserProfileUrl = "\(baseUrl)/profile"
        let publicProfileUrl = "\(baseUrl)/user/\(id)"
        let url = id.isEmpty ? currentUserProfileUrl : publicProfileUrl
        fetchGenericJSONData(url: url, completion: completion)
    }
    
    func fetchPostComments(with id: String, completion: @escaping ([Comment]?, Error?) -> ()) {
        let url = "\(baseUrl)/post/\(id)"
        fetchGenericJSONData(url: url, completion: completion)
    }
    
    func uploadComment(with text: String, postId: String, completion: @escaping (Success?, Error?) -> ()) {
        let url = "\(baseUrl)/comment/post/\(postId)"
        let params = ["text": text]
        fetchGenericJSONData(url: url, method: .post, params: params, completion: completion)
    }
    
    func deleteFeedItem(with id: String, completion: @escaping (Success?, Error?) -> ()) {
        let url = "\(baseUrl)/feeditem/\(id)"
        fetchGenericJSONData(url: url, method: .delete, completion: completion)
    }
    
    func didLikedPost(with id: String, likeState: Bool, completion: @escaping (Success?, Error?) -> ()) {
        let url = "\(baseUrl)/\(likeState ? "dislike" : "like")/\(id)"
        fetchGenericJSONData(url: url, method: .post, completion: completion)
    }
    
    func fetchPostsLikes(with id: String, completion: @escaping ([User]?, Error?) -> ()) {
        let url = "\(baseUrl)/likes/\(id)"
        fetchGenericJSONData(url: url, completion: completion)
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
                    self.delegate?.progressDidChange(progress: progress.fractionCompleted)
                }
                
                uploadRequest.responseData { (dataResp) in
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
                    completion(.success(Data()))
                }
            }
        }
    }
    
    func uploadNewAvatar(with info: Any, fullName: String, bio: String, completion: @escaping (Result<Data>) -> ()) {
        guard let infoDict = info as? [UIImagePickerController.InfoKey: Any],
            let image = infoDict[.originalImage] as? UIImage,
            let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let url = "\(baseUrl)/profile"
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(Data(fullName.utf8), withName: "fullName")
            formData.append(Data(bio.utf8), withName: "bio")
            formData.append(imageData, withName: "imagefile", fileName: "DontCare", mimeType: "image/jpg")
        }, to: url) { (res) in
            switch res {
            case .failure(let err):
                print("Failed to update profile: ", err)
                completion(.failure(err))
            case .success(let uploadRequest, _, _):
                uploadRequest.uploadProgress { (progress) in
                    self.delegate?.progressDidChange(progress: progress.fractionCompleted)
                }
                uploadRequest.responseData { (dataResp) in
                    if let err = dataResp.error {
                        print("Failed to hit server: ", err)
                        completion(.failure(err))
                        return
                    }
                    
                    if let code = dataResp.response?.statusCode, code >= 300 {
                        print("Failed to upload with status: ", code)
                        completion(.failure(Err.BadCode))
                        return
                    }
                    completion(.success(Data()))
                }
            }
        }
    }
}
