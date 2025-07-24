//
//  LoginScreen.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 20.07.2025.
//
import SwiftUI

struct AuthView: View {
    @State var index = 0
    
    var body: some View {
        VStack {
            Image("logo1")
                .resizable()
                .frame(width: 70, height: 70)
            
            ZStack {
                SignUpView(index: $index)
                    .zIndex(Double(self.index))
                SignInView(index: $index)
            }
        }
        .padding(.vertical)
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
