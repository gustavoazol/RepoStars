//
//  GitHubServicesTests.swift
//  RepoStarsTests
//
//  Created by Gustavo Azevedo de Oliveira on 17/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
import Moya

@testable import RepoStars

class GitHubServicesTests: QuickSpec {
	override func spec() {
		describe("GitHub Services Class") {
			var ghServices: GitHubServices!
			var scheduler: TestScheduler!
			
			beforeEach {
				let provider = MoyaProvider<GitHubAPI>(stubClosure: MoyaProvider.immediatelyStub)
				ghServices = GitHubServices(provider: provider)
				
				scheduler = TestScheduler(initialClock: 0)
			}
			
			it("must be able to fetch and return the repositories") {
				let res = scheduler.start({ ghServices.getSwiftRepositories().asObservable() })
				let resultRepos = res.events.first?.value.element?.repositories
				expect(resultRepos?.count).to(equal(2)) // json stub number o repos
			}
		}
	}
}
