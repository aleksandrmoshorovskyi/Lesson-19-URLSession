//
//  ViewController.swift
//  Lesson-19-URLSession
//
//  Created by Aleksandr Moroshovskyi on 22.04.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func getBtnAction(_ sender: Any) {
        
        //getDataOldAproach()
        
        getData()
    }
    
    
    @IBAction func postBtnAction(_ sender: Any) {
        
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func getDataOldAproach() {
     
        let urlString = "https://reqres.in/api/users?page=2"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let responseError = error {
                debugPrint(responseError.localizedDescription)
            } else {
                debugPrint("")
                
                guard let responseData = data else { return }
                
                //старий варіант
                do {
                    //let result = try JSONSerialization.jsonObject(with: responseData)
                    let result: [String : Any] = try JSONSerialization.jsonObject(with: responseData) as! [String : Any]
                    
                    let currentPage: Int = result["page"] as? Int ?? 0
                    let data: [[String : Any]] = result["data"] as? [[String : Any]] ?? []
                    
                    print(currentPage)
                    print(data)
                    
                    debugPrint(result)
                } catch (let parseError) {
                    debugPrint(parseError.localizedDescription)
                }
            }
        }.resume()
    }
    
//сучасний підхід

    //GET
    func getData() {
     
        let urlString = "https://reqres.in/api/users?page=2"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let responseError = error {
                debugPrint(responseError.localizedDescription)
            } else {
                debugPrint("")
                
                guard let responseData = data else { return }
                
                //сучасний варіант
                do {
                    let result = try JSONDecoder().decode(UsersListResponse.self, from: responseData)
                    debugPrint(result)
                } catch (let parseError) {
                    debugPrint(parseError.localizedDescription)
                }
            }
        }.resume()
    }
    
    //POST
    func loadData() {
     
        let urlString = "https://reqres.in/api/users"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let params = CreateUserParams(name: "Bob", job: "Job")
        let paramData = try! JSONEncoder().encode(params)
        
        request.httpBody = paramData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let responseError = error {
                debugPrint(responseError.localizedDescription)
            } else {
                debugPrint("")
                
                guard let responseData = data else { return }
                
                //сучасний варіант
                do {
                    let result = try JSONDecoder().decode(CreateUserResponse.self, from: responseData)
                    debugPrint(result)
                } catch (let parseError) {
                    debugPrint(parseError.localizedDescription)
                }
            }
        }.resume()
    }
    
    /*
    func request<T: Decodable>(request: URLRequest, type: T) {
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let responseError = error {
                debugPrint(responseError.localizedDescription)
            } else {
                debugPrint("")
                
                guard let responseData = data else { return }
                
                //сучасний варіант
                do {
                    let result = try JSONDecoder().decode(T.self, from: responseData)
                    debugPrint(result)
                } catch (let parseError) {
                    debugPrint(parseError.localizedDescription)
                }
            }
        }.resume()
    }
     */
    
}

//сучасний підхід

/*
 page: 2,
 per_page: 6,
 total: 12,
 total_pages: 2,
 data: [
 {
 id: 7,
 email: "michael.lawson@reqres.in",
 first_name: "Michael",
 last_name: "Lawson",
 avatar: "https://reqres.in/img/faces/7-image.jpg"
 },
 */

struct UsersListResponse: Decodable {
    
    let page: Int
    let total: Int
    let someData: Int? //дані, які можуть прийти, а можуть не прийти
    let users: [UserResponse]
    
    //для ключів, що не відповідать вимогам
    enum CodingKeys: String, CodingKey {
        case page
        case total
        case someData
        case users = "data"
    }
    
    struct UserResponse: Decodable {
        
        let id: Int
        let email: String
        let firstName: String
        let lastName: String
        let avatar: String
        
        //для ключів, що не відповідать вимогам
        enum CodingKeys: String, CodingKey {
            case id
            case email
            case firstName = "first_name"
            case lastName = "last_name"
            case avatar
        }
    }
}

///
///
/*
 page: 1,
 per_page: 6,
 total: 12,
 total_pages: 2,
 data: [
 {
 id: 1,
 email: "george.bluth@reqres.in",
 first_name: "George",
 last_name: "Bluth",
 avatar: "https://reqres.in/img/faces/1-image.jpg"
 },
 */

struct CreateUserParams: Codable {
    
    let name: String
    let job: String
}

struct CreateUserResponse: Decodable {
    
    let name: String?
    let job: String?
    let id: String
    let createdAt: String
}

/*
 Request
 /api/users

 {
     "name": "morpheus",
     "job": "leader"
 }
  
 Response
 201

 {
     "name": "morpheus",
     "job": "leader",
     "id": "397",
     "createdAt": "2024-04-24T12:31:35.099Z"
 }
 */
