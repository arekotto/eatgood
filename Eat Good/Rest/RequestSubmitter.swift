//
//  RequestSubmitter.swift
//  Eat Good
//
//  Created by Arek Otto on 12/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation

class RequestSubmitter {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    
    func submitRequest(_ request: URLRequest, completion: @escaping (_ data: Data?) -> Void) {
        session.dataTask(with: request) { data, response, error in
            
            if error != nil && data == nil{
                print("Fundamental network error: \(String(describing: error))")
                completion(nil)
            } else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200  {
                print("StatusCode should be 200, but is \(httpStatus.statusCode)")
                print("response: \(String(describing: response))")
                print("body: \(String(data: data ?? Data(), encoding: .utf8) ?? "")")
                completion(nil)
            } else {
                completion(data!)
            }
            }.resume()
    }
        
    func submitRequest<T: Decodable>(_ request: URLRequest, parseTo parseType: T.Type, completion: @escaping (_ parsedObject: T?) -> Void) {
        submitRequest(request) { data in
            guard data != nil else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let result = try? decoder.decode(parseType, from: data!) {
                completion(result)
            } else {
                print("Request successfull, but failed parsing JSON: \(String(describing: String(data: data!, encoding: .utf8)))")
            }
        }
    }
}
