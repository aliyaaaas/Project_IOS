//
//  ClassesScreen.swift
//  MindMates
//
//  Created by BATIK on 20.07.2025.
//

import SwiftUI

struct ClassesScreen: View {
    @Binding var goToPastTaskScreen: Bool
    @Binding var goToFutureClassScreen: Bool
    let lightColor = Color(red: 245/255, green: 233/255, blue: 209/255)
    let darkColor = Color(red: 148/255, green: 144/255, blue: 115/255)
    let accentColor = Color(red: 168/255, green: 158/255, blue: 50/255)
    
    var body: some View {
        ZStack {
            lightColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ZStack {
                    darkColor
                        .frame(height: 100)
                        .edgesIgnoringSafeArea(.top)
                    Text("MindMates")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .opacity(Double(0.4))
                        .offset(y: -30)
                    
                    Text("Мои занятия")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(darkColor)
                        .offset(y: 70)
                }
                .frame(height: 100)
                
                VStack(spacing: 50) {
                    Spacer().frame(height: 70)
                    
                    SectionButton(title: "Ближайшие занятия",
                                icon: "calendar.badge.clock",
                                action: {goToFutureClassScreen = true})
                    
                    SectionButton(title: "Прошедшие занятия",
                                icon: "clock.arrow.circlepath",
                                action: {goToPastTaskScreen = true})
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
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
                    .stroke(darkColor, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
