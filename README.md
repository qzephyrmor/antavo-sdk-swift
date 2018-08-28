# AntavoLoyaltySDK

[![CI Status](http://img.shields.io/travis/qzephyrmor/AntavoLoyaltySDK.svg?style=flat)](https://travis-ci.org/qzephyrmor/AntavoLoyaltySDK)
[![Version](https://img.shields.io/cocoapods/v/AntavoLoyaltySDK.svg?style=flat)](http://cocoapods.org/pods/AntavoLoyaltySDK)
[![License](https://img.shields.io/cocoapods/l/AntavoLoyaltySDK.svg?style=flat)](http://cocoapods.org/pods/AntavoLoyaltySDK)
[![Platform](https://img.shields.io/cocoapods/p/AntavoLoyaltySDK.svg?style=flat)](http://cocoapods.org/pods/AntavoLoyaltySDK)

## Overview

The Antavo Loyalty Swift SDK makes it easy for mobile developers to build Antavo-powered applications. With the Swift SDK you can leverage the power of Antavo API functionality.

There are many resources to help you build your first loyalty application with the Swift SDK:

- Read the [Readme](README.md)
- Browse the [Documentation](https://antavo.com)

## Requirements

- iOS 9.0+
- Xcode 8.0+
- Swift 3.0+
- Alamofire 4.4+

## Installation

### Installing dependencies

We recommend using CocoaPods to manage dependencies and build the Swift SDK for your application.

You can install CocoaPods with:

```bash
$ sudo gem install cocoapods
```

To use Swift SDK in your application, specify Alamofire in your `Podfile` targets as dependency:

```bash
pod 'Alamofire', '~> 4.4'
```

Then run the following command:

```bash
$ pod install
```

### Installing Swift SDK

AntavoLoyaltySDK is available through CocoaPods. To install it, simply add the following line to your Podfile:

```bash
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'AntavoLoyaltySDK', '~> 1.0.1'
end
```

Then, run the following command:

```bash
$ pod install
```

## Initialization

You will need to provide an Antavo API key for initializing Swift SDK, for example:

```swift
import AntavoSDK
let antavo = AntavoSDK(apiKey: "YOUR_API_KEY")
```

## SDK Reference

The following methods will present API responses asynchronously. We recommend using Swift completion handler capabilities.
See [Completion Handlers](https://thatthinginswift.com/completion-handlers) for more information on getting started with Swift completion handlers.

### Getting brand settings

Mechanism for fetching initialized brand settings.

```swift
antavo.getSettings() { response, error in
  // Implement your application behavior...
}
```

Return values:
- response: brand settings as `NSDictionary?`
- error: API errors as `Error?`

### Registering a customer

Mechanism for registering a loyalty customer through the Antavo API.

```swift
let properties = [
  "first_name": "John",
  "last_name": "Doe",
  "email": "jdoe@somewhere.org"
]
        
antavo.registerCustomer("CUSTOMER_ID", properties: properties) { customer, error in
  // Implement your application behavior...
}
```

Return values:
- customer: customer object as `ANTCustomer?`
- error: API errors as `Error?`

### Getting customer data

Capability of getting customer data by given identifier.

```swift
antavo.getCustomer("CUSTOMER_ID") { customer, error in
  // Implement your application behavior...
}
```

Return values:
- customer: customer object as `ANTCustomer?`
- error: API errors as `Error?`

### Authenticating customer

Mechanism for authenticating an already existing loyalty customer for a SDK session.

```swift
antavo.authenticateCustomer("CUSTOMER_ID") { customer, error in
  // Implement your application behavior...
}
```

Return values:
- customer: authenticated customer as `ANTCustomer?`
- error: API errors as `Error?`

### Sending event for an authenticated customer

Mechanism for performing a POST request through the Antavo Events API.

```swift
// Defining request parameters.
let parameters = ["points": 30]

antavo.authenticateCustomer("CUSTOMER_ID") { customer, error in
  do {
    try antavo.sendEvent("point_add", parameters: parameters) { response, error in
      // Implement your application behavior...
    }
  } catch {
    // Implement your error handler mechanism...
  }
}
```

Return values:
- response: Events API response as `NSDictionary?`
- error: API errors as `Error?`

### Sending event for a non-authenticated customer

Mechanism for performing a POST request through the Antavo Events API.

```swift
// Defining request parameters.
let parameters = ["points": 30]

antavo.getCustomer("CUSTOMER_ID") { customer, error in
  if let customerObject = customer {
    antavo.getClient().postEvent("point_add", customer: customerObject, parameters: parameters) { response, error in
      // Implement your application behavior...
    }
  }
}
```

Return values:
- response: Events API response as `NSDictionary?`
- error: API errors as `Error?`

### Getting reward list

Mechanism for fetching all rewards from Antavo API.

```swift
antavo.getRewards() { rewards, error
  // Implement your application behavior...      
}
```

Return values:
- rewards: array of `ANTReward?` objects
- error: API errors as `Error?`

### Getting a reward data

Mechanism for fetching a reward entry by specified identifier from Antavo API.

```swift
antavo.getReward("REWARD_ID") { reward, error in
  // Implement your application behavior...
}
```

Return values:
- reward: response as `ANTReward?` object
- error: API error as `Error?`

### Claim a reward with authenticated customer

Mechanism for claiming a reward in Antavo.

```swift
do {
  try antavo.claimReward(rewardId: "REWARD_ID") { response, error in
    // Implement your application behavior...
  }
} catch {
  // Implement your error handler mechanism...
}
```

Return values:
- response: Events API response as `NSDictionary?`
- error: API error as `Error?`

## SDK Internal Events
Custom event listeners allow us to separate our concerns and prevent function call spaghetti. We can keep the event agnostic while we add and remove functionality.

### Events

<details>
  <summary>init</summary>
  <p>Data: -</p>
  <p>Triggered: When SDK has been initialized or reinitialized.</p>
</details>

<details>
  <summary>customerAuthenticated</summary>
  <p>data: Customer object as <i>ANTCustomer</i>.</p>
  <p>triggered: When authenticated customer has been stored.</p>
</details>

### Usage

```swift
antavo.getEventManager().listenTo(eventName: "init", action: {
  // Implement your application behavior...
})
```

### Custom event dispatching

```swift
self.getEventManager().trigger(eventName: "YOUR_EVENT_NAME")
```
