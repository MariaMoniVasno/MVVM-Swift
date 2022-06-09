//
//  ArticleViewModel.swift
//  Shopify
//
//  Created by Trident on 06/06/22.
//

import Foundation

class ArticleViewModel {
    var detailList:[ArticleModel.articleLists]?
    
    //MARK:- readJsonFile
    func readJsonFile() {
        if let path = Bundle.main.path(forResource: Articles, ofType: json) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(ArticleModel.self, from: data)
                    self.detailList = gitData.articles
                } catch {
                    print(error)
                }
            } catch {
                // handle error
            }
        }
    }
    
    func getAPIService(){
        let url = URL(string: APIUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = POST
        request.addValue(applicationjson, forHTTPHeaderField: ContentType)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {  (data, response, error) in
            guard let data = data else {return}
            let decoder = JSONDecoder()
            guard let employees = try? decoder.decode(ArticleModel.self, from: data) else { return }
            self.detailList = employees.articles
            notificationCenter.post(name: ReloadTableViewNC, object: nil)
        }
        task.resume()
    }
    
    
}
