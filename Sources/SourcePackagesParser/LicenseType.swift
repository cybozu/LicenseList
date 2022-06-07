//
//  LicenseType.swift
//  
//
//  Created by ky0me22 on 2022/06/03.
//

fileprivate let APACHE_2_TEXT = "TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION"
fileprivate let MIT_TEXT = "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\")"
fileprivate let BSD_3_CLAUSE_CLEAR_TEXT = "Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met"
fileprivate let ZLIB_TEXT = "This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software."

enum LicenseType: String {
    case unknown = "Unknown License"
    case apache_2 = "Apache license 2.0"
    case mit = "MIT License"
    case bsd_3_clause_clear = "BSD 3-clause Clear license"
    case zlib = "zLib License"

    init(licenseText: String) {
        let text = licenseText.replace(pattern: #"(  +|\n)"#, expect: " ")

        if text.contains("Apache License") || text.contains(APACHE_2_TEXT) {
            self = .apache_2
        } else if text.hasPrefix("MIT License") || text.contains(MIT_TEXT) {
            self = .mit
        } else if text.contains(BSD_3_CLAUSE_CLEAR_TEXT) {
            self = .bsd_3_clause_clear
        } else if text.contains(ZLIB_TEXT) {
            self = .zlib
        } else {
            self = .unknown
        }
    }
}
