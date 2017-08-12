import Foundation
import UIKit

// MARK: -  HTTP Methods
public typealias Paramters = [string: any]
public enum Method: string {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

// MARK:- Encoding Type

public enum EncodingType {
    case `default`, Json
}


// MARK: - Http Main class

internal final class Http {
 
    
    internal func request(link: string, method: Method, parameters: Paramters = [:], encoding: EncodingType = .default) -> Response {
        if (link.isEmpty || !link.isLink) {
            NSLog("requested link \(link)")
            return Response(request: nil, error: NSError(domain: "Invalid Link", code: 1221, userInfo: nil))
        }
        guard let url = URL(string: link) else {
            return Response(request: nil, error: NSError(domain: "Invalid URL", code: 2112, userInfo: nil))
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var body: Data?
        if (method == .post) {
            switch (encoding) {
            case .default:
                var params = string.empty
                parameters.forEach { params += "\($0)=\($1)&" }
                body = params.substring(to: params.index(params.endIndex, offsetBy: -1)).data(using: .utf8)
                
            case .Json:
                
                do {
                    body = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    //NSLog("catched error when try to send json paramters is: \(error)")
                    return Response(request: nil, error: error)
                }
            }
            request.httpBody = body
        }
        return Response(request: request, error: nil)
    }
    
    
    /// Using multipart
    internal func upload(from paramters: Paramters?, and media: ()->[Media]?, to link: string) -> Response {
        if (link.isEmpty || !link.isLink) {
            return Response(request: nil, error: NSError(domain: "Invalid Link", code: 1221, userInfo: nil))
        }
        guard let url = URL(string: link) else {
            return Response(request: nil, error: NSError(domain: "Invalid URL", code: 2112, userInfo: nil))
        }
        var request = URLRequest(url: url)
        request.httpMethod = Method.post.rawValue
        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createUploadBody(with: paramters, media: media(), boundary: boundary)
        return Response(request: request, error: nil)
    }
    
    private func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    private func createUploadBody(with paramters: Paramters?, media: [Media]?, boundary: string) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let params = paramters {
            for (key, value) in params {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        if let photos = media {
            for photo in photos {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimtype + lineBreak + lineBreak)")
                body.append(photo.imageData)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    

}



// MARK: -  Response use it to make request and catch response

public final class Response {
    
    private let session = URLSession.shared
    internal var request: URLRequest?, error: Error?
    
    internal init(request: URLRequest?, error: Error?) {
        self.request = request
        self.error = error
    }
    
    
    public func response(_ responseResult: @escaping(_ response: ResponseResult)->())-> void {
        guard let req = request else {
            responseResult(ResponseResult(nil, nil, error))
            return
        }
        session.dataTask(with: req) { (data, resInfo, err) in
            if (err != nil) {
                responseResult(ResponseResult(nil, resInfo, err))
                return
            }
            guard let jsonData = data else {
                responseResult(ResponseResult(nil, resInfo, err))
                return
            }
            let jsonString = String(data: jsonData, encoding: .utf8)
            do {
                responseResult(
                    ResponseResult(try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments),
                                   resInfo,
                                   nil,
                                   jsonString)
                )
            } catch let catchError {
                //NSLog("catched error")
                responseResult(ResponseResult(nil, resInfo, catchError, jsonString))
            }
            
            }.resume()
    }
}


// MARK: -  Response result 

/// use it to catch requst result in it
public final class ResponseResult {
    
    public var error: Error?, response: URLResponse?, result: any?, jsonString: string?
    
    public init(_ result: any?, _ response: URLResponse?, _ error: Error?, _ json: string? = nil) {
        self.result = result
        self.response = response
        self.error = error
        self.jsonString = json
    }
    
}



// MARK:- Media 

public struct Media {
    
    public let key, filename, mimtype: string, imageData: Data
    
    init(key: string, mimtype: string, imageData: Data) {
        self.key = key
        self.mimtype = mimtype
        self.imageData = imageData
        self.filename = "\(Date.timeIntervalSinceReferenceDate).\(mimtype.components(separatedBy: "/").last ?? "png")"
    }
    
    
    
    
}


// MARK:-  Data extension

fileprivate extension Data {
    
    fileprivate mutating func append(_ value: string) {
        guard let data = value.data(using: .utf8) else { return }
        append(data)
    }
}

























