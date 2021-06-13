//
//  UImage.swift
//  Koniz
//
//  Created by Mostafa Mahmoud on 6/14/21.
//

import UIKit

extension UIImage {
    
    func writeImageToDocs(imageName: String){
        let documentsPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")
            as String
        let destinationPath = URL(fileURLWithPath: documentsPath).appendingPathComponent(imageName)

        debugPrint("destination path is",destinationPath)

        do {
            try self.pngData()?.write(to: destinationPath)
        } catch {
            debugPrint("writing file error", error)
        }
        
    }
    
    func readImageFromDocs(imageName: String)->String?{
        let documentsPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")
            as String

        let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(imageName).path
        if FileManager.default.fileExists(atPath: filePath) {
            return filePath
        } else {
            return nil
        }
    }
    
    func deleteImageFromDocs(imageName: String){

        // Fine documents directory on device
        let documentsPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")
            as String
        let filePath = documentsPath.appendingFormat("/" + imageName)

        do {
            let fileManager = FileManager.default

            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }

        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
}
