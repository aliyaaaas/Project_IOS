//
//  LoginScreen.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 20.07.2025.
//
import SwiftUI

struct AuthView: View {
    @State var index = 0
    @State var isAuthenticated = false
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isAuthenticated {
            MainTabView()
                .environmentObject(authViewModel)
        } else {
            VStack {
                Image("logo1")
                    .resizable()
                    .frame(width: 70, height: 70)
                        
                ZStack {
                    SignUpView(index: $index, isAuthenticated: $authViewModel.isAuthenticated)
                        .zIndex(Double(self.index))
                        .environmentObject(authViewModel)
                            
                    SignInView(index: $index, isAuthenticated: $authViewModel.isAuthenticated)
                        .environmentObject(authViewModel)
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    AuthView()
}

//кнопки для регистраций
//Три иконки для входа
//HStack(spacing: 25) {
//    Button( action: {
//        //
//    }) {
//        Image("apple")
//            .resizable()
//            .renderingMode(.original)
//            .frame(width: 50, height: 50)
//            .clipShape(Circle())
//    }
//    Button( action: {
//        //
//    }) {
//        Image("vk")
//            .resizable()
//            .renderingMode(.original)
//            .frame(width: 50, height: 50)
//            .clipShape(Circle())
//    }
//    Button( action: {
//        //
//    }) {
//        Image("google")
//            .resizable()
//            .renderingMode(.original)
//            .frame(width: 50, height: 50)
//            .clipShape(Circle())
//    }
//}
//.padding(.top, 30)
