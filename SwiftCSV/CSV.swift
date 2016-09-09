//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Foundation

open class CSV {
    open var headers: [String] = []
    open var rows: [Dictionary<String, String>] = []
    open var columns = Dictionary<String, [String]>()
    var delimiter = CharacterSet(charactersIn: ",")
    
    public init(string: String?, delimiter: CharacterSet, encoding: UInt) {
        if let csvStringToParse = string {
            self.delimiter = delimiter

            let newline = CharacterSet.newlines
            var lines: [String] = []
            csvStringToParse.trimmingCharacters(in: newline).enumerateLines { line, stop in lines.append(line) }

            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
            self.columns = self.parseColumns(fromLines: lines)
        }
    }
    
    public convenience init(contentsOfURL url: URL, delimiter: CharacterSet, encoding: UInt) throws {
        let csvString: String?
        do {
            csvString = try String(contentsOf: url, encoding: String.Encoding(rawValue: encoding))
        } catch _ {
            csvString = nil
        };
        self.init(string: csvString, delimiter: delimiter, encoding: encoding)
    }
    
    public convenience init(contentsOfURL url: URL) throws {
        let comma = CharacterSet(charactersIn: ",")
        try self.init(contentsOfURL: url, delimiter: comma, encoding: String.Encoding.utf8.rawValue)
    }
    
    public convenience init(contentsOfURL url: URL, encoding: UInt) throws {
        let comma = CharacterSet(charactersIn: ",")
        try self.init(contentsOfURL: url, delimiter: comma, encoding: encoding)
    }
    
    public convenience init(string: String?) {
        let comma = CharacterSet(charactersIn: ",")
        self.init(string: string, delimiter: comma, encoding: String.Encoding.utf8.rawValue)
    }
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].components(separatedBy: self.delimiter)
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        var rows: [Dictionary<String, String>] = []
        
        for (lineNumber, line) in lines.enumerated() {
            if lineNumber == 0 {
                continue
            }
            
            var row = Dictionary<String, String>()
            let values = line.components(separatedBy: self.delimiter)
            for (index, header) in self.headers.enumerated() {
                if index < values.count {
                    row[header] = values[index]
                } else {
                    row[header] = ""
                }
            }
            rows.append(row)
        }
        
        return rows
    }
    
    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [String]> {
        var columns = Dictionary<String, [String]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header] != nil ? row[header]! : "" }
            columns[header] = column
        }
        
        return columns
    }
}
