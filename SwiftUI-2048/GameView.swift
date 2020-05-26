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
  @State private var boardFrame: CGRect = .zero
  private var boardDimension: CGFloat { min(boardFrame.size.width, boardFrame.size.height) }
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
    GeometryReader { outer in
      ZStack(alignment: .topLeading) {
        BoardView().environmentObject(self.model)
        ForEach(self.model.cells) { cell in
          CellView(cell: cell)
            .offset(self.offset(for: cell.index))
            .frame(width: self.dimension(for: cell.index), height: self.dimension(for: cell.index))
        }
      }
      .preference(key: BoardPreferenceKey.self, value: outer.frame(in: CoordinateSpace.named(GameView.Space.board)))
      .frame(width: self.boardDimension, height: self.boardDimension)
      .gesture(
        DragGesture(minimumDistance: outer.size.width * 0.10).onEnded { value in
            let isHorizontal = abs(value.translation.width) > abs(value.translation.height)
            let isPositive = isHorizontal
              ? value.translation.width > 0
              : value.translation.height > 0
            let direction: GameModel.Direction = isHorizontal
              ? isPositive ? .right : .left
              : isPositive ? .down : .up
            withAnimation(Animation.spring(dampingFraction: 0.5).speed(4)) {
              self.model.shift(direction: direction)
            }
          }
        )
      }
      .coordinateSpace(name: Space.board)
      .onPreferenceChange(CellPreferenceKey.self) { self.cellFrames = $0 }
      .onPreferenceChange(BoardPreferenceKey.self) { self.boardFrame = $0 }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    GameView()
  }
}
