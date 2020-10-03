//
//  OBAListContentConfiguration.swift
//  OBAKit
//
//  Created by Alan Chu on 10/2/20.
//

import UIKit

public struct OBAListContentConfiguration {
    public enum Appearance {
        case `default`
        case subtitle
        case value

        case header
    }

    public var image: UIImage?
    public var text: String?
    public var attributedText: NSAttributedString?
    public var secondaryText: String?
    public var secondaryAttributedText: NSAttributedString?

    public var appearance: Appearance

    public var accessoryType: UITableViewCell.AccessoryType

    @available(iOS 14, *)
    public var listContentConfiguration: UIListContentConfiguration {
        var config: UIListContentConfiguration

        switch appearance {
        case .default:   config = .cell()
        case .subtitle:  config = .subtitleCell()
        case .value:     config = .valueCell()
        case .header:    config = .plainHeader()
        }

        config.image = image
        config.text = text
        config.attributedText = attributedText
        config.secondaryText = secondaryText
        config.secondaryAttributedText = secondaryAttributedText

        return config
    }

    public static var Cell: OBAListContentConfigurable.Type {
        if #available(iOS 14, *) {
            return UICollectionViewListCell.self
        } else {
            return OBAListViewRow.self
        }
    }
}

