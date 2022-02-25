//
//  UploadResponseDelegate.swift
//  
//
//  Created by David Cortes on 24/2/22.
//

import Foundation
import Combine

final class UploadResponseDelegate: NSObject {
    var subject: PassthroughSubject<(id: Int, progress: Double), Never>?
    
    init(subjec: PassthroughSubject<(id: Int, progress: Double), Never>?) {
        self.subject = subjec
    }
}

extension UploadResponseDelegate: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        subject?.send((
                id: task.taskIdentifier,
                progress: task.progress.fractionCompleted
            ))
    }
}
