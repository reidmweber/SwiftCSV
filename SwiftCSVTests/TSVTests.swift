//
//  TSVTests.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/15.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import XCTest
import SwiftCSV

class TSVTests: XCTestCase {
    var tsv: CSV!
    var error: NSErrorPointer? = nil
    
    override func setUp() {
        let url = Bundle(for: TSVTests.self).url(forResource: "users", withExtension: "tsv")
        let tab = CharacterSet(charactersIn: "\t")
        do {
            tsv = try CSV(contentsOfURL: url!, delimiter: tab, encoding: String.Encoding.utf8)
        } catch let error1 as NSError {
            error??.pointee = error1
            tsv = nil
        }
    }
    
    func testHeaders() {
        XCTAssertEqual(tsv.headers, ["id", "name", "age"], "")
    }
    
    func testRows() {
        let expects = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""],
        ]
        XCTAssertEqual(tsv.rows, expects, "")
    }
    
    func testColumns() {
        XCTAssertEqual(["id": ["1", "2", "3"], "name": ["Alice", "Bob", "Charlie"], "age": ["18", "19", ""]], tsv.columns, "")
    }
}
