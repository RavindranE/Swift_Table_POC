//
//  HomeViewController.swift
//  iOSSwiftTableDisplay
//
//  Created by Ravindran Esakkimuthu on 12/02/20.
//  Copyright © 2020 Ravindran Esakkimuthu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
protocol HomeViewToPresenter:class{

    func setViewDelegate(delegate:HomePresenterToView)
    func initiateDataLoading()
    
}

class HomeViewController: UIViewController, UITableViewDataSource {
    //Delegate
    private var presenterDelegate:HomeViewToPresenter?
    //Initialize Table resource
    let tableDataView = UITableView(frame: UIScreen.main.bounds)
    var dataList:Array<TableRows> = Array()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        view.backgroundColor = .white
        
        //SetDelegate
        self.presenterDelegate = HomePresenter()
        self.presenterDelegate?.setViewDelegate(delegate: self)
        
        //Navigation for Controller
        self.setControllerNavigation()
        
        //Set Table as Child view of View
        view.addSubview(tableDataView)
        
        //Set Table Source
        tableDataView.dataSource = self
        
        //Table Layout Alignment
        self.tableLayoutAlignment()
        presenterDelegate?.initiateDataLoading()

    }
    //MARK: - Set Auto Layout for Table
    func tableLayoutAlignment(){
        
        tableDataView.translatesAutoresizingMaskIntoConstraints = false
        tableDataView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableDataView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableDataView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableDataView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
    }
    //MARK: - Set Controller Navigation
    func setControllerNavigation() {
        self.setNavigationTitle(navigationtitle:defaultNavigationTitle)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    //MARK: - Set NavigationTitle
    func setNavigationTitle(navigationtitle:String){
        navigationItem.title = navigationtitle
    }
    
    //MARK: - Table Data Source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableCell
        cell.cellTitle.text = dataList[indexPath.row].title
        cell.cellDescription.text = dataList[indexPath.row].description
        
        //Image loading
        
        AF.request(self.dataList[indexPath.row].imageHref!).responseData { (response) in
            if response.error == nil {
                print(response.result)
                if let data = response.data {
                    cell.cellImage.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
    
}

extension HomeViewController:HomePresenterToView{
    func onTableDataResponseSuccess(tableDataArrayList: Array<TableRows>) {
        self.dataList = tableDataArrayList
        self.tableDataView.reloadData()
    }
    
    func onTableDataResponseFailed(error: String) {
        print("error")
    }
    
    
}
