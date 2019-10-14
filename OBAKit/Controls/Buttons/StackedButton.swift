//
//  StackedButton.swift
//  OBAKit
//
//  Created by Aaron Brethorst on 2/10/19.
//  Copyright © 2019 OneBusAway. All rights reserved.
//

import UIKit

/// A subclass of `UIControl` that looks like a two row button with an icon on top and a text label below.
public class StackedButton: UIControl {

    let kDebugColors = false

    public var title: String? {
        set {
            textLabel.text = newValue
            accessibilityLabel = newValue
        }
        get {
            return textLabel.text
        }
    }

    public let textLabel: UILabel = {
        let label = UILabel.autolayoutNew()
        label.numberOfLines = 1
        label.textColor = ThemeColors.shared.primary
        label.text = "LABEL"
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.font = UIFont.preferredFont(forTextStyle: .footnote).bold

        return label
    }()

    public let imageView: UIImageView = {
        let imageView = UIImageView.autolayoutNew()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.isUserInteractionEnabled = false
        imageView.tintColor = ThemeColors.shared.primary

        return imageView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        isUserInteractionEnabled = true
        backgroundColor = .clear

        let stack = UIStackView.verticalStack(arangedSubviews: [imageView, textLabel])
        stack.isUserInteractionEnabled = false
        let wrapper = stack.embedInWrapperView()
        addSubview(wrapper)

        wrapper.pinToSuperview(.edges)

        if kDebugColors {
            backgroundColor = .magenta
            textLabel.backgroundColor = .green
            imageView.backgroundColor = .red
        }
    }

    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}