//
//  StubRepoJson.swift
//  RepoStarsTests
//
//  Created by Gustavo Azevedo de Oliveira on 20/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Foundation

struct StubRepoJson {
	static func asData() -> Data {
		return self.asString().data(using: .utf8)!
	}
	
	static func asString() -> String {
		return """
		{
			"id": 21700699,
			"node_id": "MDEwOlJlcG9zaXRvcnkyMTcwMDY5OQ==",
			"name": "awesome-ios",
			"full_name": "vsouza/awesome-ios",
			"private": false,
			"owner": {
				"login": "vsouza",
				"id": 484656,
				"node_id": "MDQ6VXNlcjQ4NDY1Ng==",
				"avatar_url": "https://avatars2.githubusercontent.com/u/484656?v=4",
				"gravatar_id": "",
				"url": "https://api.github.com/users/vsouza",
				"html_url": "https://github.com/vsouza",
				"followers_url": "https://api.github.com/users/vsouza/followers",
				"following_url": "https://api.github.com/users/vsouza/following{/other_user}",
				"gists_url": "https://api.github.com/users/vsouza/gists{/gist_id}",
				"starred_url": "https://api.github.com/users/vsouza/starred{/owner}{/repo}",
				"subscriptions_url": "https://api.github.com/users/vsouza/subscriptions",
				"organizations_url": "https://api.github.com/users/vsouza/orgs",
				"repos_url": "https://api.github.com/users/vsouza/repos",
				"events_url": "https://api.github.com/users/vsouza/events{/privacy}",
				"received_events_url": "https://api.github.com/users/vsouza/received_events",
				"type": "User",
				"site_admin": false
			},
			"html_url": "https://github.com/vsouza/awesome-ios",
			"description": "A curated list of awesome iOS ecosystem, including Objective-C and Swift Projects ",
			"fork": false,
			"url": "https://api.github.com/repos/vsouza/awesome-ios",
			"forks_url": "https://api.github.com/repos/vsouza/awesome-ios/forks",
			"keys_url": "https://api.github.com/repos/vsouza/awesome-ios/keys{/key_id}",
			"collaborators_url": "https://api.github.com/repos/vsouza/awesome-ios/collaborators{/collaborator}",
			"teams_url": "https://api.github.com/repos/vsouza/awesome-ios/teams",
			"hooks_url": "https://api.github.com/repos/vsouza/awesome-ios/hooks",
			"issue_events_url": "https://api.github.com/repos/vsouza/awesome-ios/issues/events{/number}",
			"events_url": "https://api.github.com/repos/vsouza/awesome-ios/events",
			"assignees_url": "https://api.github.com/repos/vsouza/awesome-ios/assignees{/user}",
			"branches_url": "https://api.github.com/repos/vsouza/awesome-ios/branches{/branch}",
			"tags_url": "https://api.github.com/repos/vsouza/awesome-ios/tags",
			"blobs_url": "https://api.github.com/repos/vsouza/awesome-ios/git/blobs{/sha}",
			"git_tags_url": "https://api.github.com/repos/vsouza/awesome-ios/git/tags{/sha}",
			"git_refs_url": "https://api.github.com/repos/vsouza/awesome-ios/git/refs{/sha}",
			"trees_url": "https://api.github.com/repos/vsouza/awesome-ios/git/trees{/sha}",
			"statuses_url": "https://api.github.com/repos/vsouza/awesome-ios/statuses/{sha}",
			"languages_url": "https://api.github.com/repos/vsouza/awesome-ios/languages",
			"stargazers_url": "https://api.github.com/repos/vsouza/awesome-ios/stargazers",
			"contributors_url": "https://api.github.com/repos/vsouza/awesome-ios/contributors",
			"subscribers_url": "https://api.github.com/repos/vsouza/awesome-ios/subscribers",
			"subscription_url": "https://api.github.com/repos/vsouza/awesome-ios/subscription",
			"commits_url": "https://api.github.com/repos/vsouza/awesome-ios/commits{/sha}",
			"git_commits_url": "https://api.github.com/repos/vsouza/awesome-ios/git/commits{/sha}",
			"comments_url": "https://api.github.com/repos/vsouza/awesome-ios/comments{/number}",
			"issue_comment_url": "https://api.github.com/repos/vsouza/awesome-ios/issues/comments{/number}",
			"contents_url": "https://api.github.com/repos/vsouza/awesome-ios/contents/{+path}",
			"compare_url": "https://api.github.com/repos/vsouza/awesome-ios/compare/{base}...{head}",
			"merges_url": "https://api.github.com/repos/vsouza/awesome-ios/merges",
			"archive_url": "https://api.github.com/repos/vsouza/awesome-ios/{archive_format}{/ref}",
			"downloads_url": "https://api.github.com/repos/vsouza/awesome-ios/downloads",
			"issues_url": "https://api.github.com/repos/vsouza/awesome-ios/issues{/number}",
			"pulls_url": "https://api.github.com/repos/vsouza/awesome-ios/pulls{/number}",
			"milestones_url": "https://api.github.com/repos/vsouza/awesome-ios/milestones{/number}",
			"notifications_url": "https://api.github.com/repos/vsouza/awesome-ios/notifications{?since,all,participating}",
			"labels_url": "https://api.github.com/repos/vsouza/awesome-ios/labels{/name}",
			"releases_url": "https://api.github.com/repos/vsouza/awesome-ios/releases{/id}",
			"deployments_url": "https://api.github.com/repos/vsouza/awesome-ios/deployments",
			"created_at": "2014-07-10T16:03:45Z",
			"updated_at": "2019-08-17T20:01:28Z",
			"pushed_at": "2019-08-13T18:33:04Z",
			"git_url": "git://github.com/vsouza/awesome-ios.git",
			"ssh_url": "git@github.com:vsouza/awesome-ios.git",
			"clone_url": "https://github.com/vsouza/awesome-ios.git",
			"svn_url": "https://github.com/vsouza/awesome-ios",
			"homepage": "http://awesomeios.com",
			"size": 10123,
			"stargazers_count": 32648,
			"watchers_count": 32648,
			"language": "Swift",
			"has_issues": true,
			"has_projects": false,
			"has_downloads": true,
			"has_wiki": false,
			"has_pages": false,
			"forks_count": 5490,
			"mirror_url": null,
			"archived": false,
			"disabled": false,
			"open_issues_count": 2,
			"license": {
				"key": "mit",
				"name": "MIT License",
				"spdx_id": "MIT",
				"url": "https://api.github.com/licenses/mit",
				"node_id": "MDc6TGljZW5zZTEz"
			},
			"forks": 5490,
			"open_issues": 2,
			"watchers": 32648,
			"default_branch": "master",
			"score": 1.0
		}
		"""
	}
}
