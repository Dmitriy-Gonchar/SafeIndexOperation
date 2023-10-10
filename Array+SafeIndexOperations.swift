//
//  Array+SafeIndexOperations.swift
//

import Foundation

extension Array
{
	subscript(safeIndex index: Int) -> Element?
	{
		get
		{
			let immutable = self
			return index >= 0 && index < immutable.count ? immutable[index] : nil
		}

		set
		{
			var temp = self
			guard index >= 0 else { return }

			switch newValue
			{
			case .none: self.safeRemove(at: index)
			case .some(let newElement): temp.count > index ? { temp[index] = newElement; self = temp }() : {}()
			}
		}
	}

	subscript(safeIndex index: UInt) -> Element?
	{
		get
		{
			let immutable = self
			return index < immutable.count ? immutable[Int(index)] : nil
		}

		set
		{
			var temp = self

			switch newValue
			{
			case .none: self.safeRemove(at: index)
			case .some(let newElement): temp.count > index ? { temp[Int(index)] = newElement; self = temp }() : {}()
			}
		}
	}

	@inlinable public mutating func safeInsert(_ newElement: Element, at index: Int)
	{
		let immutableSelf = self
		guard immutableSelf.count >= index && index >= 0 else { return }
		self = immutableSelf.dropLast(immutableSelf.count - index) + [newElement] + immutableSelf.dropFirst(index)
	}

	@inlinable public mutating func safeInsert(_ newElement: Element, at index: UInt)
	{
		let immutableSelf = self
		guard immutableSelf.count >= index else { return }
		let intIndex = Int(index)
		self = immutableSelf.dropLast(immutableSelf.count - intIndex) + [newElement] + immutableSelf.dropFirst(intIndex)
	}

	@discardableResult
	@inlinable public mutating func safeRemove(at index: Int) -> Element?
	{
		var temp = self
		guard temp.count > index && index >= 0 else { return nil }
		let result = temp.remove(at: index)
		self = temp
		return result
	}

	@discardableResult
	@inlinable public mutating func safeRemoveSlowly(at index: Int) -> Element?
	{
		let immutableSelf = self
		self = immutableSelf
			.enumerated()
			.filter { $0.offset != index }
			.map { $0.element }
		return immutableSelf.count > index && index >= 0 ? immutableSelf[index] : nil
	}

	@discardableResult
	@inlinable public mutating func safeRemove(at index: UInt) -> Element?
	{
		var temp = self
		guard temp.count > index else { return nil }
		let result = temp.remove(at: Int(index))
		self = temp
		return result
	}

	@inlinable public func safeDropLast(_ k: Int) -> ArraySlice<Element>
	{
		self.dropLast(k > 0 ? k : 0)
	}

	@inlinable public func safeDropLast(_ k: UInt) -> ArraySlice<Element>
	{
		self.dropLast(Int(k))
	}

	@inlinable public func safeDropFirst(_ k: Int = 1) -> ArraySlice<Element>
	{
		self.dropFirst(k > 0 ? k : 0)
	}

	@inlinable public func safeDropFirst(_ k: UInt = 1) -> ArraySlice<Element>
	{
		self.dropFirst(Int(k))
	}
}
