//
//  ContentView.swift
//  SwiftUI-2048
//
//  Created by Joshua Homann on 5/22/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI

struct GameView: View {
  @ObservedObject private var model: GameModel = .init()
  @State private var cellFrames: [Int: CGRect] = [:]
  private func offset(for index: Int) -> CGSize {
    let point = cellFrames[index]?.origin ?? .zero
    return .init(width: point.x, height: point.y)
  }
  private func dimension(for index: Int) -> CGFloat {
    cellFrames[index]?.width ?? .zero
  }
  enum Space: Int {
    case board
  }
  var body: some View {
    GeometryReader { boardGeometry in
      ZStack(alignment: .topLeading) {
        BoardView()
        ForEach(self.model.cells) { cell in
          CellView(cell: cell)
            .offset(self.offset(for: cell.index))
            .frame(width: self.dimension(for: cell.index), height: self.dimension(for: cell.index))
        }
      }
      .aspectRatio(1, contentMode: .fit)
      .coordinateSpace(name: Space.board)
      .swipeGesture(threshold: boardGeometry.size.width * 0.05) { direction in
        withAnimation(Animation.spring(dampingFraction: 0.5).speed(4)) {
          self.model.shift(direction: direction)
        }
      }
      .onPreferenceChange(CellPreferenceKey.self) { self.cellFrames = $0 }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    GameView()
  }
}
