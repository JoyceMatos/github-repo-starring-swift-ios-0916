//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(githubAPIURL)/repositories?client_id=\(githubClientID)&client_secret=\(githubClientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        })
        task.resume()
    }
    
    
    class func checkIfRepositoryIsStarred(_ fullName: String, completion: @escaping (Bool) -> ()) {
        let urlString = "https://api.github.com/user/starred/\(fullName)?access_token=\(accessToken)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 204:
                    print("You have starred this content")
                    completion(true)
                    break
                case 404:
                    print("You have not starred this content")
                    completion(false)
                    break
                default:
                    print("This is the default case")
                }
            }
        }
        task.resume()
    }
    
    class func starRepository(named: String , completion: @escaping () -> ()) {
        let urlString = "https://api.github.com/user/starred/\(named)?access_token=\(accessToken)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "PUT"
        request.addValue("0", forHTTPHeaderField: "Content-Length")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 204:
                    print("You have just starred this content")
                default:
                    print("STAR: This is the default case")
                }
            }
            completion()
        }
        task.resume()
    }
    
    class func unstarRepository(named: String, completion:@escaping () -> ()) {
        let urlString = "https://api.github.com/user/starred/\(named)?access_token=\(accessToken)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 204:
                    print("You have just unstarred this content")
                default:
                    print("UNSTAR: This is the default case")
                }
            }
            completion()
        }
        task.resume()
    }
}

