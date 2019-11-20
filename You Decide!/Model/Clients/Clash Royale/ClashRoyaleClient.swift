//
//  ClashRoyaleClient.swift
//  Capstone App
//
//  Created by Hossameldien Hamada on 11/2/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import Foundation

//MARK:- Clash Royale Client
class ClashRoyaleClient: NSObject{
    
    //MARK:- Properties
    var session = URLSession.shared
    
    //MARK:- Initializer
    override init() {
        super.init()
    }
    
    //MARK:- Shared Instance
    class func sharedInstance() -> ClashRoyaleClient{
        struct Singelton{
            static var sharedInstance = ClashRoyaleClient()
        }
        return Singelton.sharedInstance
    }
    
    //MARK:- Get
    func taskForGetMethod(_ method: String, completionHandlerForGET: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        // Build the URL and Configure the request
        let request = NSMutableURLRequest(url: clashRoyaleURLFromParameters(withPathExtension: method))
        let authorizationKey = "Bearer ".appending(ClashRoayle.ApiKey)
        request.addValue(authorizationKey, forHTTPHeaderField: "Authorization")
        
        // Make the Request
        return makeRequestWithCompletionHandler(request: request as URLRequest, errorDomain: "taskForGetMethod", completionHandlerForMakeRequest: completionHandlerForGET)
    }
    
    //MARK:- Make request
    private func makeRequestWithCompletionHandler(request: URLRequest, errorDomain: String, completionHandlerForMakeRequest: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        //Make the Request
        let task = session.dataTask(with: request as URLRequest){ (data,response,error) in
            
            func sendError(_ error:String){
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForMakeRequest(nil,NSError(domain: errorDomain, code: 1, userInfo: userInfo))
            }
            
            // Guard for error
            guard(error == nil) else{
                sendError("There was an error with your request: Check the internet connection!")
                return
            }
            
            // Guard for response status
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                sendError("Wrong Credentials!")
                return
            }
            
            // Guard for returned data
            guard let data = data  else{
                sendError("No data was returned by the request!")
                return
                
            }
            
            // parse and use data
            self.convertDataWithCompletionHandler(data,completionHandlerForConvertData: completionHandlerForMakeRequest)
        }
        
        task.resume()
        return task
    }
    
    //MARK:- Parse JSON
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData:(_ result: AnyObject?, _ error: NSError?) -> Void){
        
        var parsedResult: AnyObject! = nil
        
        do{
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            completionHandlerForConvertData(parsedResult,nil)
        }catch{
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        
    }
    
    //MARK:- URL Creation
    private func clashRoyaleURLFromParameters(withPathExtension: String? = nil) -> URL{
        var components = URLComponents()
        components.scheme = ClashRoyaleClient.ClashRoayle.APIScheme
        components.host =  ClashRoyaleClient.ClashRoayle.APIHost
        components.path =  ClashRoyaleClient.ClashRoayle.APIPath + (withPathExtension ?? "")
        
        return components.url!
        
    }
    
    //MARK:- Substitute Key for Value in Methods
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String?{
        if method.range(of: "{\(key)}") != nil{
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        }else{
            return nil
        }
    }
}
