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
    
}
