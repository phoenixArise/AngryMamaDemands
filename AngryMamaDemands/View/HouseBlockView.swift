//
//  HouseBlockView.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-09.
//

import SwiftUI

struct HouseBlockView: View {
    var name: String
    
    var viewModel: HouseViewModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                LinearGradient(
                    gradient: .init(
                        colors: viewModel.colors
                    ),
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            )
            .frame(width: Constant.unit, height: Constant.unit)
            .overlay(
                Image(systemName: "house")
                    .renderingMode(.original)
                    .resizable()
                    .saturation(0)
                    .blendMode(.multiply)
                    .scaledToFit()
            )
            .overlay(
                Text(name)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(10)
                    .frame(alignment: .bottomLeading),
                alignment: .bottomLeading
            )
    }
}


struct HouseBlockView_Previews: PreviewProvider {
    static var previews: some View {
        let houseVM = HouseViewModel()
        HouseBlockView(name: "House", viewModel: houseVM)
    }
}
