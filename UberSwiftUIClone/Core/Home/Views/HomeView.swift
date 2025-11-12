//
//  HomeView.swift
//  UberSwiftUIClone
//
//  Created by Ahmed Fouad on 06/11/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var showLocationSearchView = false
    
    var body: some View {
        ZStack(alignment: .top) {
            UberMapViewRepresentable()
                .ignoresSafeArea()

            if showLocationSearchView {
                LocationSearchView(
                    showLocaitonSearchView: $showLocationSearchView)
            } else {
                LocationSearchActiviationView()
                    .padding(.top, 72)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showLocationSearchView.toggle()
                        }
                    }
            }

            MapViewActionButton(showLocationSearchView: $showLocationSearchView)
                .padding(.leading)
                .padding(.top, 4)
        }
    }
}

#Preview {
    HomeView()
}
