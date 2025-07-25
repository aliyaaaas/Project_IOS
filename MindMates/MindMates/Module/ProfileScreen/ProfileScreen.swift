//
//  ProfileScreen.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 24.07.2025.
//

import SwiftUI

import Foundation
import FirebaseAuth


struct ProfileScreen: View{
    
    @State var index = 0
    @State var show = false
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View{
        ZStack{
            HStack{
                VStack(alignment: .leading, spacing: 12){
                    Image(viewModel.role == .student ? .avatarStudent : .avatarTeacher)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    Text("Здравствуй, \(viewModel.displayName)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.olive)
                        .padding(.top, 10)
                    
                    VStack(spacing: 8) {
                        Text(viewModel.displayName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.olive)

                        Text(viewModel.email)
                            .font(.subheadline)
                            .foregroundColor(.olive)

                        Button {
                            if viewModel.role == .student {
                                viewModel.updateRole(.teacher)
                            } else {
                                viewModel.updateRole(.student)
                            }
                            
                        } label: {
                            Text(viewModel.role?.rawValue ?? "Выберите роль")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.olive)
                                .cornerRadius(12)
                        }

                        
                        
                        
                        Button(action: {
                            self.index = 0
                            
                            withAnimation {
                                self.show.toggle()
                            }
                        }) {
                            HStack(spacing: 25) {
                                Image("settings")
                                    .foregroundColor(self.index == 0 ? Color("olive") : Color.white)
                                Text("Настройки")
                                    .foregroundColor(self.index == 0 ? Color("olive") : Color.white)
                            } .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(self.index == 0 ? Color("olive").opacity(0.2) : Color.clear)
                                .cornerRadius(10)
                           
                            //cлед кнопка
                        }.padding(.top, 25)

                        
                        Divider()
                            .frame(width:150, height: 1)
                            .background(Color.white)
                            .padding(.vertical, 30)
                    }
                    Spacer(minLength: 0)
                   
                   
                    
                } .padding(.top,25)
                 .padding(.horizontal,20)
                
                Spacer(minLength: 0)
                
            }
            .background(.white)
            .padding(.top, {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                    return 0
                }
                return windowScene.windows.first?.safeAreaInsets.top ?? 0
            }())
            .padding(.bottom, {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                    return 0
                }
                return windowScene.windows.first?.safeAreaInsets.bottom ?? 0
            }())
           
            //.background(.white)
            //.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            //.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            
            VStack(spacing: 0) {
                HStack(spacing: 15) {
                    Button(action: {
                        withAnimation{
                            self.show.toggle()
                        }
                    }) {
                        Image(systemName: self.show ? "xmark" : "line.horizontal.3")
                            .resizable()
                            .frame(width: self.show ? 18 : 22, height: 18)
                            .foregroundColor(Color.black.opacity(0.4))
                    }
                    Text(self.index == 0 ? "Настройки" : "Профиль")
                        .font(.title)
                        .foregroundColor(Color.black.opacity(0.6))
                    
                    Spacer(minLength: 0)
                }//
                
                .padding(.top, {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first else {
                        return 0
                    }
                    return window.safeAreaInsets.top
                }())
                .padding()
                
                //.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                //.padding()
                
                
                GeometryReader { _ in
                    VStack {
                        if self.index == 0 {
                            SettingView()
                        }
                    }
                }
            }
            .background(.paleGold)
            .cornerRadius(self.show ? 30 : 0)
            .scaleEffect(self.show ? 0.9 : 1)
            .offset(x: self.show ? UIScreen.main.bounds.width / 2 : 0, y : self.show ? 15 : 0)
            .rotationEffect(.init(degrees: self.show ? -5 : 0))
        } .background(Color("paleGold").edgesIgnoringSafeArea(.all))
            .edgesIgnoringSafeArea(.all)
        
        
    }
    
}



struct ProfileScreen_Previews: PreviewProvider{
    static var previews: some View{
        ProfileScreen()
    }
}
