//
//  CapturedImageView.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/19.
//

import SwiftUI

struct CapturedImageView: View {
    @Environment(\.presentationMode) var presentationMode //used to close this sheet view
    @EnvironmentObject var dataModel: DataModel
    
    
    
    var body: some View {
        Image(uiImage: dataModel.capturedImage!)
        
    }
}

struct CapturedImageView_Previews: PreviewProvider {
    static var previews: some View {
        CapturedImageView()
    }
}
