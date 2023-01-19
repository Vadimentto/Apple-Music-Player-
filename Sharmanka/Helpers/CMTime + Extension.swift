//
//  CMTime + Extension.swift
//  Sharmanka
//
//  Created by Vadym Potapov on 14.01.2023.
//

import AVKit
import Foundation

extension CMTime {
    
    // стандартная функция приводим время трека в тип string
    
    func toDisplatString() -> String {
        
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self)) // общие колличество минут аудиофайла
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
}
