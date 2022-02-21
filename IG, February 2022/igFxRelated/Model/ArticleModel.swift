//
//  ArticleModel.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

import Foundation

/**
 * The top-level article sections
 */
enum ArticlesSection: Int {
    case breakingNews = 0
    case topNews
    case techicalkAnalysis
    case specialReport
    case dailyBriefingsEU
    case dailyBriefingsAsia
    case dailyBriefingsUS
    
    /**
     * Map a market to it's display name
     */
    var displayValue: String {
        switch self {
        case .breakingNews: return "Breaking News"
        case .topNews: return "Top News"
        case .techicalkAnalysis: return "Technical Analysis"
        case .specialReport: return "Special Reports"
        case .dailyBriefingsEU: return "Daily Briefing (EU)"
        case .dailyBriefingsAsia: return "Daily Briefing (Asia)"
        case .dailyBriefingsUS: return "Daily Briefing (US)"
        }
    }
}

// MARK: - Articles

// Note: Based on the incomplete information available for the task the assumption here
// is that we have a fixed number of categories/types of article.
struct Articles: Codable {
    let breakingNews: [Article]?
    let topNews: [Article]?
    let technicalAnalysis: [Article]?
    let specialReport: [Article]?
    let dailyBriefings: DailyBriefings?
}

// MARK: - Article
struct Article: Codable {
    let title: String?
    let url: String?
    let articleDescription: String?
    let content: String?
    let firstImageURL: String?
    let headlineImageURL: String?
    let articleImageURL: String?
    let backgroundImageURL: String?
    let videoType: String?
    let videoID: String?
    let videoURL: String?
    let videoThumbnail: String?
    let newsKeywords: String?
    let authors: [Author]?
    let instruments: [String]?
    let tags: [String]?
    let categories: [String]?
    let displayTimestamp:Int?
    let lastUpdatedTimestamp: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case url
        case articleDescription = "description"
        case content
        case firstImageURL = "firstImageUrl"
        case headlineImageURL = "headlineImageUrl"
        case articleImageURL = "articleImageUrl"
        case backgroundImageURL = "backgroundImageUrl"
        case videoType
        case videoID = "videoId"
        case videoURL = "videoUrl"
        case videoThumbnail, newsKeywords, authors, instruments, tags, categories, displayTimestamp, lastUpdatedTimestamp
    }
}

// MARK: - Author
struct Author: Codable {
    let name: String?
    let title: String?
    let bio: String?
    let email: String?
    let phone: String?
    let facebook: String?
    let twitter: String?
    let googleplus: String?
    let subscription: String?
    let rss: String?
    let descriptionLong: String?
    let descriptionShort: String?
    let photo: String?
}

struct DailyBriefings: Codable {
    let eu: [Article]?
    let asia: [Article]?
    let us: [Article]?
}

// MARK: - URLSession response handlers

extension URLSession {
    
    /**
     * An Articles-specific URLSession task to download and decode Articles JSON
     */
    func articlesTask(
        with url: URL,
        completionHandler: @escaping (Articles?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    {
        return self.codableTask(
            with: url,
            completionHandler: completionHandler)
    }
}

