//
//  TripViewModel.swift
//  Weather
//
//  Created by Amr Fawaz on 1/7/20.
//  Copyright © 2020 amrfawaz. All rights reserved.
//
import Alamofire
import CodableAlamofire

protocol Requestable: URLRequestConvertible {
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var header: [String: String]? { get }
    var queryParamters: String? { get }
    var baseUrl: URL { get }
    var module: ApiModule? { get }
    var parameters: Parameters? { get }
    var timeoutIntervalForRequest: TimeInterval { get }

    @discardableResult
    func request<T: Codable>(requestID: String, with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest

    @discardableResult
    func request<T: Codable>(requestID: String, with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest

    @discardableResult
    func request<T: Any>(requestID: String, with responseDictionryObject: @escaping (DataResponse<T>) -> Void) -> DataRequest
}

extension Requestable {
    // method is post by default 🙄
    var method: Alamofire.HTTPMethod {
        return .post
    }

    // just to add nil as default parameter
    var parameters: Parameters? {
        return nil
    }

    var queryParamters: String? {
        return nil
    }

    var header: [String: String]? {
        return nil
    }

    // default timeoutIntervalForRequest
    var timeoutIntervalForRequest: TimeInterval {
        return 30.0
    }

    @discardableResult
    func request<T: Codable>(requestID: String, with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self, requestID: requestID).responseDecodableObject(completionHandler: responseObject).validateErrors()
    }

    @discardableResult
    func request<T: Codable>(requestID: String, with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self, requestID: requestID).responseDecodableObject(completionHandler: responseArray).validateErrors()
    }

    @discardableResult
    func request<T: Any>(requestID: String, with responseDictionry: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self, requestID: requestID).responseJSON(completionHandler: responseDictionry as! (DataResponse<Any>) -> Void).validateErrors()
    }

    func asURLRequest() throws -> URLRequest {
        // update timeoutIntervalForRequest from router
        ServiceManager.shared.manager.session.configuration.timeoutIntervalForRequest = timeoutIntervalForRequest

        var url = baseUrl

        if !path.isEmpty {
            url = url.appendingPathComponent(path)
        }

        url = url.appendingPathComponent((module?.name)!)

        if let extraParams = queryParamters {
            url = url.appendingPathComponent(extraParams)
        }

        // get ApiKey

        var urlRequest = try URLRequest(url: url, method: method)


        if header != nil {
            for (key, value) in header! {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

//        if let token = UserConfiguration.current.user.getToken() {
//            urlRequest.addValue(token, forHTTPHeaderField: ServerKeys.userToken)
//        }

        urlRequest.addValue(ServerKeys.contentValue, forHTTPHeaderField: ServerKeys.content)
        print("\(url.absoluteString)")

        switch method {
        case .get:
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        }
    }

    fileprivate func asURLRequest() -> String {
        var url = baseUrl

        if !path.isEmpty {
            url = url.appendingPathComponent(path)
        }

        url = url.appendingPathComponent((module?.name)!)

        return url.absoluteString
    }
}

enum ApiModule: String {
    case login
    case logout
    case getUser
    case register
    case flightSearch
    case airportSearch
    case isIternaryAvilable
    case fetchCountries
    case compeletPayment
    case addPassengers
    case getOrderInfo
    case getUserBookings
    case getMyTravellers
    case deleteTraveller
    case addTraveller
    case editTraveller
    case resendVerification
    case forgotPassword
    case deleteCard
    case makeCardDefault
    case addCard
    case getCards
    case editUserInfo
    case editUserPassword
    case fetchSupportCenter
    case searchForFaqQuestions
    case getAllFaqQuestions
    case manageMyBookings
    case sendMessage
    case terms
    case privacy
    case getGeoIp
    case getFareRule
    case fetchSupportCenterCategoryQuestions
    case isModifyBooking
    case sendModifyRequest
    case modifyFlightSearch
    var name: String {
        switch self {
        case .login: return "login"
        case .logout: return "logout"
        case .getUser: return "me"
        case .register: return "user"
        case .forgotPassword: return "forget_password"
        case .resendVerification: return "resend_verify_email"
        case .flightSearch: return "search"
        case .airportSearch: return "search"
        case .isIternaryAvilable: return "cart"
        case .fetchCountries: return "country"
        case .compeletPayment: return "checkout"
        case .addPassengers: return "passenger"
        case .getOrderInfo: return "find"
        case .getUserBookings: return "order"
        case .getMyTravellers: return "traveller"
        case .deleteTraveller: return "traveller"
        case .addTraveller: return "traveller"
        case .editTraveller: return "traveller"
        case .deleteCard: return "card"
        case .makeCardDefault: return "card"
        case .addCard: return "card"
        case .getCards: return "card"
        case .editUserInfo: return "me"
        case .editUserPassword: return "update_password"
        case .fetchSupportCenter: return "category"
        case .searchForFaqQuestions: return "search"
        case .getAllFaqQuestions: return "faq"
        case .manageMyBookings: return "find"
        case .sendMessage: return "contact"
        case .terms: return "terms"
        case .privacy: return "privacy"
        case .getGeoIp: return "lookup"
        case .getFareRule: return "farerule"
        case .fetchSupportCenterCategoryQuestions: return "slug"
        case .isModifyBooking: return "modify"
        case .sendModifyRequest: return "modify"
        case .modifyFlightSearch: return "modify"
        }
    }
}
