//
//  HomeView.swift
//  UberSwiftUIClone
//
//  Created by Ahmed Fouad on 06/11/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        UberMapViewRepresentable()
            .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
