//
//  GitHubServices.swift
//  RepoStars
//
//  Created by Gustavo Azevedo de Oliveira on 16/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class GitHubServices {
	private let provider: MoyaProvider<GitHubAPI>
	
	init(provider: MoyaProvider<GitHubAPI> = MoyaProvider<GitHubAPI>() ) {
		self.provider = provider
	}
	
	func getSwiftRepositories(page: Int = 1) -> Single<GitHubResponse> {
		let swiftQuery = "language:swift"
		
		let response = provider.rx
			.request(.searchRepositories(query: swiftQuery, pageNumber: page))
			.filterSuccessfulStatusCodes()
			.asObservable().share()
		
		let pagesLeft = response.map { [weak self] (moyaResponse) -> Int? in
			return self?.parseHeaderForLastPage(responseHeader: moyaResponse.response?.allHeaderFields)
		}
		
		let decodedJson = response
			.map(GitHubResponse.self)
		
		return Observable.zip(pagesLeft, decodedJson) {
				var gitRespose = $1
				gitRespose.lastPage = $0
				return gitRespose
			}
			.asSingle()
	}
	
	private func parseHeaderForLastPage(responseHeader: [AnyHashable: Any]?) -> Int? {
		guard let linkValue = responseHeader?["Link"] as? String else {
			return nil
		}
		
		guard let lastPageString = linkValue.split(separator: ",").first(where: { $0.hasSuffix("rel=\"last\"") }) else {
			return nil
		}
		
		guard let lastPageUrl = lastPageString.split(separator: ";").first?
			.trimmingCharacters(in: .whitespacesAndNewlines)
			.dropFirst().dropLast() else {
				return nil
		}
		
		let urlPath = String(lastPageUrl)
		let queryParams = URLComponents(string: urlPath)?.queryItems
		if let pageStrinValue = queryParams?.first(where: { $0.name == "page" })?.value {
			return Int(pageStrinValue)
		}
		return nil
	}
}

struct GitHubResponse: Decodable {
	let repositories: [Repository]
	var lastPage: Int?
	
	enum ResponseKey: String, CodingKey {
		case items
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ResponseKey.self)
		self.repositories = try container.decode([Repository].self, forKey: .items)
	}
	
	init(repositories: [Repository]) {
		self.repositories = repositories
	}
}
