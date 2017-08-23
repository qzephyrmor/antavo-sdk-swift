//
//  Reward.swift
//  AntavoSDK
//
//  Copyright © 2017 Antavo Ltd. All rights reserved.
//

// MARK: Base Antavo Reward object.
open class ANTReward {
    /**
     Reward's unique identifier specified as string.
     */
    open var id: String?
    
    /**
     Reward's name specified as string or array of strings.
     */
    open var name: Any?
    
    /**
     Reward's description specified as string or array of strings.
     */
    open var description: Any?

    /**
     Reward's category specified as string.
     */
    open var category: String?
    
    /**
     Reward's price specified as integer or array of integers.
     */
    open var price: Any?
    
    /**
     Creates a new instance of Reward, and assigns the given properties to it.
     
     - Parameter data: Properties to assign as NSDictionary object.
     */
    open func assign(data: NSDictionary) -> ANTReward {
        let reward = ANTReward()
        
        if let id = data.object(forKey: "id") {
            reward.id = id as? String
        }
        
        if let name = data.object(forKey: "name") {
            reward.name = name
        }
        
        if let description = data.object(forKey: "description") {
            reward.description = description
        }
        
        if let category = data.object(forKey: "category") {
            reward.category = category as? String
        }
        
        if let price = data.object(forKey: "price") {
            reward.price = price
        }
        
        return reward
    }
}
