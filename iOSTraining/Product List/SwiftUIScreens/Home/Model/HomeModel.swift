//
//  HomeModel.swift
//  iOSTraining
//
//  Created by Cedrick Agtong - INTERN on 3/4/26.
//

import Foundation

struct HomeCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

struct HomeBanner: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let badge: String
    let gradientColors: [String]
}
