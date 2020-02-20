//
//  CellContent.swift
//  iOSSwiftTableDisplay
//
//  Created by Ravindran Esakkimuthu on 12/02/20.
//  Copyright © 2020 Ravindran Esakkimuthu. All rights reserved.
//

import Foundation
import ObjectMapper

private let TITLE = "title"
private let DESCRIPTION = "description"
private let IMAGEHREF = "imageHref"

//Mappable Object for row
class TableRows: Mappable {

    internal var title: String?
    internal var description: String?
    internal var imageHref: String?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {

        title <- map[TITLE]
        description <- map[DESCRIPTION]
        imageHref <- map[IMAGEHREF]
    }
}
