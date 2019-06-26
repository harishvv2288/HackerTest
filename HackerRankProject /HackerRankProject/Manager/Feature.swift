//
//  Feature.swift
//  HackerRankProject
//
//  Created by Harish V V on 22/06/19.
//  Copyright © 2019 Company. All rights reserved.
//

import Foundation

///This acts as the ViewModel class which handles all the business logic

//this enum would contain all the service calls triggered from the View's this ViewModel class associates with
enum FeatureServiceType: String {
    case aboutCanada
}

class Feature {
    var serviceLayer: ServiceLayer?
    
    init() {
        self.serviceLayer = ServiceLayer()
    }
    
    public func triggerServiceCall(serviceType: FeatureServiceType, completion: @escaping (RequestableResult<Any?>) -> Void) {
        let url = URL_STRINGS.COUNTRY_FACTS
        self.serviceLayer?.dataRequestWith(url: url, completion: { (result) in
            if result.hasResult {
                if let value = result.value as? [String: Any] {
                    //create model object from json
                    let modelObject = Canada.init(dictionary: value)
                    completion(RequestableResult.result(modelObject))
                }
            }
        })
    }
}
