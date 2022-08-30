//
//  NetworkUtils.swift
//  PruebaAlbo
//
//  Created by Hector Climaco on 26/04/21.
//

import Foundation
import CommonCrypto
import SystemConfiguration

public class NetworkUtils {
    
    private static let timeOutInterval: Double = 60
    
    public static func createRequest(urlString: String?, HTTPMethod: HTTPMethod, body: String? =  nil) -> URLRequest?{
        
        var urlStr = Constants.baseURL
        
        if let url = urlString {
            urlStr += url
        }
        
       
        guard let urlConexion = URL(string: urlStr) else { return nil }
        
        var urlRequest = URLRequest(url: urlConexion)
        
        urlRequest.httpMethod = HTTPMethod.rawValue
        urlRequest.timeoutInterval = timeOutInterval
        if let dataBody = body {
            urlRequest.httpBody =  dataBody.data(using: String.Encoding.utf8)
        }
        
        return urlRequest
    }
    
    
}
