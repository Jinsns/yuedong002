//
//  DataModel.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/29.
//

import Foundation
import CoreGraphics
import UIKit

class DataModel: ObservableObject {
    @Published var isShowFilter15s = false
    @Published var isShowAirpodsReminder = true
    @Published var isShowCorrectingPositionView = false
    @Published var isShowNodToEatView = false
    @Published var isSnapShotted = false
    @Published var isShowCannotSeeHigherView = false
    @Published var isShowCannotSeeLowerView = false
    
    @Published var capturedImage: UIImage?
}
