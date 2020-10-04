//
//  OBAListItemViewModel.swift
//  OBAKit
//
//  Created by Alan Chu on 10/4/20.
//

public protocol OBAListViewItem: Hashable {
    func listViewConfigurationForThisItem(_ listView: OBAListView) -> OBAListContentConfiguration
}

public struct AnyOBAListViewItem: OBAListViewItem {
    private let _anyEquatable: AnyEquatable
    private let _listConfigurationForThisItem: (_ listView: OBAListView) -> OBAListContentConfiguration
    private let _hash: (_ hasher: inout Hasher) -> Void

    public init<OBAViewModel: OBAListViewItem>(_ listCellViewModel: OBAViewModel) {
        self._anyEquatable = AnyEquatable(listCellViewModel)
        self._listConfigurationForThisItem = listCellViewModel.listViewConfigurationForThisItem
        self._hash = listCellViewModel.hash
    }

    public func listViewConfigurationForThisItem(_ listView: OBAListView) -> OBAListContentConfiguration {
        return _listConfigurationForThisItem(listView)
    }

    public func hash(into hasher: inout Hasher) {
        self._hash(&hasher)
    }

    public static func == (lhs: AnyOBAListViewItem, rhs: AnyOBAListViewItem) -> Bool {
        return lhs._anyEquatable == rhs._anyEquatable
    }
}

// MARK: - AnyEquatable for type erased types
// Source: https://gist.github.com/pyrtsa/f5dbf7fff53e834936470762960357a4

// Quick hack to avoid changing the AnyEquatable implementation below.
private extension Equatable { typealias EqualSelf = Self }

/// Existential wrapper around Equatable.
private struct AnyEquatable : Equatable {
    let value: Any
    let isEqual: (AnyEquatable) -> Bool
    init<T : Equatable>(_ value: T) {
        self.value = value
        self.isEqual = {r in
            guard let other = r.value as? T.EqualSelf else { return false }
            return value == other
        }
    }

    static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        lhs.isEqual(rhs)
    }
}
