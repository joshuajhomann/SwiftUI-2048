//
//  GameModel.swift
//  SwiftUI-2048
//
//  Created by Joshua Homann on 5/22/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import Combine
import SwiftUI


final class GameModel: ObservableObject {
  @Published private (set) var cells: [Cell] = []
  private var cellMap: [Int: Cell] = [:]

  struct Cell: Hashable, Identifiable, CustomStringConvertible {
    var id = UUID()
    var index: Int
    var value: Int
    var color: UIColor { Constant.colorMap[value] ?? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
    var description: String { value == 0 ? "" : String(describing: value) }
  }

  enum Constant {
    static let dimension = 4
    static let colorMap = [Int: UIColor](uniqueKeysWithValues: zip(
      Array(0...10).map { 2 << $0 },
      [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)]
    ))
  }
  
  enum Direction {
    case up, down, left, right
    var isHorizontal: Bool { Set([.right, .left]).contains(self) }
    var isPositive: Bool { Set([.up, .left]).contains(self) }
  }

  private let directionSubject = PassthroughSubject<Direction, Never>()
  private var subscriptions = Set<AnyCancellable>()
  init() {

    directionSubject
      .map { [weak self] direction -> ([Int: Cell], [Cell]) in
        var cells = self?.cellMap ?? [:]
        let index: (Int, Int) -> Int = direction.isHorizontal
          ? { $1 + $0 * Constant.dimension }
          : { $0 + $1 * Constant.dimension }
        for i in 0..<Constant.dimension {
          var indexAfterLastMerge = direction.isPositive ? 0 : Constant.dimension
          let makeRange: () -> [Int] = direction.isPositive
            ? { Array(indexAfterLastMerge..<Constant.dimension) }
            : { Array((0..<indexAfterLastMerge).reversed()) }
          let offset = direction.isPositive ? 1 : -1
          let mergeOffset = direction.isPositive ? 1 : 0
          for _ in (0..<Constant.dimension) {
            for j in (makeRange()).dropLast() {
              let currentIndex = index(i,j)
              let nextIndex = index(i,j + offset)
              guard var nextCell = cells[nextIndex] else {
                continue
              }
              guard let currentValue = cells[currentIndex]?.value else {
                nextCell.index = currentIndex
                cells[currentIndex] = nextCell
                cells[nextIndex] = nil
                continue
              }
              guard currentValue == nextCell.value else {
                continue
              }
              nextCell.index = currentIndex
              nextCell.value *= 2
              cells[currentIndex] = nextCell
              cells[nextIndex] = nil
              indexAfterLastMerge = j + mergeOffset
            }
          }
        }
        if let index = (0..<Constant.dimension * Constant.dimension).filter({ cells[$0] == nil }).randomElement() {
          cells[index] =  Cell(index: index, value: cells.isEmpty ? 2 : Int.random(in: 1...2) * 2)
        }
        return (cells, (0..<Constant.dimension * Constant.dimension).compactMap { cells[$0] })
      }
      .sink(receiveValue: { [weak self] (map, cells) in
        self?.cellMap = map
        self?.cells = cells
      })
      .store(in: &subscriptions)

    directionSubject.send(.up)
  }

  func shift(direction: Direction) {
    directionSubject.send(direction)
  }

  func index(x: Int, y: Int) -> Int {
    x + y * Constant.dimension
  }

}
