//
//  URLBuilder.swift
//  Movieisme_13_M
//
//  Created by Yousra Abdelrahman on 14/07/1447 AH.
//
import Foundation

struct URLBuilder {
    static func makeURL(for endpoint: Endpoint) -> URL? {
        var components = URLComponents()
        components.scheme = APIConfig.scheme
        components.host = APIConfig.host
        components.path = endpoint.path
        //Include query items
        components.queryItems = endpoint.queryItems
        
        return components.url
    }
}

