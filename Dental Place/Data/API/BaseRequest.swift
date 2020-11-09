//
//  BaseRequest.swift
//  Dental Place
//
//  Created by Quang Pham on 8/10/20.
//  Copyright © 2020 eWeb. All rights reserved.
//



import Alamofire

let baseURL: String = "https://portal.dentalplace.app/dental_place_api/public/api"

class BaseRequest<T: ParametersInput, R> {
    let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
}

class BaseServiceFactory {
    func urlRequest(path: String, method: HTTPMethod) -> URLRequest {
        let url = URL(string: baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}



struct ErrorModel: Error {
    let error: Error
}

class BaseManagerAPI {
    let sessionManager: SessionManager
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: configuration)
    }
    
    // MARK: - Public
    
    @discardableResult
    func run<T: ParametersInput, R: Codable>(request: BaseRequest<T, R>,
                                                         input: T? = nil,
                                                         completionHandler: @escaping (APIResponseResult<R>) -> Void)
        -> DataRequest {
            var executableRequest: URLRequest
            if let input = input, let httpMethod = HTTPMethod(rawValue: request.request.httpMethod ?? "") {
                
                do {
                    switch httpMethod {
                    case .get:
                        let queryEncoding = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets)
                        executableRequest = try queryEncoding.encode(request.request, with: input.toJSON())
                    case .connect, .delete, .head, .options, .patch, .post, .put, .trace:
                        executableRequest = try Alamofire.JSONEncoding.default.encode(request.request, with: input.toJSON())
                    }
                } catch {
                    executableRequest = request.request
                }
                
            } else {
                executableRequest = request.request
            }
            
            let request = sessionManager.request(executableRequest)
                .responseJSON { [weak self] response in
                    debugPrint("...Debug API: ", response)
                    var apiResult: APIResponseResult<R>
                    guard let data = response.data else {
                        apiResult = .failure(BaseErrorModel.defaultError)
                        return completionHandler(apiResult)
                    }
                    
                    if let error = self?.parsedError(data: data) {
                        apiResult = .failure(error)
                    } else {
                        do {
                            let decoder = JSONDecoder()
                            let output = try decoder.decode(R.self, from: data)
                            apiResult = .success(output)
                        } catch {
                            apiResult = .failure(BaseErrorModel.defaultError)
                        }
                    }
                    completionHandler(apiResult)
                }
            return request
    }
    
    private func parsedError(data: Data?) -> BaseErrorModel? {
        guard let data = data else {
            return nil
        }
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                var errorMessage: String?
                if let dataErrors = jsonObject["data"] as? [String: Any], let errorDict = dataErrors["messages"] as? [String: String] {
                    var errorString = ""
                    for error in errorDict.values {
                        errorString += "\(error)\n"
                    }
                    errorMessage = errorString
                } else if let error = jsonObject["error"] as? String {
                    errorMessage = error
                }
                if let error = errorMessage {
                    return BaseErrorModel(errorString: error)
                }
            }
            return nil
        } catch {
            return nil
        }
    }
    
    
}

enum APIResponseResult<Value> {
    
    case success(Value)
    
    case failure(BaseErrorModel)
    
}

class PublicManagerAPI: BaseManagerAPI {
    static let sharedInstance = PublicManagerAPI()
    
    private override init() {
        super.init()
    }
}

class PrivateManagerAPI: BaseManagerAPI {
    static let sharedInstance = PrivateManagerAPI()
    private override init() {
        super.init()
        let headerAdapter = BaseRequestAdapter()
        sessionManager.adapter = headerAdapter

    }
}

class BaseRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        var deviceToken = "123456"
        if let device = DEFAULT.value(forKey: "DEVICETOKEN") as? String
        {
            deviceToken = device
        }
        let apiKey = "1234"
        urlRequest.setValue(deviceToken, forHTTPHeaderField: "device-id")
        urlRequest.setValue("iOS", forHTTPHeaderField: "device-type")
        urlRequest.setValue("iOS", forHTTPHeaderField: "type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "api-token")
        
        
        return urlRequest
    }
}

