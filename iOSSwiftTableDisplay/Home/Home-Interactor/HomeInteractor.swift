//
//  HomeInteractor.swift
//  iOSSwiftTableDisplay
//
//  Created by Ravindran Esakkimuthu on 12/02/20.
//  Copyright © 2020 Ravindran Esakkimuthu. All rights reserved.
//

import Foundation
import ObjectMapper
import Reachability

protocol HomeInteractorToPresenter {
    // Update Home table Info success
    func tableDataFetchSuccess(tableDataModel:TableModel)
    
    // Update  Home table Info failure
    func tableDataFetchFailed(errorMessage:String)
}

class HomeInteractor {
    
    private var homePresenterDelegate :HomeInteractorToPresenter!
    
    // Method to fetch the file content as json to map with required mappable object
    private func fetchTableContent()
    {
        //fetch json content from remote file
        if let url = URL(string: API_TABLE_CONTENT_LIST) {
            do {
                let fileContent = try String(contentsOf: url, encoding: String.Encoding.isoLatin1)
                let fileData = Data(fileContent.utf8)
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: fileData, options: []) as? [String: Any] {
                        // try to read out a Table Model which has rows and title elements
                        let tableModel = Mapper<TableModel>().map(JSONObject: json)
                        //remove the row item where all elements are empty
                        tableModel?.rows?.removeAll(where: { $0.title == nil && $0.description == nil && $0.imageHref == nil })

                        self.homePresenterDelegate?.tableDataFetchSuccess(tableDataModel: tableModel!)
                        
                    }
                }
                catch let error as NSError {
                    self.homePresenterDelegate?.tableDataFetchFailed(errorMessage: "\(error.localizedDescription)")
                }
            }
            catch let error as NSError{
                self.homePresenterDelegate?.tableDataFetchFailed(errorMessage: "\(error.localizedDescription)")
            }
        } else {
             self.homePresenterDelegate?.tableDataFetchFailed(errorMessage: API_URL_LOADING_ERROR)
        }
    }
}
//MARK: - Extension for Protocol Methods
extension HomeInteractor : HomePresenterToInteractor{
    
    // Set presenter delegate.
    // - parameter delegate: Delegate object to set as presenter.
    func setPresenterDelegate(delegate:HomeInteractorToPresenter){
        self.homePresenterDelegate = delegate
    }
    //fetch from file/API
    func fetchTableDataFromAPI(){
        do{
            let reachability = try Reachability()
            print(reachability.connection.description)
            if (reachability.connection == .cellular ||
                reachability.connection == .wifi){
                self.fetchTableContent()
            }
            else{
                self.homePresenterDelegate?.tableDataFetchFailed(errorMessage: NETWORK_ERROR)
                
            }
        }
        catch let error as NSError {
            self.homePresenterDelegate?.tableDataFetchFailed(errorMessage: "\(error.localizedDescription)")
        }
        
        
        
        
        
    }
    
}
