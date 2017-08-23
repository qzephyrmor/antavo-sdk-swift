//
//  SDK.swift
//  AntavoSDK
//
//  Copyright © 2017 Antavo Ltd. All rights reserved.
//

import Alamofire

// MARK: Antavo Loyalty Swift SDK core object.
open class AntavoSDK: NSObject {
    /**
     Possibility to generalize SDK initialization; make sure that SDK is 
     initialized only once.
     */
    static let get = AntavoSDK()
    
    /**
     A valid API key issued by Antavo. All requests with invalid API key will 
     result in an error and the request to fail.
     */
    fileprivate var apiKey: String
    
    /**
     Cached REST client for communicating with Antavo API.
     */
    fileprivate var client: ANTClient?
    
    /**
     Stores the initialized Antavo Customer object.
     */
    fileprivate var customer: ANTCustomer?
    
    /**
     Returns a simplified settings object with only the brand setting key and value.
     */
    fileprivate var settings: [String: Any]?
    
    /**
     Stores an EventManager instance in SDK.
     */
    fileprivate let eventManager: ANTEventManager = ANTEventManager()
    
    /**
     Returns the stored EventManager instance.
     */
    open func getEventManager() -> ANTEventManager {
        return self.eventManager
    }
    
    /**
     Returns the stored valid API key issued by Antavo. All requests with invalid
     API key will result in an error and the request to fail.
     */
    open func getApiKey() -> String {
        return self.apiKey
    }
    
    /**
     Explicitly set the stored Antavo API key. 
     Note that you need to reinitialize SDK to make changes on REST client too.
     */
    open func setApiKey(_ apiKey: String) {
        self.apiKey = apiKey
    }
    
    /**
     Returns the cached REST client for communicating with Antavo API.
     */
    open func getClient() -> ANTClient {
        if let client = self.client {
            return client
        }
        
        self.client = ANTClient(apiKey: self.getApiKey())
        return self.client!
    }
    
    /**
     Mechanism for fetching initialized brand settings.
     */
    open func getSettings(completionHandler: @escaping (NSDictionary?, Error?) -> ()) {
        self.getClient().get("/settings", completionHandler: completionHandler)
    }
    
    /**
     Returns the current customer object cached in self::customer.
     */
    open func getAuthenticatedCustomer() throws -> ANTCustomer {
        if let customer = self.customer {
            return customer
        }
        
        throw ANTException.runtimeError("No authenticated customer found")
    }
    
    /**
     Implicitly sets the authenticated customer object into SDK.
     */
    open func setAuthenticationCustomer(customer: ANTCustomer) {
        self.customer = customer
    }
    
    /**
     Authenticates a loyalty customer for a SDK session.
     
     - Parameter customerId: Customer's unique identifier as string.
     */
    open func authenticateCustomer(_ customerId: String, completionHandler: @escaping (ANTCustomer?, Error?) -> ()) {
        self.getCustomer(customerId) { response, error in
            if let customer = response {
                self.setAuthenticationCustomer(customer: customer)
                
                self.getEventManager().trigger(eventName: "customerAuthenticated", data: customer)
            }
            
            completionHandler(response, error)
        }
    }

    /**
     Returns a loyalty customer by given customer id.
     
     - Parameter customerId: Customer unique identifier.
     */
    open func getCustomer(_ customerId: String, completionHandler: @escaping (ANTCustomer?, Error?) -> ()) {
        self.getClient().get("/customers/" + customerId) { response, error in
            if let result = response {
                completionHandler(ANTCustomer().assign(data: result), error)
            } else {
                completionHandler(nil, error)
            }

        }
    }
    
    /**
     Registers a loyalty customer through the Antavo API.
     
     - Parameter customerId: Customer unique identifier.
     - Parameter properties: Customer properties as associative collection.
     */
    open func registerCustomer(_ customerId: String, properties: [String: Any] = [:], completionHandler: @escaping (ANTCustomer?, Error?) -> ()) {
        // Preparing a new customer object.
        let customer: ANTCustomer = ANTCustomer()
        customer.id = customerId
        
        self.getClient().postEvent("opt_in", customer: customer, parameters: properties) { response, error in
            if let customer = response {
                completionHandler(ANTCustomer().assign(data: customer), error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    /**
     Sends an event to the Antavo API endpoint.
     
     - Parameter action: Action name.
     - Parameter parameters: Custom data (key-value pairs) to store with the event.
     */
    open func sendEvent(_ action: String, parameters: [String: Any] = [:], completionHandler: @escaping (NSDictionary?, Error?) -> ()) throws {
        try self.getClient().postEvent(
            action,
            customer: self.getAuthenticatedCustomer(),
            parameters: parameters,
            completionHandler: completionHandler
        )
    }
    
    /**
     Mechanism for fetching a reward entry by specified identifier from Antavo API.
     
     - Parameter rewardId: Reward's unique identifier.
     */
    open func getReward(_ rewardId: String, completionHandler: @escaping (ANTReward?, Error?) -> ()) {
        self.getClient().get("/rewards/\(rewardId)") { response, error in
            if let result = response {
                completionHandler(ANTReward().assign(data: result), error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    /**
     Mechanism for fetching all rewards from Antavo API.
     
     - Parameter completionHandler: A completion handler function that will be 
       invoked after fetching data from API endpoint.
     */
    open func getRewards(completionHandler: @escaping ([ANTReward]?, Error?) -> ()) {
        self.getClient().get("/rewards") { response, error in
            if let result = response {
                var rewards: [ANTReward] = []
                
                if let rewardObjects = result.object(forKey: "data") as? NSArray {
                    for rewardObject in rewardObjects {
                        if let data = rewardObject as? NSDictionary {
                            rewards.append(ANTReward().assign(data: data))
                        }
                    }
                }
                
                completionHandler(rewards, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    /**
     Mechanism for claiming a reward in Antavo.
     
     - Parameter rewardId: Reward's unqiue identifier.
     - Parameter parameters: Custom data (key-value pairs) to store with the event.
     */
    open func claimReward(rewardId: String, parameters: [String: Any] = [:], completionHandler: @escaping (NSDictionary?, Error?)  -> ()) throws {
        var request: [String: Any] = [:]
        request["customer"] = try self.getAuthenticatedCustomer().id!
        
        self.getClient().post(
            "/rewards/\(rewardId)/claim",
            parameters: request,
            completionHandler: completionHandler
        )
    }
    
    /**
     Initializes the Swift SDK with the given API key.
     
     - Parameter apiKey: Antavo API key.
     */
    public init(apiKey: String = "") {
        self.apiKey = apiKey
        
        super.init()
        
        self.getEventManager().trigger(eventName: "init")
    }
    
    /**
     Reinitializes the Swift SDK with the given API key.
     
     - Parameter apiKey: Antavo API key.
     */
    open func reinitialize(_ apiKey: String) -> AntavoSDK {
        self.apiKey = apiKey
        self.client = ANTClient(apiKey: self.getApiKey())
        
        self.getEventManager().trigger(eventName: "init")
        
        return self
    }
}
