//
//  GithubAPI.swift
//  RepoStars
//
//  Created by Gustavo Azevedo de Oliveira on 16/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Moya

enum GitHubAPI {
	case searchRepositories(query: String)
}

extension GitHubAPI: TargetType {
	var baseURL: URL {
		return URL(string: "https://api.github.com")!
	}
	
	var path: String {
		switch self {
		case .searchRepositories:
			return "/search/repositories"
		}
	}
	
	var method: Method {
		return .get
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Task {
		switch self {
		case let .searchRepositories(query):
			return .requestParameters(parameters: ["q": query], encoding: URLEncoding.queryString)
		}
	}
	
	var headers: [String : String]? {
		return [
			"Accept" : "application/vnd.github.v3+json",
			"Content-type": "application/json"
		]
	}
}
