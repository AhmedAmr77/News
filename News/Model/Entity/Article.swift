//
//  Article.swift
//  News
//
//  Created by Ahmd Amr on 26/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import Foundation

struct Article: Codable {
    let source: Source
//    let author: String?
    let description: String?
    let title: String
//    let url: String
    let urlToImage: String?
}
