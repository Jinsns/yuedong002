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
    
    @Published var isShowSettingsView: Bool = false
    @Published var isShowAlarmSettingView: Bool = false
    @Published var isOpenAlarm: Bool = false
    @Published var alarmInterval = 1
    @Published var isBlurScene = false
    
    @Published var isShowHandSupportView = false
    @Published var isHandSupportReminded = false
    
    @Published var isShowWow = false
    @Published var isShowedWow = false
    @Published var isShowTaikula = false
    @Published var isShowedTaikula = false
    @Published var isShowLikeyou = false
    @Published var isShowedLikeyou = false
    
    @Published var isShowListenRemindView = false
    @Published var listenRemindViewShowed = false
    @Published var isShowTasteGoodView = false
    @Published var tasteGoodViewShowed = false
    
    @Published var isLeftPlayed: Bool = false
    @Published var isRightPlayed: Bool = false
    @Published var isUpPlayed: Bool = false
    @Published var isDownPlayed: Bool = false
    
    func reset2DefaultValue() {
//        self.isShowFilter15s = false
//        self.isShowAirpodsReminder = true
//        self.isShowCorrectingPositionView = false
//        self.isShowNodToEatView = false
//        self.isSnapShotted = false
//        self.isShowCannotSeeHigherView = false
//        self.isShowCannotSeeLowerView = false
        
//        self.capturedImage: UIImage?
        
        self.isShowSettingsView = false
        self.isShowAlarmSettingView = false
        self.isOpenAlarm = false
        self.alarmInterval = 1
        self.isBlurScene = false
        
        self.isShowHandSupportView = false
        self.isHandSupportReminded = false
        
        self.isShowWow = false
        self.isShowedWow = false
        self.isShowTaikula = false
        self.isShowedTaikula = false
        self.isShowLikeyou = false
        self.isShowedLikeyou = false
        
        self.isShowListenRemindView = false
        self.listenRemindViewShowed = false
        self.isShowTasteGoodView = false
        self.tasteGoodViewShowed = false
        
        self.isLeftPlayed = false
        self.isRightPlayed = false
        self.isUpPlayed = false
        self.isDownPlayed = false
    }
    
    
}
