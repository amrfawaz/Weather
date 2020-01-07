//
import Alamofire
import PromiseKit
//  TripViewModel.swift
//  Weather
//
//  Created by Amr Fawaz on 1/7/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//
import UIKit

class Api: NSObject {
    var params: RequestParamters?
    var requestType: Requestable?
    var result = ""
    var requestsId = ""

    func getApiName() -> String {
        return ""
    }

    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.shared.beginBackgroundTask(expirationHandler: ({}))
    }

    func endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(taskID)
    }

    func cancel() {
        ServiceManager.shared.cancelRequestWithID(requestID: requestsId)
    }
}

extension Api {
    func fireRequestWithSingleResponse<T: Codable>(requestable: Requestable) -> Promise<T> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let taskId = beginBackgroundUpdateTask()
        return Promise<T> { seal in
            let completionHandler: (DataResponse<T>) -> Void = { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.endBackgroundUpdateTask(taskID: taskId)
                guard response.error == nil else {
                    if let err = response.error as? URLError {
                        // no internet connection
                        let errorN = WeatherError(code: "00-000", message: "Sorry, Please check your internet connection")
                        seal.reject(errorN)
                        return
                    }
                    seal.reject(WeatherError.getError(error: response.error!))
                    return
                }
                guard response.value != nil else {
                    _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                    seal.reject(WeatherError.getError(error: response.error!))
                    return
                }
                seal.fulfill(response.result.value!)
            }

            requestable.request(requestID: requestsId, with: completionHandler)
        }
    }

    func fireRequestWithMultiResponse<T: Codable>(requestable: Requestable) -> Promise<[T]> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let taskId = beginBackgroundUpdateTask()
        return Promise<[T]> { seal in
            let completionHandler: (DataResponse<[T]>) -> Void = { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.endBackgroundUpdateTask(taskID: taskId)
                guard response.error == nil else {
                    if let err = response.error as? URLError {
                        // no internet connection
                        let errorN = WeatherError(code: "00-000", message: "Sorry, Please check your internet connection")
                        seal.reject(errorN)
                        return
                    }
                    seal.reject(WeatherError.getError(error: response.error!))
                    return
                }
                guard response.value != nil else {
                    _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                    seal.reject(WeatherError.getError(error: response.error!))
                    return
                }
                seal.fulfill(response.result.value!)
            }

            requestable.request(requestID: requestsId, with: completionHandler)
        }
    }

    func fireRequestWithoutResponse(requestable: Requestable) -> Promise<Bool> {
        return Promise<Bool> { seal in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let taskId = beginBackgroundUpdateTask()
            let completionHandler: (DataResponse<Any>) -> Void = { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.endBackgroundUpdateTask(taskID: taskId)

                guard response.error == nil else {
                    if let err = response.error as? URLError {
                        // no internet connection
                        let errorN = WeatherError(code: "00-000", message: "Sorry, Please check your internet connection")
                        seal.reject(errorN)
                        return
                    }
                    seal.reject(response.error!)
                    return
                }
                guard response.value != nil else {
                    _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                    seal.reject(response.error!)
                    return
                }

                if let result = response.result.value as? [String: Any] {
                    if let _ = result["errors"] {
                        let code = (result["status"] as! NSNumber).stringValue
                        let message = result["message"] as! String
                        let title = result["title"] as! String
                        let error = WeatherError(code: code, message: message, title: title)
                        seal.reject(error)
                        return
                    }
                }

                seal.fulfill(true)
            }
            requestable.request(requestID: requestsId, with: completionHandler)
        }
    }

    func fireRequestWithCustomResponse(requestable: Requestable, complition: @escaping (([String: Any]?, WeatherError?) -> Void)) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let taskId = beginBackgroundUpdateTask()

        let completionHandler: (DataResponse<Any>) -> Void = { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.endBackgroundUpdateTask(taskID: taskId)
            guard response.error == nil else {
                if let err = response.error as? URLError {
                    // no internet connection
                    let errorN = WeatherError(code: "00-000", message: "Sorry, Please check your internet connection")
                    complition(nil, errorN)
                    return
                }

                complition(nil, WeatherError.getError(error: response.error!))
                return
            }
            guard response.value != nil else {
                _ = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                complition(nil, response.error! as? WeatherError)
                return
            }

            let result: [String: Any] = response.result.value as? [String: Any] ?? [:]

            if let _ = result["errors"] {
                let code = (result["status"] as! NSNumber).stringValue
                let message = result["message"] as! String
                let title = result["title"] as! String
                let error = WeatherError(code: code, message: message, title: title)
                complition(nil, error)
                return
            }

            complition(result, nil)
        }
        requestable.request(requestID: requestsId, with: completionHandler)
    }
}
