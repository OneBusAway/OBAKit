//
//  AlarmTests.swift
//  OBAKitTests
//
//  Copyright © Open Transit Software Foundation
//  This source code is licensed under the Apache 2.0 license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import XCTest
import Nimble
@testable import OBAKit
@testable import OBAKitCore

// swiftlint:disable force_try

class AlarmTests: OBATestCase {

    func test_init_baseCase_success() {
        let alarm = try! Fixtures.loadAlarm()
        expect(alarm.url.absoluteString) == "https://alerts.example.com/regions/1/alarms/1234567890"
    }

    func test_appendingData() {
        let alarm = try! Fixtures.loadAlarm()
        let interval: TimeInterval = 1580428800
        let serviceDate = Date(timeIntervalSince1970: interval) // January 31, 2020, 12:00 AM GMT
        let tripDate = Date(timeIntervalSince1970: interval + 18000) // + 5 hours.
        let alarmOffset = 10 // - 10 minutes
        let alarmDate = tripDate.addingTimeInterval(-60.0 * TimeInterval(alarmOffset))

        expect(tripDate).toNot(beNil())
        expect(alarmDate).toNot(beNil())

        let deepLink = ArrivalDepartureDeepLink(title: "Title", regionID: 1, stopID: "1234", tripID: "9876", serviceDate: serviceDate, stopSequence: 7, vehicleID: "3456")

        alarm.deepLink = deepLink

        alarm.set(tripDate: tripDate, alarmOffset: alarmOffset)

        let roundtripped = try! Fixtures.roundtripCodable(type: Alarm.self, model: alarm)
        expect(roundtripped.url.absoluteString) == "https://alerts.example.com/regions/1/alarms/1234567890"
        expect(roundtripped.deepLink!.title) == "Title"
        expect(roundtripped.deepLink!.stopID) == "1234"
        expect(roundtripped.deepLink!.tripID) == "9876"
        expect(roundtripped.deepLink!.serviceDate.timeIntervalSince1970) == 1580428800
        expect(roundtripped.deepLink!.stopSequence) == 7
        expect(roundtripped.deepLink!.vehicleID) == "3456"
        expect(roundtripped.tripDate!) == tripDate
        expect(roundtripped.alarmDate!) == alarmDate
    }
}
