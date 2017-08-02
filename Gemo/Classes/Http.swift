import Foundation

// MARK: -  HTTP Methods

public enum Method: string {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}


// MARK: - Http Main class

internal final class Http {
    
    /*fileprivate static var boundary = "", boundaryPrefix = ""
    //private static var multipart = MultiPart()
    
    private init() {
        Http.boundary = "Boundary-\(UUID().uuidString)"
        Http.boundaryPrefix = "--\(Http.boundary)\r\n"
    }*/
    
    
    internal func request(link: string, method: Method, parameters: [string: any] = [:]) -> Response {
        if (link.isEmpty || !link.isLink) {
            print("requested link \(link)")
            return Response(request: nil, error: NSError(domain: "Invalid Link", code: 1221, userInfo: nil))
        }
        guard let url = URL(string: link) else {
            return Response(request: nil, error: NSError(domain: "Invalid URL", code: 2112, userInfo: nil))
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if (method == .post) {
            var params = string.empty
            parameters.forEach { params += "\($0)=\($1)&" }
            request.httpBody = params.substring(to: params.index(params.endIndex, offsetBy: -1)).data(using: .utf8)
        }
        return Response(request: request, error: nil)
    }
    
    
    /// Using multipart
    /*public static func upload(fileWith paramaters: Dictionary<string, any> , to link: string)-> Response {
        if (link.isEmpty || !link.isLink) {
            return Response(request: nil, error: NSError(domain: "Invalid Link", code: 1221, userInfo: nil))
        }
        guard let url = URL(string: link) else {
            return Response(request: nil, error: NSError(domain: "Invalid URL", code: 2112, userInfo: nil))
        }
        var request = URLRequest(url: url)
        request.httpMethod = Method.post.rawValue
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = setUploadBody(parameters: paramaters, boundary: boundary)
        return Response(request: request, error: nil)
    }
    
    
    private class func setUploadBody(parameters: [string: any], boundary: String) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        for (key, value) in parameters {
            if (value is Data) {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(NSUUID().uuidString)\"\r\n")//
                body.appendString("Content-Type: \("image/png")\r\n\r\n")
                body.append(value as! Data)
            } else {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
            body.appendString("\r\n")
            body.appendString("--".appending(boundary.appending("--")))
        }
        
        return body as Data
    }*/
}



// MARK: -  Response use it to make request and catch response

public final class Response {
    
    private let session = URLSession.shared
    internal var request: URLRequest?, error: Error?
    
    internal init(request: URLRequest?, error: Error?) {
        self.request = request
        self.error = error
    }
    
    
    internal func response(_ responseResult: @escaping(_ response: ResponseResult)->())-> void {
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
                print("catched error")
                responseResult(ResponseResult(nil, resInfo, catchError, jsonString))
            }
            
            }.resume()
    }
}


// MARK: -  Response result 

/// use it to catch requst result in it
internal final class ResponseResult {
    
    public var error: Error?, response: URLResponse?, result: any?, jsonString: string?

    
    init(_ result: any?, _ response: URLResponse?, _ error: Error?, _ json: string? = nil) {
        self.result = result
        self.response = response
        self.error = error
        self.jsonString = json
    }
    
}




public extension NSMutableData {
    
    /*public func add(key: string, value: any)-> void {
     append(Http.boundaryPrefix.toData)
     append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".toData)
     append("\(value)\r\n".toData)
     }
     
     public func add(key: string, data: Data, filename: string, mimeType: string) -> void {
     append(Http.boundaryPrefix.toData)
     append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".toData)
     append("Content-Type: \(mimeType)\r\n\r\n".toData)
     append(data)
     append("\r\n".toData)
     append("--".appending(Http.boundary.appending("--")).toData)
     }*/
    
    public func appendString(_ str: string)-> void  {
        append(str.toData)
    }
    
}































