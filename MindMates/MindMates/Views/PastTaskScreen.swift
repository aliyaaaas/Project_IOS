//
//  PastTaskScreen.swift
//  MindMates
//
//  Created by BATIK on 20.07.2025.
//
import SwiftUI

struct PastTaskScreen: View {
    @Binding var goToPastTaskScreen: Bool

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
                        .opacity(0.4)
                        .offset(y: -30)
                    
                    Button(action: {
                        goToPastTaskScreen = false
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                            Text("Назад")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .offset(y: -30)

                    Text("Прошедшие занятия")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(darkColor)
                        .offset(y: 70)
                }
                .frame(height: 100)

                VStack(spacing: 50) {
                    Spacer().frame(height: 70)

                    Text("Тут будут прошедшие занятия")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(darkColor, lineWidth: 2)
                        )

                    Spacer()
                }
                .padding(.horizontal, 40)
            }
        }
    }
}
