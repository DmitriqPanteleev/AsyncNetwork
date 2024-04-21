//
//  RequestFormatter.swift
//
//
//  Created by Дмитрий Пантелеев on 03.03.2024.
//

import Foundation

struct RequestFormatter {
    
    func build(from endpoint: RequestEndpoint,
               cachePolicy: RequestCachePolicy,
               timeoutInterval: TimeInterval,
               extraHeaders: RequestHeaders) throws -> URLRequest
    {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme.rawValue
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.port = endpoint.port
        
        buildQuery(with: endpoint.query, for: &urlComponents)
        
        guard let url = urlComponents.url else { throw NetworkError.invalidUrl(endpoint) }
        
        var request = URLRequest(url: url,
                                 cachePolicy: cachePolicy,
                                 timeoutInterval: timeoutInterval)
        
        request.httpMethod = endpoint.method.rawValue
        
        buildHeaders(with: endpoint.headers, extra: extraHeaders, for: &request)
        
        if let data = endpoint.fileData {
            MultipartFormBuilder.build(&request, with: data)
        } else {
            try buildBody(with: endpoint.body, for: &request)
        }
        
        return request
    }
}

private extension RequestFormatter {
    func buildQuery(with query: RequestQuery?, for components: inout URLComponents) {
        guard let dictionary = query else { return }
        
        components.percentEncodedQueryItems = []
        
        for query in dictionary {
            let encodedValue = query.value.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
            components.percentEncodedQueryItems?.append(URLQueryItem(name: query.key, value: encodedValue))
        }
    }
    
    func buildBody(with dictionary: DynamicDictionary?, for request: inout URLRequest) throws {
        guard let body = dictionary else { return }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            throw NetworkError.encode(error)
        }
    }
    
    func buildHeaders(with headers: RequestHeaders?,
                      extra: RequestHeaders,
                      for request: inout URLRequest)
    {
        guard let headers = headers else {
            request.allHTTPHeaderFields = extra
            return
        }
        
        let mergedHeaders = headers.merging(extra) { inner, _ in inner }
        request.allHTTPHeaderFields = mergedHeaders
    }
}
