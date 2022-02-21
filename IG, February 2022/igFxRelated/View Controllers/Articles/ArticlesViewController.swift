//
//  ArticlesViewController.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

import UIKit

class ArticlesViewController: UITableViewController {

    // MARK: - Outlets
    
    // None required; not accessed directly.
    
    // MARK: - Properties
    
    var model = ArticlesViewControllerModel()
    
    private var loadingIndicator: UIAlertController?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add pull-to-refresh capability, ensuring that the control is under the table
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl?.layer.zPosition = -1
        
        // TODO: fix auto row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        loadData()
    }
        
    // MARK: - Actions
    
    /**
     * Load the data for this VC asynchronously
     */
    func loadData() {
        // TODO: add a cancellable delay to this, to allow a second or so before
        // displaying anything.  This would avoid a brief flash of the loading
        // indicator in cases where network access is fast enough.
        loadingIndicator = self.showBusyIndicator(message: "Loading Articles...")
        
        API.shared.getArticles { [self] result in
            hideBusyIndicator(loader: loadingIndicator)
            
            switch result {
            case .failure(let error):
                print("failure: \(error.description)") // TODO: error handling
            case .success(let articles):
                self.model.updateArticles(articles)
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    if refreshControl?.isRefreshing ?? false {
                        refreshControl?.endRefreshing()
                    }
                    tableView.reloadData()
                }
            }
        }
    }
    
    /**
     * Called by the table pull-to-refresh
     */
    @objc private func refresh(_ sender: AnyObject) {
        loadData()
    }
}

// MARK: - <UITableViewDelegate>

extension ArticlesViewController {
    
    /**
     * Navigate to the detailed Article view
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let article = articleFrom(indexPath: indexPath) else { return }
        
        performSegue(withIdentifier: Segues.ShowArticleDetails, sender: article)
    }
    
    // MARK: - Navigation
    
    /**
     * Prepare to move to the detailed Article VC.
     * The Article in question (passed as 'sender') is injected into the detail VC.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ShowArticleDetails {
            guard let article = sender as? Article else { return }
            if let detailVC = segue.destination as? ArticleDetailViewController {
                detailVC.article = article
            }
        }
    }
}

// MARK: - <UITableViewDataSource>

extension ArticlesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.articles == nil ? 0 : 7 // hardcoded
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = rowsInSection(section) else { return 0 }
        
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let article = articleFrom(indexPath: indexPath),
              let cell = tableView.dequeueReusableCell(
                withIdentifier: "ArticleCell",
                for: indexPath) as? ArticleCell
        else {
            // TODO: add failure state to UI
            return UITableViewCell()
        }
        
        cell.title.text = article.title
        
        return cell
    }
    
    /**
     * Return an article for a given section and row
     */
    private func articleFrom(indexPath: IndexPath) -> Article? {
        
        guard let articles = model.articles else {
            return nil
        }
        
        let articlesData: [Article]
        
        switch ArticlesSection(rawValue: indexPath.section) {
        case .breakingNews:
            articlesData = articles.breakingNews ?? []
        case .topNews:
            articlesData = articles.topNews ?? []
        case .techicalkAnalysis:
            articlesData = articles.technicalAnalysis ?? []
        case .specialReport:
            articlesData = articles.specialReport ?? []
        case .dailyBriefingsEU:
            articlesData = articles.dailyBriefings?.eu ?? []
        case .dailyBriefingsAsia:
            articlesData = articles.dailyBriefings?.asia ?? []
        case .dailyBriefingsUS:
            articlesData = articles.dailyBriefings?.us ?? []
        case .none:
            fatalError("Unexpected market section")
        }

        let article = articlesData[indexPath.row]
        
        return article
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        guard var text = ArticlesSection(rawValue: section)?.displayValue else {
            return "Unknown Article Type"
        }
        
        if let items = rowsInSection(section) {
            text += " (\(items) items)"
        }
        
       return text
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}

// MARK: - Helpers

extension ArticlesViewController {
    
    /**
     * Returns the number of rows in an article section, or nil when data is not available.
     */
    func rowsInSection(_ section: Int) -> Int? {
        
        guard let articles = model.articles else { return nil }
        
        switch ArticlesSection(rawValue: section) {
        case .breakingNews:
            return articles.breakingNews?.count ?? 0
        case .topNews:
            return articles.topNews?.count ?? 0
        case .techicalkAnalysis:
            return articles.technicalAnalysis?.count ?? 0
        case .specialReport:
            return articles.specialReport?.count ?? 0
        case .dailyBriefingsEU:
            return articles.dailyBriefings?.eu?.count ?? 0
        case .dailyBriefingsAsia:
            return articles.dailyBriefings?.asia?.count ?? 0
        case .dailyBriefingsUS:
            return articles.dailyBriefings?.us?.count ?? 0
        case .none:
            return nil
        }
    }
}
