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
	
	func getSwiftRepositories() -> Single<GitHubResponse> {
		let swiftQuery = "language:swift"
		
		return provider.rx
			.request(.searchRepositories(query: swiftQuery))
			.filterSuccessfulStatusCodes()
			.map(GitHubResponse.self)
	}
}

struct GitHubResponse: Decodable {
	let repositories: [Repository]
	
	enum ResponseKey: String, CodingKey {
		case items
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ResponseKey.self)
		self.repositories = try container.decode([Repository].self, forKey: .items)
	}
}
