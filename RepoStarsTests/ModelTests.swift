//
//  ModelTests.swift
//  RepoStarsTests
//
//  Created by Gustavo Azevedo de Oliveira on 17/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Quick
import Nimble
@testable import RepoStars

class ModelTests: QuickSpec {
	override func spec() {
		describe("Repository model") {
			context("when receiving a valid json data") {
				var jsonData: Data!
				
				beforeEach {
					jsonData = StubRepoJson.asData()
				}
				
				it("must be decoded correctly") {
					do {
						let repository = try JSONDecoder().decode(Repository.self, from: jsonData)
						expect(repository.name).to(equal("awesome-ios"))
						expect(repository.repositoryUrl).to(equal("https://github.com/vsouza/awesome-ios"))
						expect(repository.description).to(equal("A curated list of awesome iOS ecosystem, including Objective-C and Swift Projects "))
						expect(repository.starsCount).to(equal(32648))
						
						expect(repository.owner.username).to(equal("vsouza"))
						expect(repository.owner.avatarUrl).to(equal("https://avatars2.githubusercontent.com/u/484656?v=4"))
					}
					catch {
						print(error.localizedDescription)
						fail("could not decode json data")
					}
				}
			}
		}
	}
}
