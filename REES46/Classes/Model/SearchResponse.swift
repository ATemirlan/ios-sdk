//
//  SearchResponse.swift
//  FBSnapshotTestCase
//
//  Created by Арсений Дорогин on 31.07.2020.
//

import Foundation

public struct Filter {
    public var count: Int
    public var values: [String: Int]
    
    init(json: [String: Any]) {
        self.count = json["count"] as? Int ?? 0
        self.values = json["values"] as? [String: Int] ?? [:]
    }
}

public struct PriceRange {
    public var min: Double
    public var max: Double
    
    init(json: [String: Any]) {
        self.min = json["min"] as? Double ?? 0
        self.max = json["max"] as? Double ?? 0
    }
}

public struct SearchResponse {
    public var categories: [Category]
    public var products: [Product]
    public var productsTotal: Int
    public var queries: [Query]
    public var filters: [String: Filter]?
    public var brands: [String]?
    public var priceRange: PriceRange?

    init(json: [String: Any]) {
        let cats = json["categories"] as? [[String: Any]] ?? []
        var catsTemp = [Category]()
        for item in cats {
            catsTemp.append(Category(json: item))
        }
        categories = catsTemp

        let prods = json["products"] as? [[String: Any]] ?? []
        var prodsTemp = [Product]()
        for item in prods {
            prodsTemp.append(Product(json: item))
        }
        products = prodsTemp

        let quers = json["queries"] as? [[String: Any]] ?? []
        var quersTemp = [Query]()
        for item in quers {
            quersTemp.append(Query(json: item))
        }
        queries = quersTemp

        productsTotal = (json["products_total"] as? Int) ?? 0
        
        if let filtersJSON = json["filters"] as? [String: Any] {
            var filtersResult = [String: Filter]()
            for item in filtersJSON {
                if let dict = item.value as? [String: Any] {
                    filtersResult[item.key] = Filter(json: dict)
                }
            }
            self.filters = filtersResult
        }
        
        if let brandsJSON = json["brands"] as? [[String: Any]] {
            var brandsResult = [String]()
            for item in brandsJSON {
                if let name = item["name"] as? String {
                    brandsResult.append(name)
                }
            }
            self.brands = brandsResult
        }
        
        if let priceRangeJSON = json["price_range"] as? [String: Any] {
            self.priceRange = PriceRange(json: priceRangeJSON)
        }
        
    }
}

public struct Product {
    public var id: String
    public var name: String
    public var brand: String
    public var price: Double
    public var oldPrice: Double
    public var picture: String
    public var priceFormatted: String
    public var url: String
    public var currency: String
    public var isNew: Bool?
    public var barcode: String?
    public var params: [[String: Any]]?

    init(json: [String: Any]) {
        id = json["id"] as! String
        name = json["name"] as! String
        brand = json["brand"] as! String
        price = json["price"] as! Double
        oldPrice = json["old_price"] as! Double
        priceFormatted = json["price_formatted"] as! String
        picture = json["picture"] as! String
        url = json["url"] as! String
        currency = json["currency"] as! String
        isNew = json["is_new"] as? Bool
        barcode = json["barcode"] as? String
        params = json["params"] as? [[String: Any]]
    }
}

public struct Query {
    public var name: String
    public var url: String

    init(json: [String: Any]) {
        name = json["name"] as! String
        url = json["url"] as! String
    }
}

public struct Category {
    public var id: String = ""
    public var name: String = ""
    public var url: String?
    public var alias: String?

    init(json: [String: Any]) {
        id = json["id"] as! String
        name = json["name"] as! String
        url = json["url"] as? String
        alias = json["alias"] as? String
    }
}
