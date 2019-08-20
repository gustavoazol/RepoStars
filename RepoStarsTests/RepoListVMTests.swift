//
//  RepoListVMTests.swift
//  RepoStarsTests
//
//  Created by Gustavo Azevedo de Oliveira on 18/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
import RxCocoa
@testable import RepoStars

class RepoListVMTests: QuickSpec {
	
	override func spec() {
		let stubServices = StubGitServices()
		var viewModel: RepoListVM!
		var bag: DisposeBag!
		
		describe("RepoListVM") {
			beforeEach {
				viewModel = RepoListVM(serviceProvider: stubServices)
				bag = DisposeBag()
			}
			
			context("When controller loads") {
				it("should start general list loading, fetch repositories and stop loading") {
					let scheduler = TestScheduler(initialClock: 0)
					
					let loading = scheduler.createObserver(Bool.self)
					viewModel.output.initialLoading.drive(loading).disposed(by: bag)
					
					let repos = scheduler.createObserver([Repository].self)
					viewModel.output.respositories.drive(repos).disposed(by: bag)
					
					scheduler.createColdObservable([ next(250, ()) ])
						.bind(to: viewModel.input.viewDidLoad)
						.disposed(by: bag)
					
					scheduler.start()
		
					expect(loading.events.compactMap{$0.value.element}).to(equal([false, true, false]))
					expect(repos.events.count).to(equal(1))
					expect(repos.events.first?.value.element?.count).to(equal(2))
				}
			}
		}
	}
}


class StubGitServices: GitHubServices {
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
			return Observable<GitHubResponse>.error(StubError.requesFailed).asSingle()
		}
	}
}
