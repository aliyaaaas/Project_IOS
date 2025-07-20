//
//  ClassesScreen.swift
//  MindMates
//
//  Created by BATIK on 20.07.2025.
//

import SwiftUI

struct ClassesScreen: View {
    let lightColor = Color(red: 242/255, green: 234/255, blue: 201/255)
    let darkColor = Color(red: 138/255, green: 132/255, blue: 0/255)
    let accentColor = Color(red: 168/255, green: 158/255, blue: 50/255)
    
    var body: some View {
        ZStack {
            lightColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ZStack {
                    accentColor
                        .frame(height: 100)
                        .edgesIgnoringSafeArea(.top)
                    
                    Text("Занятия")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 6, x: 0, y: 0)
                        .offset(y: 35)
                }
                .frame(height: 100)
                
                VStack(spacing: 30) {
                    Spacer().frame(height: 20)
                    
                    SectionButton(title: "Ближайшие занятия",
                                icon: "calendar.badge.clock",
                                action: {})
                    
                    SectionButton(title: "Прошедшие занятия",
                                icon: "clock.arrow.circlepath",
                                action: {})
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
            }
        }
    }
}

struct SectionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    let darkColor = Color(red: 138/255, green: 132/255, blue: 0/255)
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(darkColor)
                
                Text(title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(darkColor, lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ClassesScreen()
}
