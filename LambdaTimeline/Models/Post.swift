//
//  Post.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//
//swiftlint:disable function_default_parameter_at_end

import Foundation
import FirebaseAuth

enum MediaType: String {
	case image
}

class Post {

	var mediaURL: URL
	let mediaType: MediaType
	let author: Author
	let timestamp: Date
	var comments: [Comment]
	var id: String?
	var ratio: CGFloat?

	var title: String? {
		return comments.first?.text
	}

	private static let mediaKey = "media"
	private static let ratioKey = "ratio"
	private static let mediaTypeKey = "mediaType"
	private static let authorKey = "author"
	private static let commentsKey = "comments"
	private static let timestampKey = "timestamp"
	private static let idKey = "id"

	init(title: String, mediaURL: URL, ratio: CGFloat? = nil, author: Author, timestamp: Date = Date()) {
		self.mediaURL = mediaURL
		self.ratio = ratio
		self.mediaType = .image
		self.author = author
		self.comments = [Comment(text: title, author: author)]
		self.timestamp = timestamp
	}
	
	init?(dictionary: [String: Any], id: String) {
		guard let mediaURLString = dictionary[Post.mediaKey] as? String,
			let mediaURL = URL(string: mediaURLString),
			let mediaTypeString = dictionary[Post.mediaTypeKey] as? String,
			let mediaType = MediaType(rawValue: mediaTypeString),
			let authorDictionary = dictionary[Post.authorKey] as? [String: Any],
			let author = Author(dictionary: authorDictionary),
			let timestampTimeInterval = dictionary[Post.timestampKey] as? TimeInterval,
			let captionDictionaries = dictionary[Post.commentsKey] as? [[String: Any]] else { return nil }
		
		self.mediaURL = mediaURL
		self.mediaType = mediaType
		self.ratio = dictionary[Post.ratioKey] as? CGFloat
		self.author = author
		self.timestamp = Date(timeIntervalSince1970: timestampTimeInterval)
		self.comments = captionDictionaries.compactMap({ Comment(dictionary: $0) })
		self.id = id
	}
	
	var dictionaryRepresentation: [String: Any] {
		var dict: [String: Any] = [Post.mediaKey: mediaURL.absoluteString,
				Post.mediaTypeKey: mediaType.rawValue,
				Post.commentsKey: comments.map({ $0.dictionaryRepresentation }),
				Post.authorKey: author.dictionaryRepresentation,
				Post.timestampKey: timestamp.timeIntervalSince1970]
		
		guard let ratio = self.ratio else { return dict }
		
		dict[Post.ratioKey] = ratio
		
		return dict
	}
}
