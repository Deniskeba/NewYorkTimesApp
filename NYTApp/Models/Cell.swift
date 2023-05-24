//
//  Cell.swift
//  NYTApp
//
//  Created by Denis Kobylkov on 23.05.2023.
//

import Foundation

final class Cell {
    let title: String
    let byline: String
    let section: String
    let nytdsection: String
    let publishedDate: String
    let image: String
    let media: String
    
    init(title: String, byline: String, section: String, nytdsection: String, publishedDate: String, image: String, media: String) {
        self.title = title
        self.byline = byline
        self.section = section
        self.nytdsection = nytdsection
        self.publishedDate = publishedDate
        self.image = image
        self.media = media
    }
        
        init(StoredCells: StoredCells, isFavorite: Bool = false) {
            self.title = StoredCells.title ?? ""
            self.byline = StoredCells.byline ?? ""
            self.section = StoredCells.section ?? ""
            self.nytdsection = StoredCells.nytdsection ?? ""
            self.publishedDate = StoredCells.publishedDate ?? ""
            self.image = StoredCells.image ?? ""
            self.media = StoredCells.media ?? ""
    }
}
