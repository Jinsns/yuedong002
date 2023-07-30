//
//  MotionStateView.swift
//  yuedong002
//
//  Created by Jzh on 2023/6/24.
//

import SwiftUI


func getFileURLs() -> [URL] {
        do {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
            return fileURLs
        } catch {
            print("无法获取文档目录中的文件URL列表：\(error)")
            return []
        }
}


struct MotionStateView : View {
    let motionManager: MotionManager

    @Binding var topBackward: Bool
    @Binding var topForward: Bool
    @Binding var antiClock: Bool
    @Binding var clockWise: Bool
    
    var body: some View {
//        let _ = Self._printChanges()
        Text("topBackward: \(String(topBackward))")
        Text("topForward: \(String(topForward))")
        Text("clockWise: \(String(clockWise))")
        Text("antiClock: \(String(antiClock))")
    }
    
}


struct CheckHeadStateView : View {
    let motionManager: MotionManager
    
    var body: some View {
        VStack {
            Text("前后方向：\(motionManager.pitch) ")
            Text("左右方向：\(motionManager.roll) ")
        }
    }
}

struct FileItem: View {
    var fileURL: URL
    var bgmSystem: BgmSystem
    var uploader: Uploader
    @Binding var username: String
    @Binding var musicDescription: String
    @Binding var fileURLs: [URL]
    
        
    var body: some View {
        
        HStack {
            Text(fileURL.lastPathComponent)
            Spacer()
            Button(action: {
                // 播放按钮的操作
                playFile()
            }) {
                Label("", systemImage: "play.circle")
            }
            .buttonStyle(IconOnlyButtonStyle()) // 使按钮仅显示图标
            Button(action: {
                // 上传按钮的操作
                uploadFile()
            }) {
                Label("", systemImage: "arrow.up.circle")
            }
            .buttonStyle(IconOnlyButtonStyle()) // 使按钮仅显示图标
            
            Button(action: {
                removeFile()
                
                
            }) {
                Label("", systemImage: "trash")
            }
            .buttonStyle(IconOnlyButtonStyle())
        }
        
    }
    
    func playFile() {
        // 执行播放文件的逻辑
        print("播放文件：\(fileURL.path)")
//        var bgmSystem = BgmSystem()
        bgmSystem.play()
    }
    
    func uploadFile() {
        // 执行上传文件的逻辑
        print("上传文件：\(fileURL.path)")
        uploader.startUpload(filePath: fileURL.path, username: username, musicDescription: musicDescription)
        
    }
    
    func removeFile(){
        print("删除文件：\(fileURL.path)")
        print("removing \(fileURL.path)")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                //if exist, remove the original file first
                try FileManager.default.removeItem(at: fileURL)
                print("file removed: \(fileURL.path)")
                fileURLs = getFileURLs()
            } catch {
                print("error when removing file: \(fileURL.path)")
            }
        }
            
        
    }
        
    
    
}


struct DownloaderView: View {
    let downloader: Downloader
    
    @Binding var username: String
    @Binding var fileURLs: [URL]
    
    @State private var isDownloading = false
    
    
    var body: some View {
        VStack {
            Button(action: {
                startDownload()
            }) {
                HStack {
                    Image(systemName: isDownloading ? "square.and.arrow.down.fill" : "square.and.arrow.down")
                    Text(isDownloading ? "正在下载" : "下载文件")
                }
                .padding()
                .foregroundColor(.white)
                .background(isDownloading ? Color.blue : Color.green)
                .cornerRadius(10)
            }
        }
    }
    
    private func startDownload(){
        isDownloading = true
        
        //
//
        //download
        let downloader = Downloader()
        let downloadFromURL = URL(string: "http://10.112.184.124:8989/download/\(username)/0.mp3")!
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let downloadToFileURL = documentDirectory.appendingPathComponent("optimized.mp3")
        downloader.load(serverURL: downloadFromURL, localUrl: downloadToFileURL)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            isDownloading = false
            fileURLs = getFileURLs()
        })
        
    }
    
    
}


struct IconOnlyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle()) // Set the content shape to a rectangle
            .padding(10) // Add padding to provide spacing around the icon
    }
}
