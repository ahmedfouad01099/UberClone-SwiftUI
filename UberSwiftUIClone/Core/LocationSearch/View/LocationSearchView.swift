//
//  LocationSearchView.swift
//  UberSwiftUIClone
//
//  Created by Ahmed Fouad on 06/11/2025.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @Binding var showLocaitonSearchView: Bool
    @EnvironmentObject var viewModel: LocationSearchViewModel

    var body: some View {
        VStack {
            // header view
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)

                    Rectangle()
                        .fill()
                        .frame(width: 1, height: 24)

                    Circle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }

                VStack {
                    TextField("Current location", text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)

                    TextField("Where to?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.leading)
            .padding(.top, 64)

            Divider()
                .padding(.vertical)
            // list view
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                        LocationSearchResultCell(
                            title: result.title, subtitle: result.subtitle
                        )
                        .onTapGesture {
                            viewModel.selectLocation(result)
                            showLocaitonSearchView.toggle()
                        }
                    }
                }
            }

        }
        .background(.white)
    }
}

#Preview {
    LocationSearchView(showLocaitonSearchView: .constant(false))
}
