//
//  Repository.swift
//  RepoStars
//
//  Created by Gustavo Azevedo de Oliveira on 16/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Foundation

struct Repository: Decodable {
	let name: String
	let description: String
	let starsCount: Int
	let repositoryUrl: String
	let owner: Author
	
	enum RepositoryKeys: String, CodingKey {
		case name = "name"
		case description = "description"
		case starsCount = "stargazers_count"
		case repoUrl = "html_url"
		case owner = "owner"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RepositoryKeys.self)
		
		self.name = try container.decode(String.self, forKey: .name)
		self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
		self.starsCount = try container.decode(Int.self, forKey: .starsCount)
		self.repositoryUrl = try container.decode(String.self, forKey: .repoUrl)
		self.owner = try container.decode(Author.self, forKey: .owner)
	}
}

