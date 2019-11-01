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

protocol UploadProgressProtocol: class {
    func progressDidChange(progress: Double)
}

protocol ServerServiceProtocol: class {
    var delegate: UploadProgressProtocol? { get set }
    func searchForUsers(completion: @escaping (Result<[User]>) -> ())
    func changeFollowState(of userId: String, state isFollow: Bool, completion: @escaping (Result<Data>) -> ())
    func login(email: String, password: String, completion: @escaping (Result<Data>) -> ())
    func register(fullName: String, email: String, password: String, completion: @escaping (Result<Data>) -> ())
    func fetchPosts(completion: @escaping (Result<[Post]>) -> ())
    func uploadPost(postText: String, imageData: Data, completion: @escaping (Result<Data>) -> ())
    func deletePost(with id: String, completion: @escaping (Result<Data>) -> ())
    func fetchUser(with id: String, completion: @escaping (Result<User>) -> ())
    func uploadNewAvatar(with info: Any, fullName: String, bio: String, completion: @escaping (Result<Data>) -> ())
    func fetchPostComments(with id: String, completion: @escaping (Result<[Comment]>) -> ())
    func uploadComment(with text: String, postId: String, completion: @escaping (Result<Data>) -> ())
    func deleteFeedItem(with id: String, completion: @escaping (Result<Data>) -> ())
    func didLikedPost(with id: String, likeState: Bool, completion: @escaping (Result<Data>) -> ())
}

class ServerService: ServerServiceProtocol {
    
    #if targetEnvironment(simulator)
        let baseUrl = "http://localhost:1337"
    #else
        let baseUrl = "http://192.168.0.103:1337"
    #endif
    
    weak var delegate: UploadProgressProtocol?
    
    func fetchUser(with id: String, completion: @escaping (Result<User>) -> ()) {
        let currentUserProfileUrl = "\(baseUrl)/profile"
        let publicProfileUrl = "\(baseUrl)/user/\(id)"
        let url = id.isEmpty ? currentUserProfileUrl : publicProfileUrl
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to fetch user profile: ", err)
                    completion(.failure(err))
                    return
                }
                
                guard let data = dataResp.data else { return }
                do {
                    var user = try JSONDecoder().decode(User.self, from: data)
                    user.isEditable = id.isEmpty
                    completion(.success(user))
                } catch let jsonErr {
                    print("Failed to decode JSON user: ", jsonErr)
                    completion(.failure(jsonErr))
                }
                
        }
    }
    
    func searchForUsers(completion: @escaping (Result<[User]>) -> ()) {
        let url = "\(baseUrl)/search"
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to fetch users: ", err)
                    completion(.failure(err))
                    return
                }
                
                do {
                    guard let data = dataResp.data else { return }
                    let users = try JSONDecoder().decode([User].self, from: data)
                    completion(.success(users))
                } catch let jsonErr {
                    print("Failed to decode JSON users: ", jsonErr)
                    completion(.failure(jsonErr))
                }
        }
    }
    
    func changeFollowState(of userId: String, state isFollow: Bool, completion: @escaping (Result<Data>) -> ()) {
        let url = "\(baseUrl)/\(isFollow ? "unfollow" : "follow")/\(userId)"
        Alamofire.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to change follow state: ", err)
                    completion(.failure(err))
                    return
                }
                completion(.success(dataResp.data ?? Data()))
        }
    }

    
    func login(email: String, password: String, completion: @escaping (Result<Data>) -> ()) {
        print("Performing login")
        let params = ["emailAddress": email, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/login"
        Alamofire.request(url, method: .put, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    print("Failed to log in: ", err)
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
                    print("Failed to sign up: ", err)
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
                    print("Failed to fetch posts: ", err)
                    completion(.failure(err))
                    return
                }
                
                guard let data = dataResponse.data else { return }
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))
                } catch let jsonErr {
                    print("Failed to decode JSON posts: ", jsonErr)
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
    
    func deletePost(with id: String, completion: @escaping (Result<Data>) -> ()) {
        let url = "\(baseUrl)/post/\(id)"
        Alamofire.request(url, method: .delete)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to delete: ", err)
                    completion(.failure(err))
                    return
                }
                completion(.success(Data()))
        }
    }
    
    func deleteFeedItem(with id: String, completion: @escaping (Result<Data>) -> ()) {
        let url = "\(baseUrl)/feeditem/\(id)"
        Alamofire.request(url, method: .delete)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to delete feed item: ", err)
                    completion(.failure(err))
                    return
                }
                completion(.success(Data()))
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
    
    func fetchPostComments(with id: String, completion: @escaping (Result<[Comment]>) -> ()) {
        let url = "\(baseUrl)/post/\(id)"
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to fetch comments: ", err)
                    completion(.failure(err))
                    return
                }
                
                guard let data = dataResp.data else { return }
                do {
                    let post = try JSONDecoder().decode(Post.self, from: data)
                    let comments = post.comments ?? [Comment]()
                    completion(.success(comments))
                } catch let jsonErr {
                    print("Failed to decode JSON comments: ", jsonErr)
                    completion(.failure(jsonErr))
                }
        }
    }
    
    func uploadComment(with text: String, postId: String, completion: @escaping (Result<Data>) -> ()) {
        let url = "\(baseUrl)/comment/post/\(postId)"
        let params = ["text": text]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to upload comment: ", err)
                    completion(.failure(err))
                    return
                }
                completion(.success(Data()))
        }
    }
    
    func didLikedPost(with id: String, likeState: Bool, completion: @escaping (Result<Data>) -> ()) {
        let url = "\(baseUrl)/\(likeState ? "dislike" : "like")/\(id)"
        Alamofire.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to like post: ", err)
                    completion(.failure(err))
                    return
                }
                completion(.success(Data()))
        }
    }
}
