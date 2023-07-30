//
//  ViewController.swift
//  yuedong001
//
//  Created by Jzh on 2023/6/21.
//

import UIKit
import CoreAudioKit
import MobileCoreServices
 
class Uploader: UIViewController {
    
    
     
    func startUpload(filePath: String, username: String, musicDescription: String) {
         
        //分隔线
        let boundary = "Boundary-\(UUID().uuidString)"
         
        //传递的参数
        let parameters = [
            "username": username,
            "musicDescription": musicDescription
        ]
         
        //传递的文件
        let files = [
            (
                name: "File",  //''File'' is the parameter_name(key) in the form-data of Body
//                path:Bundle.main.path(forResource: "pianoA", ofType: "mp3")!
                path: filePath
            ),

        ]
         
        //上传地址
        let url = URL(string: "http://10.112.184.124:8989/upload")!
        var request = URLRequest(url: url)
        //请求类型为POST
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type")
         
        //创建表单body
        request.httpBody = try! createBody(with: parameters, files: files, boundary: boundary)
         
        //创建一个表单上传任务
        let session = URLSession.shared
        let uploadTask = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            //上传完毕后
            if error != nil{
                print(error!)
            }else{
                let str = String(data: data!, encoding: String.Encoding.utf8)
                print("--- 上传完毕 ---\(str!)")
            }
        })
         
        //使用resume方法启动任务
        uploadTask.resume()
    }
     
    //创建表单body
    private func createBody(with parameters: [String: String]?,
                            files: [(name:String, path:String)],
                            boundary: String) throws -> Data {
        var body = Data()
         
        //添加普通参数数据
        if parameters != nil {
            for (key, value) in parameters! {
                // 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
         
        //添加文件数据
        for file in files {
            let url = URL(fileURLWithPath: file.path)
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            let mimetype = mimeType(pathExtension: url.pathExtension)
             
            // 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; "
                + "name=\"\(file.name)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n") //文件类型
            body.append(data) //文件主体
            body.append("\r\n") //使用\r\n来表示这个这个值的结束符
        }
         
        // --分隔线-- 为整个表单的结束符
        body.append("--\(boundary)--\r\n")
        return body
    }
     
    //根据后缀获取对应的Mime-Type
    func mimeType(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString,
                                                           nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }
    
    
}
 
//扩展Data
extension Data {
    //增加直接添加String数据的方法
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}


class Downloader {
    func load(serverURL: URL, localUrl: URL) {
        
 
        
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let destinationUrl = documentsDirectory.appendingPathComponent("optimized.mp3")
        
        let task = URLSession.shared.downloadTask(with: serverURL) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                //test
                print("compare original to temp: \(self.validateDownloadedFile(originalURL: serverURL, downloadedURL: tempLocalUrl))")
                
                //move from temp to local target
                do {
                    
                                    
                    if FileManager.default.fileExists(atPath: localUrl.path) {
                        //if exist, remove the original file first
                        try FileManager.default.removeItem(at: localUrl)
                        print("file removed: \(localUrl.path)")
                    }
                    //then write
                    try FileManager.default.moveItem(at: tempLocalUrl, to: localUrl)
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }

            } else {
                print("Failure: %@", error?.localizedDescription ?? "..");
            }
        }
        
        let validation = validateDownloadedFile(originalURL: serverURL, downloadedURL: localUrl)
        print("validation: \(validation)")
        task.resume()
    }
    
    
    
    func validateDownloadedFile(originalURL: URL, downloadedURL: URL) -> Bool {
        do {
            // 获取原始音频文件的内容和大小
            let originalData = try Data(contentsOf: originalURL)
            let originalSize = originalData.count
            
            // 获取下载的音频文件的内容和大小
            let downloadedData = try Data(contentsOf: downloadedURL)
            let downloadedSize = downloadedData.count
            
            // 比较内容和大小
            if originalData == downloadedData && originalSize == downloadedSize {
                return true // 文件验证通过
            } else {
                return false // 文件验证失败
            }
        } catch {
            print("文件验证失败: \(error)")
            return false
        }
    }
    


}
