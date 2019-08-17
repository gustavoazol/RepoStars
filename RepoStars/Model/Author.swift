//
//  Author.swift
//  RepoStars
//
//  Created by Gustavo Azevedo de Oliveira on 16/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Foundation

struct Author: Decodable {
	let username: String
	let avatarUrl: String
	
	enum AuthorKeys: String, CodingKey {
		case username = "login"
		case avatarUrl = "avatar_url"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: AuthorKeys.self)
		
		self.username = try container.decode(String.self, forKey: .username)
		self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
	}
}
