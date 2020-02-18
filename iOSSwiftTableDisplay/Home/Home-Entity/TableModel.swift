//
//  TableModel.swift
//  iOSSwiftTableDisplay
//
//  Created by Ravindran Esakkimuthu on 13/02/20.
//  Copyright © 2020 Ravindran Esakkimuthu. All rights reserved.
//

import Foundation
import ObjectMapper

private let TITLE = "title"
private let ROWS = "rows"

//Mappable model for Table tilte and Table rows
class TableModel: Mappable {

    internal var rows: [TableRows]?
    internal var title: String?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        title <- map[TITLE]
        rows <- map[ROWS]
    }

}
