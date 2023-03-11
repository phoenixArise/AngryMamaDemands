//
//  ViewModel.swift
//  AngryMamaDemands
//
//  Created by Brian Seo on 2023-03-10.
//

import Foundation
import _PhotosUI_SwiftUI

class ViewModel: ObservableObject, Identifiable {
    var id: UUID = UUID()
    @Published var photoData: Data? = nil
    
    func updatePhoto(with selectedPhoto: PhotosPickerItem) async {
        if let data = try? await selectedPhoto.loadTransferable(type: Data.self) {
            photoData = data
        }
    }
}
