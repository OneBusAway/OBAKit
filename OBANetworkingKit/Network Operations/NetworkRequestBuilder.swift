//
//  NetworkRequestBuilder.swift
//  OBANetworkingKit
//
//  Created by Aaron Brethorst on 10/2/18.
//  Copyright © 2018 OneBusAway. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


// public func requestRegionalAlerts() -> Promise<[AgencyAlert]>
// @objc public func requestStopArrivalsAndDepartures(withID stopID: String, minutesBefore: UInt, minutesAfter: UInt) -> PromiseWrapper
//- (AnyPromise*)requestStopsForPlacemark:(OBAPlacemark*)placemark;

//- (OBAModelServiceRequest*)reportProblemWithStop:(OBAReportProblemWithStopV2 *)problem completionBlock:(OBADataSourceCompletion)completion;
//- (OBAModelServiceRequest*)reportProblemWithTrip:(OBAReportProblemWithTripV2 *)problem completionBlock:(OBADataSourceCompletion)completion;

// Done:

//x (AnyPromise*)placemarksForAddress:(NSString*)address;
//x @objc public func requestTripDetails(tripInstance: OBATripInstanceRef) -> PromiseWrapper
//x (AnyPromise*)requestRoutesForQuery:(NSString*)routeQuery region:(CLCircularRegion*)region;
//x (AnyPromise*)requestStopsForRoute:(NSString*)routeID;
//x @objc public func requestAgenciesWithCoverage() -> PromiseWrapper
//x (AnyPromise*)requestShapeForID:(NSString*)shapeID;
//x (AnyPromise*)requestArrivalAndDeparture:(OBAArrivalAndDepartureInstanceRef*)instanceRef;
//x (AnyPromise*)requestArrivalAndDepartureWithConvertible:(id<OBAArrivalAndDepartureConvertible>)convertible;
//x (AnyPromise*)requestStopsForRegion:(MKCoordinateRegion)region;
//x (AnyPromise*)requestStopsForQuery:(NSString*)query region:(nullable CLCircularRegion*)region;
//x (AnyPromise*)requestStopsNear:(CLLocationCoordinate2D)coordinate;
//x (AnyPromise*)requestVehicleForID:(NSString*)vehicleID;
//x (AnyPromise*)requestCurrentTime;

public typealias NetworkCompletionBlock = (_ operation: RESTAPIOperation) -> Void
public typealias PlacemarkSearchCompletionBlock = (_ operation: PlacemarkSearchOperation) -> Void

@objc(OBANetworkRequestBuilder)
public class NetworkRequestBuilder: NSObject {
    private let baseURL: URL
    private let networkQueue: NetworkQueue
    private let defaultQueryItems: [URLQueryItem]

