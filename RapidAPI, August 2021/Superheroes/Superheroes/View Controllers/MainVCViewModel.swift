//
//  MainVCViewModel.swift
//  Superheroes
//
//  Created by Robin Macharg on 04/08/2021.
//
// A simple ViewModel of request history and the currently viewed request

import Foundation

struct MainVCViewModel {
    var history: [Request] = []
    var currentRequest: Request? = nil
}
