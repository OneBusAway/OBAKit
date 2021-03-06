//
//  OBAListItemViewModel.swift
//  OBAKit
//
//  Created by Alan Chu on 10/4/20.
//

public enum OBAListViewItemConfiguration {
    case custom(OBAContentConfiguration)
    case list(UIListContentConfiguration, [UICellAccessory?])
}

// MARK: - OBAListViewItem
/// A view model that provides the necessary implementation to compare the identity and equality of
/// two view models for `OBAListView`. Also, defines list row actions, such as what to
/// do when the user taps the row.
///
/// - The `Hashable` protocol requires a `hash` method.
///     This is needed for `NSDiffableDataSource`, which is the "identity" of the model.
///     It should be a combination of *all values, including the identifier*.
/// - If the compiler is unable to synthesize an Equatable conformance, your implementation should behave
///     similar to hashable, comparing *all values, including the identifier*.
/// - The `Identifiable` protocol requires an `id` property.
///     It is currently not in use, reserved for future item identification functionality. This value is the "stable identity" (e.g. `stopID`) of the model.
public protocol OBAListViewItem: Hashable, Identifiable {
    var configuration: OBAListViewItemConfiguration { get }

    var separatorConfiguration: OBAListRowSeparatorConfiguration { get }

    /// Optional. If your item doesn't use OBAListRowView, you define the custom view type here.
    static var customCellType: OBAListViewCell.Type? { get }

    /// Optional. Action to perform when you select this item.
    var onSelectAction: OBAListViewAction<Self>? { get }

    /// Optional. Action to perform when you delete this item.
    var onDeleteAction: OBAListViewAction<Self>? { get }

    /// Optional. Contextual actions to display on the leading side of the cell.
    /// There is no need to set `item` for your actions, `OBAListView` will automatically set `item`.
    var leadingContextualActions: [OBAListViewContextualAction<Self>]? { get }

    /// Optional. Contextual actions to display on the trailing side of the cell.
    /// There is no need to set `item` for your actions, `OBAListView` will automatically set `item`.
    var trailingContextualActions: [OBAListViewContextualAction<Self>]? { get }

    var typeErased: AnyOBAListViewItem { get }
}

// MARK: Default implementations
extension OBAListViewItem {
    public static var customCellType: OBAListViewCell.Type? {
        return nil
    }

    public var separatorConfiguration: OBAListRowSeparatorConfiguration {
        return .init()
    }

    public var onSelectAction: OBAListViewAction<Self>? {
        return nil
    }

    public var onDeleteAction: OBAListViewAction<Self>? {
        return nil
    }

    public var leadingContextualActions: [OBAListViewContextualAction<Self>]? {
        return nil
    }

    public var trailingContextualActions: [OBAListViewContextualAction<Self>]? {
        return nil
    }

    public var typeErased: AnyOBAListViewItem {
        return AnyOBAListViewItem(self)
    }
}

// MARK: - Type erase OBAListViewItem
/// A type-erased OBAListViewItem.
///
/// To attempt to cast into an `OBAListViewItem`, call `as(:_)`. For example:
/// ```swift
/// let person: Person? = AnyOBAListViewItem.as(Person.self)
/// ```
public struct AnyOBAListViewItem: OBAListViewItem {
    private let _anyEquatable: AnyEquatable
    private let _id: () -> AnyHashable
    private let _configuration: () -> OBAListViewItemConfiguration

    private let _separatorConfiguration: () -> OBAListRowSeparatorConfiguration
    private let _onSelectAction: () -> OBAListViewAction<AnyOBAListViewItem>?
    private let _onDeleteAction: () -> OBAListViewAction<AnyOBAListViewItem>?
    private let _leadingContextualActions: () -> [OBAListViewContextualAction<AnyOBAListViewItem>]?
    private let _trailingContextualActions: () -> [OBAListViewContextualAction<AnyOBAListViewItem>]?
    private let _type: AnyHashable

    public init<ViewModel: OBAListViewItem>(_ listCellViewModel: ViewModel) {
        self._anyEquatable = AnyEquatable(listCellViewModel)
        self._configuration = { return listCellViewModel.configuration }
        self._id = { return listCellViewModel.id }
        self._type = listCellViewModel

        self._separatorConfiguration = { return listCellViewModel.separatorConfiguration }
        self._onSelectAction = { return AnyOBAListViewItem.typeEraseAction(listCellViewModel.onSelectAction) }
        self._onDeleteAction = { return AnyOBAListViewItem.typeEraseAction(listCellViewModel.onDeleteAction) }
        self._leadingContextualActions = { return AnyOBAListViewItem.typeEraseActions(listCellViewModel.leadingContextualActions) }
        self._trailingContextualActions = { return AnyOBAListViewItem.typeEraseActions(listCellViewModel.trailingContextualActions) }
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

    public var id: AnyHashable {
        return _id()
    }

    public var configuration: OBAListViewItemConfiguration {
        return _configuration()
    }

    public var separatorConfiguration: OBAListRowSeparatorConfiguration {
        return _separatorConfiguration()
    }

    public var onSelectAction: OBAListViewAction<AnyOBAListViewItem>? {
        return _onSelectAction()
    }

    public var onDeleteAction: OBAListViewAction<AnyOBAListViewItem>? {
        return _onDeleteAction()
    }

    public var leadingContextualActions: [OBAListViewContextualAction<AnyOBAListViewItem>]? {
        return _leadingContextualActions()
    }

    public var trailingContextualActions: [OBAListViewContextualAction<AnyOBAListViewItem>]? {
        return _trailingContextualActions()
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_type)
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
private struct AnyEquatable: Equatable {
    let value: Any
    let isEqual: (AnyEquatable) -> Bool
    init<T: Equatable>(_ value: T) {
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
