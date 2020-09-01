//
//  MMNetworkClientSessionDelegate.swift
//  MovieMatrix
//
//  Created by pranay chander on 17/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation


//MMClientServiceDelegate to get add relevant methods

class MMNetworkClientSessionDelegate: NSObject, URLSessionDelegate {
}

//URL Session Task Delagate can be used to fetch task metrics
extension MMNetworkClientSessionDelegate: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print(metrics.redirectCount)
    }
}

//URL Session Download Task Delagate can be used to get current downloading data
extension MMNetworkClientSessionDelegate: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
    }
}
