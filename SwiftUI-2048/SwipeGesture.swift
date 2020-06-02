//
//  SwipeGesture.swift
//  SwiftUI-2048
//
//  Created by Joshua Homann on 6/1/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI

struct SwipeGesture: ViewModifier {
  var threshold: CGFloat
  var onSwipe: (Direction) -> Void

  enum Direction {
    case up, down, left, right
    var isHorizontal: Bool { Set([.right, .left]).contains(self) }
    var isPositive: Bool { Set([.up, .left]).contains(self) }
  }

  func body(content: Content) -> some View {
    content.gesture(
      DragGesture(minimumDistance: threshold).onEnded { [onSwipe] value in
          let isHorizontal = abs(value.translation.width) > abs(value.translation.height)
          let isPositive = isHorizontal
            ? value.translation.width > 0
            : value.translation.height > 0
          let direction: Direction = isHorizontal
            ? isPositive ? .right : .left
            : isPositive ? .down : .up
          onSwipe(direction)
        }
      )
    }
}

extension View {
  func swipeGesture(threshold: CGFloat, onSwipe: @escaping (SwipeGesture.Direction) -> Void ) -> some View {
    modifier(SwipeGesture(
      threshold: threshold,
      onSwipe: onSwipe)
    )
  }
}
