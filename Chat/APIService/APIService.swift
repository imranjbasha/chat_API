//
//  APIService.swift
//  Chat
//
//  Created by IMRAN on 19/04/21.
//

import Foundation
import Alamofire

class APIService {
    
    let baseurl_friendList = "http://34.201.129.14:5000/friend-list"
    let baseurl_followers = "http://34.201.129.14:5000/followers"
    let baseurl_following = "http://34.201.129.14:5000/following"
    let baseurl_messages = "http://34.201.129.14:5000/messages"
    let baseurl_messages_clear = "http://34.201.129.14:5000/messages/clear_all"
    let baseurl_chat_attachments = "http://34.201.129.14:5000/messages/attachments"
    let headers: HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZmFmNDZmYThlZTBkOTQxMTA3NmQyNWMiLCJpYXQiOjE2MTY0MjU2MjB9.z7DfS7nfosTNfrfprAYE34CBYUA_iW6UnWL_pvTJBeI"]
    
    func fetchFriendsListFromBackend(completion: @escaping (_ data: [Friend]) -> Void){
        AF.request(baseurl_friendList, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = response.data {
                do {
                    let friends = try JSONDecoder().decode(Friends.self, from: data)
                    completion(friends)
                    }catch{
                        print(error.localizedDescription)
                    }
            }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchFollowers(completion: @escaping (_ data: Followers) -> Void){
        AF.request(baseurl_followers, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = response.data {
                do {
                    let followers = try JSONDecoder().decode(Followers.self, from: data)
                    completion(followers)
                    }catch{
                        print(error.localizedDescription)
                    }
            }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchFollowings(completion: @escaping (_ data: Followings) -> Void){
        AF.request(baseurl_following, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = response.data {
                do {
                    let (followings) = try JSONDecoder().decode(Followings.self, from: data)
                    completion(followings)
                    }catch{
                        print(error.localizedDescription)
                    }
            }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    func fetchChatMessagesFromBackend(userId: String, completion: @escaping (_ data: [Message]) -> Void){
        AF.request(baseurl_messages+"/"+userId, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = response.data {
                do {
                    let messages = try JSONDecoder().decode(Messages.self, from: data)
                    completion(messages)
                    }catch{
                        print(error.localizedDescription)
                    }
            }
            case .failure(let error):
                completion([])
                print(error.localizedDescription)
            }
        }
    }
    
    func sendTextMessage(userId: String, message: String, completion: @escaping ((_ isChatSent: Bool) -> Void)){
        let parameters = ["message": message,
                          "userId": userId]

        
        AF.request(baseurl_messages, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                completion(true)
                print("text chat sent...")
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func sendMediaMessage(userId: String, message: String,  imageData: Data, fileName: String, completion: @escaping ((_ isMediaSent: Bool) -> Void)){
        let parameters = ["type": "media",
                          "userId": userId]
        AF.upload(multipartFormData: {multipartFormData in
            multipartFormData.append(imageData, withName: "files", fileName: fileName, mimeType: "image/png")

            for (key, value) in parameters{
                multipartFormData.append((value).data(using: String.Encoding.utf8)!, withName: key)
            }
          /*  for i in 0..<self.fileUrl.count{
                let cArrArray = "\(self.fileUrl[i])".components(separatedBy: ".")
                let mimeType = self.returnMimeType(fileExtension: cArrArray[i])
                let pngData = self.imageData[i].pngData()
                multipartFormData.append(pngData!, withName: "files", fileName: "\(self.fileUrl[i])", mimeType: mimeType)
            } */
          
        }, to: baseurl_chat_attachments, method: .post, headers: headers).uploadProgress{ progress in

        }.response{ response in
            if response.error == nil {
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    func deleteMessage(messageId: String, userId: String, shouldDeleteForBoth: Bool, completion: @escaping ((_ isMessageDeleted: Bool) -> Void)){
        let parameters = ["messageId": messageId,
                          "userId": userId,
                          "shouldDeleteForBoth": shouldDeleteForBoth] as [String : Any]
        AF.request(baseurl_messages, method: .put, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                completion(true)
                print("message deleted...")
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func clearAllMessages(userId: String, shouldDeleteForBoth: Bool, completion: @escaping ((_ isMessageDeleted: Bool) -> Void)){
        let parameters = ["userId": userId, "shouldDeleteForBoth": shouldDeleteForBoth] as [String : Any]
        AF.request(baseurl_messages_clear, method: .delete, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                completion(true)
                print("all messages deleted...")
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }

        }
    }
    
    
}
