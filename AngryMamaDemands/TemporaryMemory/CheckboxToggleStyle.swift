//
//  CheckBoxStyle.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-10.
//

import SwiftUI

fileprivate struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button(action: {
            // 2
            configuration.isOn.toggle()
            
        }, label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                
                configuration.label.foregroundColor(.black)
            }
        })
    }
}
