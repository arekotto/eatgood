//
//  ImageRetriever.swift
//  Eat Good
//
//  Created by Arek Otto on 12/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation
import UIKit

class ImageRetriever: RequestSubmitter {
    
    convenience init() {
        self.init(session: URLSession.shared)
    }
    
    func retrieveImage(urlString: String, completion: @escaping (_: UIImage?) -> Void) {
        submitRequest(URLRequest(url: URL(string: urlString)!)) { data in
            completion(data != nil ? UIImage(data: data!) : nil)
        }
    }
}
