//
//  HomeViewController.swift
//  iOSSwiftTableDisplay
//
//  Created by Ravindran Esakkimuthu on 12/02/20.
//  Copyright © 2020 Ravindran Esakkimuthu. All rights reserved.
//

import Foundation
import UIKit

protocol HomeViewToPresenter: class {
    // Set View delegate.
    func setViewDelegate(delegate: HomePresenterToView)
    func initiateDataLoading()
}

class HomeViewController: UIViewController, UITableViewDataSource {
    //Delegate
    private weak var presenterDelegate: HomeViewToPresenter?
    //Initialize Table resource
    let tableDataView = UITableView(frame: UIScreen.main.bounds)
    var dataList = [TableRows]()

    override func viewDidLoad() {
        super .viewDidLoad()
        view.backgroundColor = UIColor(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)//.white

        //SetDelegate
        self.presenterDelegate = HomePresenter()
        self.presenterDelegate?.setViewDelegate(delegate: self)

        //Navigation for Controller
        self.setControllerNavigation()

        //Set Table as Child view of View
        view.addSubview(tableDataView)

        tableDataView.estimatedRowHeight = 100
        tableDataView.rowHeight = UITableView.automaticDimension
        tableDataView.register(HomeTableCell.self, forCellReuseIdentifier: textCellIdentifier)
        //Set Table Source
        tableDataView.dataSource = self
        //tableDataView.delegate = self

        //Table Layout Alignment
        self.tableLayoutAlignment()
        presenterDelegate?.initiateDataLoading()

    }
    // MARK: - Set Auto Layout for Table
    func tableLayoutAlignment() {
        tableDataView.translatesAutoresizingMaskIntoConstraints = false

        tableDataView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableDataView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableDataView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

    }
    // MARK: - Set Controller Navigation
    func setControllerNavigation() {
        self.setNavigationTitle(navigationtitle: defaultNavigationTitle)
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = .blue
        let rightButton = UIBarButtonItem(title: BTN_TITLE_REFRESH, style: .done, target: self, action: #selector(refreshTable))
        navigationItem.rightBarButtonItem = rightButton

    }
    // MARK: - Set NavigationTitle
    func setNavigationTitle(navigationtitle: String) {
        navigationItem.title = navigationtitle
    }

    // MARK: - Table Data Source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowCount = dataList.count as Int? {
            return rowCount
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! HomeTableCell
        //Clear Previous content
        if let container = cell.viewWithTag(tagCellContainer) {
            if let titleLabel = container.viewWithTag(tagCellTitle) as? UILabel {
                titleLabel.text = ""
            }
            if let descriptionLabel = container.viewWithTag(tagCellDescription) as? UILabel {
                descriptionLabel.text = ""
            }
            if let imgContainer = container.viewWithTag(tagCellImage) as? UIImageView {
                imgContainer.image = nil

            }

        }
        cell.row = dataList[indexPath.row]

        return cell
    }

    // MARK: - Refresh Table Display

    @objc func refreshTable() {
        if dataList.count > 0 {

            self.tableDataView.setContentOffset(CGPoint(x: 0, y: -((self.navigationController?.navigationBar.frame.height)!)), animated: true)

            self.tableDataView.reloadData()
        } else {
            presenterDelegate?.initiateDataLoading()
        }
    }

    // MARK: - Display User Info
    func displayErrorInoToUser(errorInfo: String) {
        let alertController = UIAlertController(title: TEXT_USER_INFO, message: errorInfo, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: TEXT_OK, style: .default)
        alertController.addAction(submitAction)

        present(alertController, animated: true)
    }

}
// MARK: - Extension for Protocol Methods
extension HomeViewController: HomePresenterToView {
    func onTableDataResponseSuccess(tableDataModel: TableModel) {
        //self.dataList = tableDataModel
        self.setNavigationTitle(navigationtitle: tableDataModel.title!)
        self.dataList = tableDataModel.rows!
        self.tableDataView.reloadData()

    }

    func onTableDataResponseFailed(errorMessage: String) {
        print(errorMessage)
        displayErrorInoToUser(errorInfo: errorMessage)
    }
}
