//
//  SPPError.swift
//  
//
//  Created by ky0me22 on 2022/06/03.
//

enum SPPError: Error {
    case couldNotReadFile(String)
    case noLibraries
    case couldNotExportLicenseList
}
