//
//  ToiletAPI.swift
//  Toilets
//
//  Created by Muhammad Mehdi Raza on 6/5/20.
//  Copyright © 2020 Muhammad Mehdi Raza. All rights reserved.
//

import Foundation

final class ToiletAPI{
    
    static let shared = ToiletAPI() 
    
    func fetchToiletList(onCompletion: @escaping ([Toilet]) -> () ){
        let urlString = "https://data.melbourne.vic.gov.au/resource/ru3z-44we.json"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url){ (data, resp, error) in
            
            
            guard let data = data else{
                print("data was nil")
                    return
            }
       
            guard let toiletList : [Toilet] = try? JSONDecoder().decode([Toilet].self, from: data) else {
                print ("Couldn't decode JSON")
                return
            }
            onCompletion(toiletList)
        }
        
        task.resume()
    }
}

struct Toilet : Codable{
    let name: String
    let female: String?
    let male: String?
    let wheelchair: String?
    let `operator`: String
    let baby_facil: String
    let lat: String
    let lon: String
}

/*
 {
     "name":"Public Toilet - Toilet 140 - Queensberry Street (Opposite 286 Queensberry Street)",
     "female":"no",
     "male":"yes",
     "wheelchair":"no",
     "operator":"City of Melbourne",
     "baby_facil":"no",
     "lat":"-37.8039946349673",
     "lon":"144.95909066756946"
 
 }
 */
