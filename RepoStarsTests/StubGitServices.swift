//
//  StubGitServices.swift
//  RepoStarsTests
//
//  Created by Gustavo Azevedo de Oliveira on 24/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Foundation
import RxSwift
@testable import RepoStars

class StubDidLoadGitServices: GitHubServices {
	enum StubError: Error {
		case requesFailed
	}
	
	var completeRequestWithSuccess = true
	
	private func createStubRepo() -> Repository {
		let jsonData = StubRepoJson.asData()
		let repository = try! JSONDecoder().decode(Repository.self, from: jsonData)
		return repository
	}
	
	override func getSwiftRepositories() -> Single<GitHubResponse> {
		if completeRequestWithSuccess {
			let repo = createStubRepo()
			let response = GitHubResponse(repositories: [repo, repo])
			return Observable.just(response).asSingle()
		}
		else {
			return Single<GitHubResponse>.error(StubError.requesFailed)
		}
	}
}

class StubRefreshGitServices: GitHubServices {
	enum StubError: Error {
		case requesFailed
	}
	
	var completeRequestWithSuccess = true
	var refreshCall = false
	
	private func createStubRepo() -> Repository {
		let jsonData = StubRepoJson.asData()
		let repository = try! JSONDecoder().decode(Repository.self, from: jsonData)
		return repository
	}
	
	override func getSwiftRepositories() -> Single<GitHubResponse> {
		let completeWithSuccess = refreshCall ? completeRequestWithSuccess : true
		let returnNumber = refreshCall ? 4 : 2
		refreshCall = true
		
		if completeWithSuccess {
			let repo = createStubRepo()
			
			var repositories = [Repository]()
			for _ in 0..<(returnNumber) {
				repositories.append(repo)
			}
			
			let response = GitHubResponse(repositories: repositories)
			return Observable.just(response).asSingle()
		}
		else {
			return Single<GitHubResponse>.error(StubError.requesFailed)
		}
	}
}
