//
//  RideRequestView.swift
//  UberSwiftUIClone
//
//  Created by Ahmed Fouad on 23/11/2025.
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType: RideType = .uberX

    var body: some View {
        VStack {
            ScrollView {
                Capsule()
                    .foregroundColor(Color(.systemGray5))
                    .frame(width: 48, height: 6)
                    .padding()

                HStack {
                    VStack {
                        Circle()
                            .fill(Color(.systemGray3))
                            .frame(width: 8, height: 8)

                        Rectangle()
                            .fill()
                            .frame(width: 1, height: 24)

                        Circle()
                            .fill(.black)
                            .frame(width: 8, height: 8)
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading) {
                        Text("Current Loaction")
                            .font(.headline)
                            .foregroundColor(Color(.systemGray2))
                            .padding(.bottom)

                        Text("Mansura, Egypt")
                            .font(.headline)
                            .foregroundColor(Color(.black))
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("02:55 PM")
                            .font(.headline)
                            .foregroundColor(Color(.systemGray3))
                            .padding(.bottom)

                        Text("03:11 PM")
                            .font(.headline)
                            .foregroundColor(Color(.systemGray3))
                    }
                    .padding()

                }
                .padding(.top, 10)

                Divider()

                VStack(alignment: .leading) {
                    Text("SUGGESTED RIDES")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(.systemGray))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(RideType.allCases) { type in
                                Rectangle()
                                    .fill(
                                        Color(
                                            type == selectedRideType
                                                ? .systemBlue
                                                : .systemGroupedBackground)
                                    )
                                    .frame(width: 120, height: 180)

                                    .scaleEffect(
                                        type == selectedRideType ? 1.05 : 1
                                    )
                                    .cornerRadius(8)
                                    .overlay(
                                        VStack(alignment: .leading, spacing: 0)
                                        {
                                            Image(type.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 120, height: 120)

                                            VStack(
                                                alignment: .leading, spacing: 4
                                            ) {
                                                Text(type.description)
                                                    .font(.headline)
//                                                    .foregroundColor(
//                                                        type == selectedRideType
//                                                            ? .white : .black)

                                                Text("$22.04")
                                                    .font(.headline)
                                                    .foregroundColor(
                                                        type == selectedRideType
                                                            ? .white : .gray)
                                            }
                                            .frame(
                                                maxWidth: .infinity,
                                                alignment: .leading
                                            )
                                            .padding(.horizontal)
                                            .padding(.bottom, 8)  // Add bottom padding only
                                        }
                                    )
                                    .foregroundColor(
                                        type == selectedRideType
                                            ? .white : .black
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedRideType = type
                                        }
                                    }
                            }
                        }
                    }

                }
                .padding()

                Button {

                } label: {
                    HStack {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 40)
                            .cornerRadius(8)
                            .overlay {
                                Text("Visa")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                            }

                        Text("*** 1234")
                            .font(.headline)
                            .foregroundColor(Color(.systemGray))

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .padding(10)
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()

                Button {

                } label: {
                    VStack {
                        Text("CONFIRM RIDE")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(14)
                }
                .background(Color.blue.opacity(0.8))
                .cornerRadius(8)
                .padding()
            }
            .background(.white)
            .frame(maxHeight: 500)
            .cornerRadius(12)
        }
    }
}

#Preview {
    RideRequestView()
}
