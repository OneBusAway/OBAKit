//
//  OBAListItemViewModel.swift
//  OBAKit
//
//  Created by Alan Chu on 10/4/20.
//

// MARK: - OBAListViewItem
public protocol OBAListViewItem: Hashable {
    var contentConfiguration: OBAContentConfiguration { get }

    static var customCellType: OBAListViewCell.Type? { get }

    /// Action to perform when you select this item.
    var onSelectAction: OBAListViewAction<Self>? { get }

    /// Contextual actions to display on the leading side of the cell.
    var leadingContextualActions: [OBAListViewContextualAction<Self>]? { get }

    /// Contextual actions to display on the trailing side of the cell.
    var trailingContextualActions: [OBAListViewContextualAction<Self>]? { get }

    /// Do not implement this yourself, specify actions using `var leadingActions: [OBAListViewAction<_>]`.
    /// The default implementation takes `leadingActions` and sets the `item` property to self.
    var leadingSwipeActions: [OBAListViewContextualAction<Self>]? { get }

    /// Do not implement this yourself, specify actions using `var trailingActions: [OBAListViewAction<_>]`.
    /// The default implementation takes `leadingActions` and sets the `item` property to self.
    var trailingSwipeActions: [OBAListViewContextualAction<Self>]? { get }
}

// MARK: Default implementations
extension OBAListViewItem {
    public static var customCellType: OBAListViewCell.Type? {
        return nil
    }

    public var leadingContextualActions: [OBAListViewContextualAction<Self>]? {
        return nil
    }

    public var trailingContextualActions: [OBAListViewContextualAction<Self>]? {
        return nil
    }

    public var leadingSwipeActions: [OBAListViewContextualAction<Self>]? {
        return leadingContextualActions?.map {
            var action = $0
            action.item = self
            return action
        }
    }

    public var trailingSwipeActions: [OBAListViewContextualAction<Self>]? {
        return trailingContextualActions?.map {
            var action = $0
            action.item = self
            return action
        }
    }
}

// MARK: - Type erase OBAListViewItem
/// To attempt to cast into an `OBAListViewItem`, call `as(:_)`.
///
/// Example:
/// ```swift
/// guard let person = AnyOBAListViewItem.as(Person.self) else { return }
/// ```
public struct AnyOBAListViewItem: OBAListViewItem {
    private let _anyEquatable: AnyEquatable
    private let _contentConfiguration: () -> OBAContentConfiguration
    private let _hash: (_ hasher: inout Hasher) -> Void

    private let _onSelectAction: () -> OBAListViewAction<AnyOBAListViewItem>?
    private let _leadingActions: () -> [OBAListViewContextualAction<AnyOBAListViewItem>]?
    private let _trailingActions: () -> [OBAListViewContextualAction<AnyOBAListViewItem>]?
    private let _type: Any

    public init<ViewModel: OBAListViewItem>(_ listCellViewModel: ViewModel) {
        self._anyEquatable = AnyEquatable(listCellViewModel)
        self._contentConfiguration = { return listCellViewModel.contentConfiguration }
        self._hash = listCellViewModel.hash
        self._type = listCellViewModel

        self._onSelectAction = { return AnyOBAListViewItem.typeEraseAction(listCellViewModel.onSelectAction) }
        self._leadingActions = { return AnyOBAListViewItem.typeEraseActions(listCellViewModel.leadingSwipeActions) }
        self._trailingActions = { return AnyOBAListViewItem.typeEraseActions(listCellViewModel.trailingSwipeActions) }
    }

    fileprivate static func typeEraseAction<ViewModel: OBAListViewItem>(
        _ action: OBAListViewAction<ViewModel>?
    ) -> OBAListViewAction<AnyOBAListViewItem>? {
        let typeErasedClosure: OBAListViewAction<AnyOBAListViewItem>?
        if let typedClosure = action {
            typeErasedClosure = { (anyItem: AnyOBAListViewItem) in
                typedClosure(anyItem.as(ViewModel.self)!)
            }
        } else {
            typeErasedClosure = nil
        }

        return typeErasedClosure
    }

    fileprivate static func typeEraseActions<ViewModel: OBAListViewItem>(
        _ actions: [OBAListViewContextualAction<ViewModel>]?
    ) -> [OBAListViewContextualAction<AnyOBAListViewItem>]? {
        return actions?.map { (typedItem: OBAListViewContextualAction<ViewModel>) -> OBAListViewContextualAction<AnyOBAListViewItem> in
            let typeErased: AnyOBAListViewItem?
            if let item = typedItem.item {
                typeErased = AnyOBAListViewItem(item)
            } else {
                typeErased = nil
            }

            let typeErasedAction = typeEraseAction(typedItem.handler)

            return OBAListViewContextualAction(
                style: typedItem.style,
                title: typedItem.title,
                image: typedItem.image,
                backgroundColor: typedItem.backgroundColor,
                item: typeErased,
                handler: typeErasedAction)
        }
    }

    public static var customCellType: OBAListViewCell.Type? {
        fatalError("Illegal. You cannot get the customCellType of AnyOBAListViewItem.")
    }

    public var contentConfiguration: OBAContentConfiguration {
        return _contentConfiguration()
    }

    public var onSelectAction: OBAListViewAction<AnyOBAListViewItem>? {
        return _onSelectAction()
    }

    public var leadingActions: [OBAListViewContextualAction<AnyOBAListViewItem>]? {
        return _leadingActions()
    }

    public var trailingActions: [OBAListViewContextualAction<AnyOBAListViewItem>]? {
        return _trailingActions()
    }

    public func hash(into hasher: inout Hasher) {
        self._hash(&hasher)
    }

    public static func == (lhs: AnyOBAListViewItem, rhs: AnyOBAListViewItem) -> Bool {
        return lhs._anyEquatable == rhs._anyEquatable
    }

    func `as`<OBAViewModel: OBAListViewItem>(_ expectedType: OBAViewModel.Type) -> OBAViewModel? {
        return self._type as? OBAViewModel
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