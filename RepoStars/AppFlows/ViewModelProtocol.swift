//
//  ViewModelProtocol.swift
//  RepoStars
//
//  Created by Gustavo Azevedo de Oliveira on 18/08/19.
//  Copyright © 2019 Gustavo Azevedo de Oliveira. All rights reserved.
//

import Foundation

protocol ViewModel {
	associatedtype Input
	associatedtype Output
	
	var input: Input { get }
	var output: Output { get }
}
