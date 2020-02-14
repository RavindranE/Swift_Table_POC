//
//  HomePresenter.swift
//  iOSSwiftTableDisplay
//
//  Created by Ravindran Esakkimuthu on 12/02/20.
//  Copyright © 2020 Ravindran Esakkimuthu. All rights reserved.
//

import Foundation

// Protocol communicating to Home.
protocol HomePresenterToView {
    //Success Response
    func onTableDataResponseSuccess(tableDataModel:TableModel)
    //Failure Response
    func onTableDataResponseFailed(errorMessage:String)
}

// Protocol communicating from presenter.
protocol HomePresenterToInteractor {
    // Set Presenter delegate.
    func setPresenterDelegate(delegate:HomeInteractorToPresenter)
    func fetchTableDataFromAPI()
}

class HomePresenter{
    private var viewDelegate :HomePresenterToView!
    private var interactorDelegate: HomePresenterToInteractor!
    
    init() {
        self.interactorDelegate = HomeInteractor()
        self.interactorDelegate.setPresenterDelegate(delegate: self)
    }
    
    func initiateDataFetch() {
        self.interactorDelegate.fetchTableDataFromAPI()
    }
    
}

//MARK: - Extension for Protocol Methods
extension HomePresenter:HomeInteractorToPresenter{

    // Update Home table Info success
    func tableDataFetchSuccess(tableDataModel:TableModel){
        viewDelegate.onTableDataResponseSuccess(tableDataModel: tableDataModel)
    }
    
    // Update  Home table Info failure
    func tableDataFetchFailed(errorMessage:String){
        viewDelegate.onTableDataResponseFailed(errorMessage: errorMessage)
    }
 
}

extension HomePresenter : HomeViewToPresenter{
    
    // Set View delegate.
    // - parameter delegate: Delegate object to set as presenter.
    func setViewDelegate(delegate:HomePresenterToView){
        self.viewDelegate = delegate
    }
    
    func initiateDataLoading(){
        self.initiateDataFetch()
    }
    
}
