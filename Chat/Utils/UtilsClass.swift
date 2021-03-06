//
//  UtilsClass.swift
//  Chat
//
//  Created by IMRAN on 01/05/21.
//

import Foundation
import AVFoundation
import UIKit


class UtilsClass {
    
    class func convertUTCtoLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //
        guard let dateValue = dateFormatter.date(from: date) else { return ""}
        let currentDate = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: dateValue as Date, to: currentDate)
        
        if differenceOfDate.day! > 0 {
            if let date = dateFormatter.date(from: date as String){
                dateFormatter.dateFormat = "dd/MM/yy"
                return dateFormatter.string(from: date)
            }else {
                return ""
            }
        }else {
            if let date = dateFormatter.date(from: date as String){
                dateFormatter.dateFormat = "hh:mm a"
                return dateFormatter.string(from: date)
            }else {
                return ""
            }
        }
        
        //
         
    }
    
    class func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
}
