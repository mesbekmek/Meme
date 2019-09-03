//
//  ImageCache.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 8/23/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

//protocol ImageCaching {
//    func getImage(for url: URL) -> UIImage?
//    func setImage(image: UIImage, for url: URL)
//}
//
//class ImageCache: ImageCaching {
//    static let shared = ImageCache()
//    private var imageDictionary: [URL:UIImage] = [:]
//    private let lock = NSRecursiveLock()
//
//    func getImage(for url: URL) -> UIImage? {
//        return imageDictionary[url]
//    }
//
//    func setImage(image: UIImage, for url: URL) {
//        lock.lock()
//        defer {
//            lock.unlock()
//        }
//        imageDictionary[url] = image
//    }
//}

/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A class that used to mimic fetching data asynchronously.
 */

import Foundation

/// - Tag: AsyncFetcher
class AsyncFetcher {
    // MARK: Types

    /// A serial `OperationQueue` to lock access to the `fetchQueue` and `completionHandlers` properties.
    private let serialAccessQueue = OperationQueue()

    /// An `OperationQueue` that contains `AsyncFetcherOperation`s for requested data.
    private let fetchQueue = OperationQueue()

    /// A dictionary of arrays of closures to call when an object has been fetched for an id.
    private var completionHandlers = [URL: [(UIImage?) -> Void]]()

    /// An `NSCache` used to store fetched objects.
    private var cache = NSCache<NSURL, UIImage>()

    static let shared = AsyncFetcher()

    // MARK: Initialization

    init() {
        serialAccessQueue.maxConcurrentOperationCount = 1
    }

    // MARK: Object fetching

    /**
     Asynchronously fetches data for a specified `URL`.

     - Parameters:
     - url: The `URL` to fetch data for.
     - completion: An optional called when the data has been fetched.
     */
    func fetchAsync(_ url: URL, completion: ((UIImage?) -> Void)? = nil) {
        // Use the serial queue while we access the fetch queue and completion handlers.
        serialAccessQueue.addOperation {
            // If a completion block has been provided, store it.
            if let completion = completion {
                let handlers = self.completionHandlers[url, default: []]
                self.completionHandlers[url] = handlers + [completion]
            }

            self.fetchData(for: url)
        }
    }

    /**
     Returns the previously fetched data for a specified `URL`.

     - Parameter url: The `URL` of the object to return.
     - Returns: The 'UIImage' that has previously been fetched or nil.
     */
    func fetchedData(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }

    /**
     Cancels any enqueued asychronous fetches for a specified `URL`. Completion
     handlers are not called if a fetch is canceled.

     - Parameter url: The `URL` to cancel fetches for.
     */
    func cancelFetch(_ url: URL) {
        serialAccessQueue.addOperation {
            self.fetchQueue.isSuspended = true
            defer {
                self.fetchQueue.isSuspended = false
            }

            self.operation(for: url)?.cancel()
            self.completionHandlers[url] = nil
        }
    }

    // MARK: Convenience

    /**
     Begins fetching data for the provided `url` invoking the associated
     completion handler when complete.

     - Parameter url: The `URL` to fetch data for.
     */
    private func fetchData(for url: URL) {
        // If a request has already been made for the object, do nothing more.
        guard operation(for: url) == nil else { return }

        if let data = fetchedData(for: url) {
            // The object has already been cached; call the completion handler with that object.
            invokeCompletionHandlers(for: url, with: data)
        } else {
            // Enqueue a request for the object.
            let operation = AsyncFetcherOperation(url: url)

            // Set the operation's completion block to cache the fetched object and call the associated completion blocks.
            operation.completionBlock = { [weak operation] in
                guard let fetchedData = operation?.fetchedData else { return }
                self.cache.setObject(fetchedData, forKey: url as NSURL)

                self.serialAccessQueue.addOperation {
                    self.invokeCompletionHandlers(for: url, with: fetchedData)
                }
            }

            fetchQueue.addOperation(operation)
        }
    }

    /**
     Returns any enqueued `ObjectFetcherOperation` for a specified `URL`.

     - Parameter url: The `URL` of the operation to return.
     - Returns: The enqueued `ObjectFetcherOperation` or nil.
     */
    private func operation(for url: URL) -> AsyncFetcherOperation? {
        for case let fetchOperation as AsyncFetcherOperation in fetchQueue.operations
            where !fetchOperation.isCancelled && fetchOperation.url == url {
                return fetchOperation
        }

        return nil
    }

    /**
     Invokes any completion handlers for a specified `URL`. Once called,
     the stored array of completion handlers for the `URL` is cleared.

     - Parameters:
     - url: The `URL` of the completion handlers to call.
     - object: The fetched object to pass when calling a completion handler.
     */
    private func invokeCompletionHandlers(for url: URL, with fetchedData: UIImage) {
        let completionHandlers = self.completionHandlers[url, default: []]
        self.completionHandlers[url] = nil

        for completionHandler in completionHandlers {
            completionHandler(fetchedData)
        }
    }
}

/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 An `Operation` subclass used by `AsyncFetcher` to get image data from a provided `URL`.
 */

import Foundation

class AsyncFetcherOperation: Operation {
    // MARK: Properties

    /// The `URL` that the operation is fetching data for.
    let url: URL

    /// The `UIImage` that has been fetched by this operation.
    private(set) var fetchedData: UIImage?

    // MARK: Initialization

    init(url: URL) {
        self.url = url
    }

    // MARK: Operation overrides

    override func main() {
        if let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            guard !isCancelled else { return }

            fetchedData = image
        }
    }
}
