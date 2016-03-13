//
//  DataConnection.swift
//  ACApps
//
//  Created by Brandon Phan on 3/6/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

//These set of classes are good for downloading large files

import Foundation

/// Asynchronous NSOperation subclass for downloading

class DownloadOperation : AsynchronousOperation {
    let task: NSURLSessionTask
    
    init(session: NSURLSession, URL: NSURL) {
        task = session.downloadTaskWithURL(URL)
        super.init()
    }
    
    override func cancel() {
        task.cancel()
        super.cancel()
    }
    
    override func main() {
        task.resume()
    }
    
    // MARK: NSURLSessionDownloadDelegate methods
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do {
            let manager = NSFileManager.defaultManager()
            let documents = try manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let destinationURL = documents.URLByAppendingPathComponent(downloadTask.originalRequest!.URL!.lastPathComponent!)
            if manager.fileExistsAtPath(destinationURL.path!) {
                try manager.removeItemAtURL(destinationURL)
            }
            try manager.moveItemAtURL(location, toURL: destinationURL)
        } catch {
            print(error)
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("\(downloadTask.originalRequest!.URL!.absoluteString) \(progress)")
    }
    
    // MARK: NSURLSessionTaskDelegate methods
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        completeOperation()
        if error != nil {
            print(error)
        }
    }
}

class AsynchronousOperation : NSOperation {
    
    override var asynchronous: Bool { return true }
    
    private var _executing: Bool = false
    override var executing: Bool {
        get {
            return _executing
        } set {
            if (_executing != newValue) {
                self.willChangeValueForKey("isExecuting")
                _executing = newValue
                self.didChangeValueForKey("isExecuting")
            }
        }
    }
    
    private var _finished: Bool = false
    override var finished: Bool {
        get {
            return _finished
        } set {
            if (_finished != newValue) {
                self.willChangeValueForKey("isFinished")
                _finished = newValue
                self.didChangeValueForKey("isFinished")
            }
        }
    }
    
    /// Complete the operation
    ///
    /// This will result in the appropriate KVN of isFinished and isExecuting
    
    func completeOperation() {
        if executing {
            executing = false
            finished = true
        }
    }
    
    override func start() {
        if (cancelled) {
            finished = true
            return
        }
        executing = true
        main()
    }
}


class DownloadManager: NSObject, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate {
    
    /// Dictionary of operations, keyed by the `taskIdentifier` of the `NSURLSessionTask`
    
    private var operations = [Int: DownloadOperation]()
    
    /// Serial NSOperationQueue for downloads
    
    let queue: NSOperationQueue = {
        let _queue = NSOperationQueue()
        _queue.name = "download"
        _queue.maxConcurrentOperationCount = 1
        
        return _queue
    }()
    
    /// Delegate-based NSURLSession for DownloadManager
    
    lazy var session: NSURLSession = {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }()
    
    /// Add download
    ///
    /// - parameter URL:  The URL of the file to be downloaded
    ///
    /// - returns:        The DownloadOperation of the operation that was queued
    
    func addDownload(URL: NSURL) -> DownloadOperation {
        let operation = DownloadOperation(session: session, URL: URL)
        operations[operation.task.taskIdentifier] = operation
        queue.addOperation(operation)
        return operation
    }
    
    /// Cancel all queued operations
    
    func cancelAll() {
        queue.cancelAllOperations()
    }
    
    // MARK: NSURLSessionDownloadDelegate methods
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        operations[downloadTask.taskIdentifier]?.URLSession(session, downloadTask: downloadTask, didFinishDownloadingToURL: location)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        operations[downloadTask.taskIdentifier]?.URLSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
    
    // MARK: NSURLSessionTaskDelegate methods
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        let key = task.taskIdentifier
        operations[key]?.URLSession(session, task: task, didCompleteWithError: error)
        operations.removeValueForKey(key)
    }
    
}

