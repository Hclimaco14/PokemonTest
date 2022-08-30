//
//  ServicesManager.swift
//  PruebaAlbo
//
//  Created by Hector Climaco on 26/04/21.
//

import Foundation
import CoreLocation


public enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

public struct RequestError: Error {
    let statusCode: Int
    let description: String
    var data: Data?
}

protocol ServiceMaganerProtocol {
    func fetchRequest<T: Codable>(with request: URLRequest,
                                         completion: @escaping(Result<T, RequestError>) -> Void)
    func fetchRequest<T: Codable>(with request: URL,
                                         completion: @escaping(Result<T, RequestError>) -> Void)
    func getError(response: URLResponse, data: Data) -> RequestError
}

extension ServiceMaganerProtocol {
    
    func getError(response: URLResponse, data: Data) -> RequestError {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return RequestError(statusCode: 00, description: "Error getting description of server error.")
        }
        
        switch httpResponse.statusCode {
        case 400:
            return RequestError(statusCode: 400, description: "Invalid Request", data: data)
        case 401:
            return RequestError(statusCode: 401, description: "Unauthorized", data: data)
        case 404:
            return RequestError(statusCode: 404, description: "Not found", data: data)
        case 500:
            return RequestError(statusCode: 500, description: "Server unavailable", data: data)
        default:
            return RequestError(statusCode: 00, description: "Tuvimos un problema, vuelve a intentarlo más tarde", data: data)
        }
    }
}

class ServicesManager: ServiceMaganerProtocol {
    
    private let session = URLSession.shared
    private static let share = ServicesManager()
    private var retries = 0
    private let retryLimit = 3

    
    public func fetchRequest<T: Codable>(with request: URLRequest,
                                         completion: @escaping(Result<T, RequestError>) -> Void) {
        
        self.session.dataTask(with: request, completionHandler: { data, response, error in
            
            //MARK: validated error
            if let err = error {
                let nsError = err as NSError
                let possibleInternetErrors = [
                    NSURLErrorNotConnectedToInternet,
                    NSURLErrorNetworkConnectionLost,
                    NSURLErrorCannotConnectToHost,
                    NSURLErrorCannotFindHost,
                ]
                if possibleInternetErrors.contains(nsError.code) && self.retries < self.retryLimit {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        ServicesManager.share.fetchRequest(with: request, completion: completion)
                    }
                } else {
                    completion(.failure(RequestError(statusCode: nsError.code, description: nsError.description, data: data)))
                }
                
            }
            
            guard let response = response, let data = data else {
                return completion(.failure(
                    RequestError(statusCode: 0, description: "Error desconocido", data: data))
                )
            }
            
            //MARK: validated response
            guard let httpResp = response as? HTTPURLResponse,
            (200...299).contains(httpResp.statusCode) else {
                completion(.failure(self.getError(response: response, data: data)))
                return
            }
            
            if let respData = Mapper<T>().map(object: data) {
                completion(.success(respData))
            } else {
                completion(.failure(
                    RequestError( statusCode: 0,description: "Error in decoder", data: data))
                )
            }
            
        }).resume()
    }
    
    public func fetchRequest<T: Codable>(with request: URL,
                                         completion: @escaping(Result<T, RequestError>) -> Void) {
        
        self.session.dataTask(with: request, completionHandler: { data, response, error in
            
            //MARK: validated error
            if let err = error {
                let nsError = err as NSError
                let possibleInternetErrors = [
                    NSURLErrorNotConnectedToInternet,
                    NSURLErrorNetworkConnectionLost,
                    NSURLErrorCannotConnectToHost,
                    NSURLErrorCannotFindHost,
                ]
                if possibleInternetErrors.contains(nsError.code) && self.retries < self.retryLimit {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        ServicesManager.share.fetchRequest(with: request, completion: completion)
                    }
                } else {
                    completion(.failure(RequestError(statusCode: nsError.code, description: nsError.description, data: data)))
                }
                
            }
            
            guard let response = response, let data = data else {
                return completion(.failure(
                    RequestError(statusCode: 0, description: "Error desconocido", data: data))
                )
            }
            
            //MARK: validated response
            guard let httpResp = response as? HTTPURLResponse,
            (200...299).contains(httpResp.statusCode) else {
                completion(.failure(self.getError(response: response, data: data)))
                return
            }
            
            if let respData = Mapper<T>().map(object: data) {
                completion(.success(respData))
            } else {
                completion(.failure(
                    RequestError( statusCode: 0,description: "Error in decoder", data: data))
                )
            }
            
        }).resume()
    }
    
}


class MockServiceManager: ServiceMaganerProtocol {
    
    var name: String
    
    public init(nameFile:String) {
        self.name = nameFile
    }
    
    func fetchRequest<T>(with request: URLRequest, completion: @escaping (Result<T, RequestError>) -> Void) where T : Decodable, T : Encodable {
        
        var error = RequestError( statusCode: 0,description: "Error in decoder", data: nil)
        
        do {
            if let bundlePath = Bundle.main.path(forResource: name,ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: bundlePath), options: .mappedIfSafe)
                
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                guard let resonse = Mapper<T>().map(object: jsonResult) else {
                    error.data = data
                    return completion(.failure(error))
                }
                return completion(.success(resonse))
            }
            
        } catch {
            return completion(.failure(error as! RequestError))
        }
        
        return completion(.failure(error))
        
    }
    
    func fetchRequest<T>(with request: URL, completion: @escaping (Result<T, RequestError>) -> Void) where T : Decodable, T : Encodable {
        
        var error = RequestError( statusCode: 0,description: "Error in decoder", data: nil)
        
        do {
            DispatchQueue.main.async {
                
                
                if let bundlePath = Bundle.main.path(forResource: name,ofType: "json") {
                    let data = try Data(contentsOf: URL(fileURLWithPath: bundlePath), options: .mappedIfSafe)
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    
                    guard let resonse = Mapper<T>().map(object: jsonResult) else {
                        error.data = data
                        return completion(.failure(error))
                    }
                    return completion(.success(resonse))
                }
                
            }
            
        } catch {
            return completion(.failure(error as! RequestError))
        }
        
        return completion(.failure(error))
        
    }
    
}
