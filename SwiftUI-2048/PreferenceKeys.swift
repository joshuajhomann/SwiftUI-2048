//
//  PreferenceKeys.swift
//  SwiftUI-2048
//
//  Created by Joshua Homann on 5/25/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI

protocol DictionaryPreferenceKey: PreferenceKey where Value == [Key : DictionaryValue] {
  associatedtype Key: Hashable
  associatedtype DictionaryValue
}

extension DictionaryPreferenceKey {
  static var defaultValue: Value { [:] }
  static func reduce(value: inout Value, nextValue: () -> Value) {
    nextValue().forEach { value[$0] = $1 }
  }
}

struct CellPreferenceKey: DictionaryPreferenceKey {
  typealias Key = Int
  typealias DictionaryValue = CGRect
}
