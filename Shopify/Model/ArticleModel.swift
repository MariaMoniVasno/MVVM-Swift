//
//  ArticleModel.swift
//  Shopify
//
//  Created by Trident on 06/06/22.
//

import Foundation

struct ArticleModel: Codable {
    var articles:[articleLists]?
    var status: String?
    
    //CodingKeys
    enum CodingKeys: String, CodingKey {
        case articles = "articles"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        articles = try values.decode([articleLists].self, forKey: .articles)
        status = try values.decode(String.self, forKey: .status)
    }
    
    struct articleLists:Codable {
        var id: Int?
        var title: String?
        var created_at: String?
        var body_html: String?
        var blog_id: Int?
        var author: String?
        var user_id: Int?
        var published_at: String?
        var updated_at: String?
        var summary_html: String?
        var template_suffix: String?
        var handle: String?
        var tags: String?
        var admin_graphql_api_id: String?
        var image: imageLists?
    }
    
    struct imageLists:Codable {
        var created_at: String?
        var alt: String?
        var width: Int?
        var height: Int?
        var src: String?
    }
}
