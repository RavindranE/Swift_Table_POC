//
//  HomeInteractor.swift
//  iOSSwiftTableDisplay
//
//  Created by Ravindran Esakkimuthu on 12/02/20.
//  Copyright © 2020 Ravindran Esakkimuthu. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper



protocol HomeInteractorToPresenter {
    // Update Home table Info success
    func tableDataFetchSuccess(dataList:Array<TableRows>)
    
    // Update  Home table Info failure
    func tableDataFetchFailed()
}

class HomeInteractor {
    
    private var homePresenterDelegate :HomeInteractorToPresenter!
    
    private var errorCode : Int?
    private var errorMessage : String?
    
    /// Method to initate More Info
    private func fetchTableContent()
    {
        //To do

//
//        AF.request(API_TABLE_CONTENT_LIST).responseJSON(completionHandler:
//            {response in
//                debugPrint("Response: \(response)")
//                if(response.response?.statusCode == 200){
//                    let json1 = try JSONSerialization.jsonObject(with: response.result!, options: []) as? [String : Any]
//                    if let json = response.result as AnyObject? {
//                        let arrayResponse = json["rows"] as! NSArray
//                        let arrayObject = Mapper<TableRows>().mapArray(JSONArray: arrayResponse as! [[String : Any]]);
//                        self.homePresenterDelegate?.tableDataFetchSuccess(dataList: arrayObject)
//                    }
//                }else {
//                    self.homePresenterDelegate?.tableDataFetchFailed()
//                }
//        })
    }
}

extension HomeInteractor : HomePresenterToInteractor{
    
    /// Set presenter delegate.
    ///
    /// - parameter delegate: Delegate object to set as presenter.
    func setPresenterDelegate(delegate:HomeInteractorToPresenter){
        self.homePresenterDelegate = delegate
    }
    
    func fetchTableDataFromAPI(){
        self.fetchTableContent()
    }
    
}

