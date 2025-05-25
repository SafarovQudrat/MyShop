//
//  ProductCD+CoreDataProperties.swift
//  MyShop
//
//  Created by Qudrat on 24/05/25.
//
//

import Foundation
import CoreData


extension ProductCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCD> {
        return NSFetchRequest<ProductCD>(entityName: "ProductCD")
    }

    @NSManaged public var addedDate: Date?
    @NSManaged public var barcode: String?
    @NSManaged public var category: String?
    @NSManaged public var count: Int32
    @NSManaged public var name: String?
    @NSManaged public var purchasePrice: Double
    @NSManaged public var remainingP: Int64
    @NSManaged public var salePrice: Double
    @NSManaged public var totalProduct: Int64
    @NSManaged public var unitType: String?
    @NSManaged public var validityPeriod: Date?
    @NSManaged public var sale: SaleCD?

}

extension ProductCD : Identifiable {

}
