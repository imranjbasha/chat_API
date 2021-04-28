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
    let baseurl_messages = "http://34.201.129.14:5000/messages"
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
    
    func sendImageMessage(userId: String, message: String){
        
        
    }
    
}
