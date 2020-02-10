//
//  CoreAppConfig.swift
//  OBAKitCore
//
//  Created by Aaron Brethorst on 1/26/20.
//

import Foundation
import CoreLocation

/// This is an application configuration object suitable for using in an
/// extension, non-graphical application, or basically anything that isn't
/// a traditional UIKit iOS app.
///
/// - Note: If you are building a traditional UIKit-based iOS app, check out
///         `OBAKit.AppConfig` instead. It offers additional features you'll
///         likely want to use in your app.
@objc(OBACoreAppConfig)
open class CoreAppConfig: NSObject {
    public let regionsBaseURL: URL?
    public let regionsAPIPath: String?
    public let obacoBaseURL: URL?
    public let apiKey: String
    public let appVersion: String
    public let queue: OperationQueue
    public let userDefaults: UserDefaults
    public let locationService: LocationService
    public let bundledRegionsFilePath: String

    /// This initializer will let you specify all properties.
    /// - Parameter regionsBaseURL: The base URL for the Regions server.
    /// - Parameter obacoBaseURL: The base URL for the Obaco server.
    /// - Parameter apiKey: Your API key for the REST API server.
    /// - Parameter appVersion: The version of the app.
    /// - Parameter userDefaults: The user defaults object.
    /// - Parameter queue: An operation queue.
    /// - Parameter locationService: The location service object.
    /// - Parameter bundledRegionsFilePath: The path to the `regions.json` file in the app bundle.
    /// - Parameter regionsAPIPath: The API Path on the Regions server to the regions file.
    @objc public init(
        regionsBaseURL: URL?,
        obacoBaseURL: URL?,
        apiKey: String,
        appVersion: String,
        userDefaults: UserDefaults,
        queue: OperationQueue,
        locationService: LocationService,
        bundledRegionsFilePath: String,
        regionsAPIPath: String?
    ) {
        self.regionsBaseURL = regionsBaseURL
        self.obacoBaseURL = obacoBaseURL
        self.apiKey = apiKey
        self.appVersion = appVersion
        self.queue = queue
        self.userDefaults = userDefaults
        self.locationService = locationService
        self.bundledRegionsFilePath = bundledRegionsFilePath
        self.regionsAPIPath = regionsAPIPath
    }
}
