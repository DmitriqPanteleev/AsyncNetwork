//
//  Refresher.swift
//
//
//  Created by Дмитрий Пантелеев on 03.03.2024.
//

import Foundation

actor Refresher {
    // MARK: Delegating
    private weak var service: AsyncNetworkable?
    
    // MARK: Internal
    private var refreshTask: Task<Data, Error>?
    private var continuation: RefreshStream.Continuation?
    
    // MARK: External
    private var options: RefreshOptions
    
    init(service: AsyncNetworkable?, options: RefreshOptions, continuation: RefreshStream.Continuation?) {
        self.service = service
        self.options = options
        self.continuation = continuation
    }
    
    func refresh() async throws {
        if let refreshTask = refreshTask {
            continuation?.yield(try await refreshTask.value)
            try await Task.sleep(nanoseconds: options.timeoutInterval)
            
            return
        }
        
        let task = Task { () throws -> Data in
            defer {
                options.repeatsCount -= 1
                refreshTask = nil
            }
            
            guard let data = try await service?.sendRequest(with: options.endpoint) else {
                throw NetworkError.transport(options.endpoint)
            }
            
           return data
        }
        
        self.refreshTask = task
        continuation?.yield(try await task.value)
        
        try await Task.sleep(nanoseconds: options.timeoutInterval)
    }
}
