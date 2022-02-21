//
//  ArticleDetailViewController.swift
//  igFxRelated
//
//  Created by Robin Macharg on 19/02/2022.
//

import UIKit

/**
 * Displays details of an article - title, image, authro etc.
 */
class ArticleDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var articletTitle: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var articleContent: UILabel!
    
    // MARK: - Properties
    
    // The article.  Injected.
    var article: Article!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Kick off the image download, if any
        if let url = article.headlineImageURL {
            print(url)
            API.shared.getData(url: url) { [self] result in

                switch result {
                case .failure(let error):
                    print("failure: \(error.description)")
                case .success(let imageData):
                    print("success", imageData as! NSData)
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.mainImage.image = image
                        }
                    }
                }
            }
        }
        
        articletTitle.text = article.title
        articleDescription.text = article.articleDescription
        articleContent.text = article.content
        if let authors = article.authors?
            .map({ $0.name ?? "" })
            .joined(separator: ", ")
        {
            articleAuthor.text = "By \(authors)"
        }
    }
}
