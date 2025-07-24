//
//  CShape1.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 24.07.2025.
//

import SwiftUI

struct CShape1: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            //сделали обрезку \
            path.move(to: CGPoint(x: 0, y: 100))
            //добавляю линии
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}
