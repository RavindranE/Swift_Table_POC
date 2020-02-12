//
//  HomePresenter.swift
//  iOSSwiftTableDisplay
//
//  Created by Ravindran Esakkimuthu on 12/02/20.
//  Copyright © 2020 Ravindran Esakkimuthu. All rights reserved.
//

import Foundation
protocol HomePresenterToView {
    //Success
    func onTableDataResponseSuccess(tableDataArrayList:Array<TableRows>)
    //Failure
    func onTableDataResponseFailed(error:String)
}

/// Protocol communicating from presenter.
protocol HomePresenterToInteractor {
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
extension HomePresenter:HomeInteractorToPresenter{

    // Update Home table Info success
    func tableDataFetchSuccess(dataList:Array<TableRows>){
        viewDelegate.onTableDataResponseSuccess(tableDataArrayList: dataList)
    }
    
    // Update  Home table Info failure
    func tableDataFetchFailed(){
        viewDelegate.onTableDataResponseFailed(error: "API Error")
    }
 
}

extension HomePresenter : HomeViewToPresenter{
    
    /// Set View delegate.
    ///
    /// - parameter delegate: Delegate object to set as presenter.
    func setViewDelegate(delegate:HomePresenterToView){
        self.viewDelegate = delegate
    }
    
    func initiateDataLoading(){
        self.initiateDataFetch()
    }
    
}
