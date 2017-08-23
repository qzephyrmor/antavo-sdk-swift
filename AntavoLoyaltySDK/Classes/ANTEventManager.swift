//
//  ANTEventManager.swift
//  AntavoSDK
//
//  Copyright © 2017 Antavo Ltd. All rights reserved.
//

// MARK: Antavo Event Manager instance.
open class ANTEventManager {
    /**
     Storing event listeners in NSMutableArray.
     */
    var listeners = Dictionary<String, NSMutableArray>()
    
    /**
     Creates a new event listener, not expecting information from the initator.
     
     - Parameter eventName: Matching trigger eventNames will cause this listener to fire.
     - Parameter action: The block of code you want executed when event triggers.
     */
    open func listenTo(eventName:String, action: @escaping (()->())) {
        addListener(eventName: eventName, listener: ANTEventManangerAction(callback: action))
    }
    
    /**
     Creates a new event listener, expecting information from the trigger.
     
     - Parameter eventName: Matching trigger eventNames will cause this listener to fire.
     - Parameter action: The block of code you want executed when event triggers.
     */
    open func listenTo(eventName:String, action: @escaping ((Any?)->())) {
        addListener(eventName: eventName, listener: ANTEventManangerAction(callback: action))
    }
    
    /**
     Creates a listener for a specified event name.
     
     - Parameter eventName: Matching trigger eventNames will cause this listener to fire.
     - Parameter listener: The ANTEventManagerAction object which listens to events.
     */
    internal func addListener(eventName:String, listener: ANTEventManangerAction) {
        if let listeners = self.listeners[eventName] {
            listeners.add(listener)
        } else {
            self.listeners[eventName] = [listener] as NSMutableArray
        }
    }
    
    /**
     Removes all listeners by default, or specific listeners through parameters.
     
     - Parameter eventName: If an event name is passed, only listeners for that event will be removed.
     */
    open func removeListeners(eventName: String?) {
        if let event = eventName {
            if let actions = self.listeners[event] {
                actions.removeAllObjects()
            }
        } else {
            self.listeners.removeAll(keepingCapacity: false)
        }
    }
    
    /**
     Triggers an event by given event name.
     
     - Parameter eventName: Event name to trigger.
     - Parameter data: Data to transfer in any structure.
     */
    open func trigger(eventName:String, data: Any? = nil) {
        if let actions = self.listeners[eventName] {
            for action in actions {
                if let method = action as? ANTEventManangerAction {
                    if let callback = method.actionExpectsInfo {
                        callback(data)
                    } else if let callback = method.action {
                        callback()
                    }
                }
            }
        }
    }
}
