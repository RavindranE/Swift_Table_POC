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

protocol HomeInteractorToPresenter{
    // Update Home table Info success
    func tableDataFetchSuccess(tableDataModel: TableModel)
    // Update  Home table Info failure
    func tableDataFetchFailed(errorMessage: String)
}

class HomeInteractor {
    private var homePresenterDelegate: HomeInteractorToPresenter?
    // Method to fetch the file content as json to map with required mappable object
    private func fetchTableContent() {
        let urlString: String = self.getAPIURL()
        self.initiateTableDataAPIRequest(urlString: urlString, completionHandler: {(status, success, error) in
            switch status {
            case true:
                guard let fetchedDataModel = success else{
                    return
                }
                self.homePresenterDelegate?.tableDataFetchSuccess(tableDataModel: fetchedDataModel)
                break
            case false:
                guard let resultError = error else{
                    return
                }
                self.homePresenterDelegate?.tableDataFetchFailed(errorMessage: resultError)
                break
            }
        })
    }

    func initiateTableDataAPIRequest(urlString: String, completionHandler:(_ status: Bool, _ success: TableModel?, _ errorContent: String?) -> Void) {

        //fetch json content from remote file
        if let url = URL(string: urlString ) {
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
                        completionHandler(true, tableModel, nil)
                    }
                } catch let error as NSError {
                    completionHandler(false, nil, error.localizedDescription)
                }
            } catch let error as NSError {
                completionHandler(false, nil, error.localizedDescription)
            }
        } else {
            completionHandler(false, nil, NSLocalizedString("API_URL_LOADING_ERROR", comment: "API Loading Error Message"))
        }
    }

    func getAPIURL() -> String {
        return NSLocalizedString("API_TABLE_CONTENT_LIST", comment: "API URL String")
    }
}

// MARK: - Extension for Protocol Methods
extension HomeInteractor: HomePresenterToInteractor {
    // Set presenter delegate.
    // - parameter delegate: Delegate object to set as presenter.
    func setPresenterDelegate(delegate: HomeInteractorToPresenter) {
        self.homePresenterDelegate = delegate
    }
    //fetch from file/API
    func fetchTableDataFromAPI() {
        do {
            let reachability = try Reachability()
            if reachability.connection == .cellular ||
                reachability.connection == .wifi {
                self.fetchTableContent()
            } else {
                self.homePresenterDelegate?.tableDataFetchFailed(errorMessage: NSLocalizedString("NETWORK_ERROR", comment: "Network Error"))

            }
        } catch let error as NSError {
            self.homePresenterDelegate?.tableDataFetchFailed(errorMessage: "\(error.localizedDescription)")
        }
    }
}
