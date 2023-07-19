//
//  MoonRiverInfo.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/6.
//

import Foundation


// MoonRiver
//速度85（每分钟85拍），16小节，3/4拍
//一拍=60/85 = 12/17 ～=0.7059 秒
//一小节 = 12/17 * 3 ～= 2.1176秒
//两个小节 = 72 / 17
//两个小节一个方向，
//    1～2小节前，【0 : 72/17）; 第一小节结束时间在 （36 + 72*0）/17，sweatArea设置在【24/17～48/17】
//    3～4后，【72/17 ： 72*2 / 17），第三小节结束时间在（36+72*1）/17， sweatArea设置在[(24+72*1)/17 ～ (48 + 72 * 1)/17]
//    5～6左，7～8右，9～10 前。。。


//var moonRiverInfo = [String: Any]()
//moonRiverInfo["bpm"] = 85
//moonRiverInfo["timeSignature"] = "3/4"
//moonRiverInfo["secondPerBeat"] = 12.0 / 17
//moonRiverInfo["beats"] = [
//    "beat1": [
//        "moment":(36.0 + 72.0 * 0) / 17,
//        "direction": "forward"
//    ],
//    "beat2": [
//        "moment":(36.0 + 72.0 * 1) / 17,
//        "direction": "backward"
//    ],
//    "beat3": [
//        "moment":(36.0 + 72.0 * 2) / 17,
//        "direction": "anticlock"],
//    "beat4": [
//        "moment":(36.0 + 72.0 * 3) / 17,
//        "direction": "clockwise"
//    ],
//    "beat5": [
//        "moment":(36.0 + 72.0 * 4) / 17,
//        "direction": "forward"
//    ],
//    "beat6": [
//        "moment":(36.0 + 72.0 * 5) / 17,
//        "direction": "backward"
//    ],
//    "beat7": [
//        "moment":(36.0 + 72.0 * 6) / 17,
//        "direction": "anticlock"
//    ],
//    "beat8": [
//        "moment":(36.0 + 72.0 * 7) / 17,
//        "direction": "clockwise"
//    ],
//]


struct MusicInfo: Codable {
    var bpm: String
    var timeSignature: String
    var secondPerBeat: Double
    var beats: [Beat]
    
}

struct Beat: Codable {
    var moment: Double
    var direction: String
    var perfectArea: [Double]
    var greatArea: [Double]
    var goodArea: [Double]
    var badArea: [Double]
}

func parseMusicInfo(musicName: String) -> MusicInfo? {
    guard let url = Bundle.main.url(forResource: musicName, withExtension: "json") else {
        return nil
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        var musicInfo = try decoder.decode(MusicInfo.self, from: data)
        return musicInfo
    } catch {
        print("Failed to read or parse JSON: \(error)")
        return nil
    }
}


func judgeMovementPerformance(musicInfo: MusicInfo, movementTime: Double, movementDirection: String) -> String {
    var bpm = musicInfo.bpm
    var timeSignature = musicInfo.timeSignature
    var secondPerBeat = musicInfo.secondPerBeat
    var beats = musicInfo.beats
    for var beat in beats {
        var moment = beat.moment
        var direction = beat.direction
        beat.perfectArea = [moment - 0.5 * secondPerBeat, moment + 0.5 * secondPerBeat]
        beat.greatArea = [moment - 1.0 * secondPerBeat, moment + 1.0 * secondPerBeat]
        beat.goodArea = [moment - 1.5 * secondPerBeat, moment + 1.5 * secondPerBeat]
        beat.badArea = [moment - 2.0 * secondPerBeat, moment + 2.0 * secondPerBeat]
        
        if beat.perfectArea[0]...beat.perfectArea[1] ~= movementTime {
            if movementDirection == direction {
                return "Perfect"
            }
        } else if beat.greatArea[0]...beat.greatArea[1] ~= movementTime {
            if movementDirection == direction {
                return "great"
            }
        } else if beat.goodArea[0]...beat.goodArea[1] ~= movementTime {
            if movementDirection == direction {
                return "good"
            }
        } else if beat.badArea[0]...beat.badArea[1] ~= movementTime {
            if movementDirection == direction {
                return "bad"
            }
        } else {
            return "miss"
        }
        
    }
    return "error"
}