    @objc public init(baseURL: URL, apiKey: String, uuid: String, appVersion: String, networkQueue: NetworkQueue) {
        self.baseURL = baseURL

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "key", value: apiKey))
        queryItems.append(URLQueryItem(name: "app_uid", value: uuid))
        queryItems.append(URLQueryItem(name: "app_ver", value: appVersion))
        queryItems.append(URLQueryItem(name: "version", value: "2"))
        self.defaultQueryItems = queryItems

        self.networkQueue = networkQueue
    }

    @objc public convenience init(baseURL: URL, apiKey: String, uuid: String, appVersion: String) {
        self.init(baseURL: baseURL, apiKey: apiKey, uuid: uuid, appVersion: appVersion, networkQueue: NetworkQueue())
    }

    // MARK: - Vehicle with ID

    @discardableResult @objc
    public func getVehicle(_ vehicleID: String, completion: NetworkCompletionBlock?) -> RequestVehicleOperation {
        let url = RequestVehicleOperation.buildURL(vehicleID: vehicleID, baseURL: baseURL, queryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: RequestVehicleOperation.self, url: url, completionBlock: completion)
    }

    // MARK: - Current Time

    @discardableResult @objc
    public func getCurrentTime(completion: NetworkCompletionBlock?) -> CurrentTimeOperation {
        let url = CurrentTimeOperation.buildURL(baseURL: baseURL, queryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: CurrentTimeOperation.self, url: url, completionBlock: completion)
    }

    // MARK: - Stops

    @discardableResult @objc
    public func getStops(coordinate: CLLocationCoordinate2D, completion: NetworkCompletionBlock?) -> StopsOperation {
        let url = StopsOperation.buildURL(coordinate: coordinate, baseURL: baseURL, defaultQueryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: StopsOperation.self, url: url, completionBlock: completion)
    }

    @discardableResult @objc
    public func getStops(region: MKCoordinateRegion, completion: NetworkCompletionBlock?) -> StopsOperation {
        let url = StopsOperation.buildURL(region: region, baseURL: baseURL, defaultQueryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: StopsOperation.self, url: url, completionBlock: completion)
    }

    @discardableResult @objc
    public func getStops(circularRegion: CLCircularRegion, query: String, completion: NetworkCompletionBlock?) -> StopsOperation {
        let url = StopsOperation.buildURL(circularRegion: circularRegion, query: query, baseURL: baseURL, defaultQueryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: StopsOperation.self, url: url, completionBlock: completion)
    }

    // MARK: - Arrival and Departure for Stop

    @discardableResult @objc
    public func getArrivalDepartureForStop(stopID: String, tripID: String, serviceDate: Int64, vehicleID: String?, stopSequence: Int, completion: NetworkCompletionBlock?) -> ArrivalDepartureForStopOperation {
        let url = ArrivalDepartureForStopOperation.buildURL(stopID: stopID, tripID: tripID, serviceDate: serviceDate, vehicleID: vehicleID, stopSequence: stopSequence, baseURL: baseURL, defaultQueryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: ArrivalDepartureForStopOperation.self, url: url, completionBlock: completion)
    }

    // MARK: - Trip Details
    @objc @discardableResult
    public func getTrip(tripID: String, vehicleID: String?, serviceDate: Int64, completion: NetworkCompletionBlock?) -> TripDetailsOperation {
        let url = TripDetailsOperation.buildURL(tripID: tripID, vehicleID: vehicleID, serviceDate: serviceDate, baseURL: baseURL, queryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: TripDetailsOperation.self, url: url, completionBlock: completion)
    }

    // MARK: - Search

    // MARK: - Stops for Route

    @discardableResult @objc
    public func getStopsForRoute(id: String, completion: NetworkCompletionBlock?) -> StopsForRouteOperation {
        let url = StopsForRouteOperation.buildURL(routeID: id, baseURL: baseURL, queryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: StopsForRouteOperation.self, url: url, completionBlock: completion)
    }

    // MARK: - Search for Route

    @discardableResult @objc
    public func getRoute(query: String, region: CLCircularRegion, completion: NetworkCompletionBlock?) -> RouteSearchOperation {
        let url = RouteSearchOperation.buildURL(searchQuery: query, region: region, baseURL: baseURL, defaultQueryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: RouteSearchOperation.self, url: url, completionBlock: completion)
    }

    // MARK: - Search for Placemarks/Local Search
    @discardableResult @objc
    public func getPlacemarks(query: String, region: MKCoordinateRegion, completion: PlacemarkSearchCompletionBlock?) -> PlacemarkSearchOperation {
        let operation = PlacemarkSearchOperation(query: query, region: region)
        operation.completionBlock = { [weak operation] in
            if let operation = operation { completion?(operation) }
        }
        networkQueue.add(operation)

        return operation
    }

    // MARK: - Shapes

    @discardableResult @objc
    public func getShape(id: String, completion: NetworkCompletionBlock?) -> ShapeOperation {
        let url = ShapeOperation.buildURL(shapeID: id, baseURL: baseURL, queryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: ShapeOperation.self, url: url, completionBlock: completion)
    }

    // MARK: - Agencies

    @discardableResult @objc
    public func getAgenciesWithCoverage(completion: NetworkCompletionBlock?) -> AgenciesWithCoverageOperation {
        let url = AgenciesWithCoverageOperation.buildURL(baseURL: baseURL, queryItems: defaultQueryItems)
        return buildAndEnqueueOperation(type: AgenciesWithCoverageOperation.self, url: url, completionBlock: completion)
    }

    // MARK: - Private Internal Helpers

    private func buildAndEnqueueOperation<T>(type: T.Type, url: URL, completionBlock: NetworkCompletionBlock?) -> T where T: RESTAPIOperation {
        let operation = type.init(url: url)
        operation.completionBlock = { [weak operation] in
            if let operation = operation { completionBlock?(operation) }
        }

        networkQueue.add(operation)

        return operation
    }
}
