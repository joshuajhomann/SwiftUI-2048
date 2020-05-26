//
//  BoardView.swift
//  SwiftUI-2048
//
//  Created by Joshua Homann on 5/25/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI

struct BoardView: View {
  @EnvironmentObject var model: GameModel
  var body: some View {
    VStack {
      ForEach (0..<GameModel.Constant.dimension) { y in
        HStack {
          ForEach (0..<GameModel.Constant.dimension) { x in
            GeometryReader { geometry in
              Color(UIColor.gray)
              .cornerRadius(geometry.size.height * 0.125)
              .preference(
                key: CellPreferenceKey.self,
                value: [self.model.index(x: x, y: y): geometry.frame(in: CoordinateSpace.named(GameView.Space.board))]
              )
            }
          }
        }
      }
    }
  }
}
