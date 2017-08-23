//
//  Client.swift
//  AntavoSDK
//
//  Copyright © 2017 Antavo Ltd. All rights reserved.
//

import Alamofire

// MARK: AntavoSDKClient
open class ANTClient: NSObject {
    /**
     Specifies Antavo base API url.
     */
    fileprivate let baseURL = "https://api-apps-rc.antavo.com"
    
    /**
     Specifies Antavo Events API url.
     */
    fileprivate let eventsApiURL = "https://api-apps-rc.antavo.com/events"
    
    /**
     Stores internally the API authorization key.
     */
    fileprivate var apiKey: String
    
    /**
     Converts request URLs to an URL object.
    
     - Parameter url: request url to convert
     */
    open func prepareUrl(_ url: String) -> URL {
        return URL(string: self.baseURL + url)!
    }
    
    /**
     Initializes the SDK Client object with the given API key.
     
     - Parameter apiKey: Antavo API key.
     */
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /**
     Returns an array with prepared request parameters.
     */
    open func prepareParameters(_ parameters: [String: Any]) -> [String: Any] {
        var result = parameters
        result["api_key"] = self.apiKey
        return result
    }
    
    /**
     Returns an array of NSLocalizedDescriptionKey objects for NSError handler.
     
     - Parameter value: Error message as string.
     */
    open func getLocalizedDescription(value: String) -> [AnyHashable: Any] {
        return [
            NSLocalizedDescriptionKey: NSLocalizedString("ANTClient Error", value: value, comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("ANTClient Error", value: value, comment: "")
        ]
    }
    
    /**
     Returns an NSError object with error code and localized error descriptions.
     
     - Parameter code: Error code specified as integer.
     - Parameter value: Error message specified as string.
     */
    open func createClientError(code: Int, value: String) -> NSError {
        return NSError(
            domain: "AntavoSDKANTClient",
            code: code,
            userInfo: self.getLocalizedDescription(value: value)
        )
    }
    
    /**
     Performs a GET request to the specified URL with given parameters.
     
     - Parameter url: Relative URL to the base API URL.
     - Parameter parameters: Request query parameters as associative collection.
     */
    open func get(_ url: String, parameters: [String: Any] = [:], completionHandler: @escaping (NSDictionary?, Error?) -> ()) {
        Alamofire
            .request(self.prepareUrl(url), method: .get, parameters: self.prepareParameters(parameters))
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
                        if let result = value as? NSDictionary {
                            if let errorObject = result.object(forKey: "error") {
                                var errorMessage = "Unexpected error message"
                                var errorCode = 3000
                                
                                // Defining an error message for NSError object.
                                if let errors = errorObject as? NSDictionary {
                                    errorMessage = errors.object(forKey: "message") as! String
                                    errorCode = errors.object(forKey: "code") as! Int
                                }
                                
                                completionHandler(nil, self.createClientError(code: errorCode, value: errorMessage))
                            } else {
                                completionHandler(result, nil)
                            }
                        } else if let result = value as? NSArray {
                            let dictionary: NSMutableDictionary = NSMutableDictionary()
                            dictionary.setObject(result, forKey: "data" as NSCopying)
                            
                            completionHandler(dictionary, nil)
                        } else {
                            completionHandler(nil, self.createClientError(code: 3001, value: "Non parsable API response"))
                        }
                    case .failure(let error):
                        completionHandler(nil, error)
                }
        }
    }
    
    /**
     Performs a POST request to the specified URL with given parameters.
     
     - Parameter url: Relative URL to the base API URL.
     - Parameter parameters: Request body parameters as associative collection.
     */
    open func post(_ url: String, parameters: [String: Any] = [:], completionHandler: @escaping (NSDictionary?, Error?) -> ()) {
        Alamofire
            .request(self.prepareUrl(url), method: .post, parameters: self.prepareParameters(parameters))
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let result = value as? NSDictionary {
                        if let errorObject = result.object(forKey: "error") {
                            var errorMessage = "Unexpected error message"
                            var errorCode = 3000
                            
                            // Defining an error message for NSError object.
                            if let errors = errorObject as? NSDictionary {
                                errorMessage = errors.object(forKey: "message") as! String
                                errorCode = errors.object(forKey: "code") as! Int
                            }
                            
                            completionHandler(nil, self.createClientError(code: errorCode, value: errorMessage))
                        } else {
                            completionHandler(result, nil)
                        }
                    } else if let result = value as? NSArray {
                        let dictionary: NSMutableDictionary = NSMutableDictionary()
                        dictionary.setObject(result, forKey: "data" as NSCopying)
                        
                        completionHandler(dictionary, nil)
                    } else {
                        completionHandler(nil, self.createClientError(code: 3001, value: "Non parsable API response"))
                    }
                case .failure(let error):
                    completionHandler(nil, error)
                }
            }
    }
    
    /**
     Performs a POST request through the Antavo Events API.
     
     - Parameter action: Denotes an existing factory or custom action name.
     - Parameter customer: A customer object with a unique customer ID either matching an existing customer in Antavo.
     - Parameter parameters: Event data parameters as associative collection.
     */
    open func postEvent(_ action: String, customer: ANTCustomer, parameters: [String: Any] = [:], completionHandler: @escaping (NSDictionary?, Error?) -> ()) {
        // Appending given action and customer's id to the request parameters.
        var request: [String: Any] = [:]
        request["action"] = action
        request["customer"] = customer.id
        request["data"] = parameters
        
        self.post("/events", parameters: self.prepareParameters(request), completionHandler: completionHandler)
    }
}
