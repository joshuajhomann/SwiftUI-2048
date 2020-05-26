//
//  CellView.swift
//  SwiftUI-2048
//
//  Created by Joshua Homann on 5/25/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI

struct CellView: View {
  var cell: GameModel.Cell
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color(self.cell.color)
          .cornerRadius(geometry.size.height * 0.125)
        Text(self.cell.description)
        .font(.system(size: geometry.size.height * Self.fontScale(for: self.cell.description)))
        .foregroundColor(.white)
      }
    }
  }
  static func fontScale(for string: String) -> CGFloat {
    switch string.count {
    case 3: return 0.5
    case 4: return 0.35
    default: return 0.7
    }
  }
}
