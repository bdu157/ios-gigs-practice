//
//  GigController.swift
//  ios-gigs-practice
//
//  Created by Dongwoo Pae on 6/13/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}


class GigController {
    
    var gigs : [Gig] = []
    var bearer: Bearer?
    
    let baseURL = URL(string:"https://lambdagigs.vapor.cloud/api")!

    //creating gigs
    func createGigs(title: String, description: String, dueDate: Date, completion:@escaping(Error?)->()) {
        let input = Gig(title: title, description: description, dueDate: dueDate)
        
        let createGigURL = self.baseURL.appendingPathComponent("gigs")
        
        guard let bearer = bearer else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: createGigURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        jsonEncoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try jsonEncoder.encode(input)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user objects: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let _  = error {
                completion(NSError())
                return
            }
            self.gigs.append(input)
            completion(nil)
        }.resume()
    }

    
    //sign up
    func signUp(with user: User, completion:@escaping (Error?)-> ()) {
        let signUpURL = self.baseURL.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
    
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    //log in
    
    func logIn(with user: User, completion:@escaping (Error?)->()) {
        let logInURL = self.baseURL.appendingPathComponent("users/login")
        
        var request = URLRequest(url: logInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            
            do {
                self.bearer = try jsonDecoder.decode(Bearer.self, from: data)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                return
            }
            completion(nil)
        }.resume()
    }
    //fetching gigs
    func fetchGigs(completion:@escaping (Error?)->Void) {
        let fetchGigsURL = self.baseURL.appendingPathComponent("gigs")
        
        guard let bearer = bearer else {
            completion(NSError())
            return
        }
        
        
        var request = URLRequest(url: fetchGigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let _ = error {
                completion(NSError())
                return
            }
            guard let data = data else {
                completion(NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            
            jsonDecoder.dateDecodingStrategy = .iso8601
            
            do {
                let gigs = try jsonDecoder.decode([Gig].self, from: data)
                self.gigs = gigs
                completion(nil)
            } catch {
                NSLog("Error decoding gigs objects: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
