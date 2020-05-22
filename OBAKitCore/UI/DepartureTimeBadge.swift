//
//  DepartureTimeBadge.swift
//  OBAKit
//
//  Created by Alan Chu on 12/22/19.
//  Copyright © 2019 OneBusAway. All rights reserved.
//

import UIKit

/// A rounded time badge representing the provided upcoming departure time and deviation status.
public class DepartureTimeBadge: UILabel {
    public override init(frame: CGRect) {
        super.init(frame: frame)

        textColor = ThemeColors.shared.lightText

        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .headline)

        backgroundColor = .clear
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func prepareForReuse() {
        accessibilityLabel = nil
        text = nil
    }

    public func set(arrivalDeparture: ArrivalDeparture, formatters: Formatters) {
        accessibilityLabel = formatters.formattedTime(until: arrivalDeparture)
        text = formatters.shortFormattedTime(until: arrivalDeparture)

        let status = arrivalDeparture.scheduleStatus
        backgroundColor = formatters.backgroundColorForScheduleStatus(status)
    }
}