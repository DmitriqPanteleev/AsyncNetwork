import Foundation

// MARK: For request public API
public typealias DynamicDictionary = [String : Any]
public typealias RequestQuery = [String : String]
public typealias RequestHeaders = [String : String]
public typealias FileData = Data?

public typealias RequestCachePolicy = NSURLRequest.CachePolicy

// MARK: For response public API
public typealias Response = URLResponse
public typealias StatusCode = Int

// MARK: For service public API
public typealias ServicIdentifier = String

// MARK: For refresh public API
public typealias RefreshInterval = UInt64
public typealias RefreshStream = AsyncStream<Data>

// MARK: For logger public API
public typealias LogMessage = String
public typealias LoggerCompletion = (LogMessage) -> Void


// MARK: Internal names
typealias SessionResponse = (Data, Response)
typealias StatusCodes = ClosedRange<Int>

typealias MimeHexArray = [UInt8]
typealias Mime = String
typealias MimeSignature = (MimeHexArray, Mime)
