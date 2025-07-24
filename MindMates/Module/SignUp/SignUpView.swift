//
//  SignUpView.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 24.07.2025.
//

import SwiftUI

struct SignUpView: View {
    @State var pass = ""
    @State var email = ""
    @State var repass = ""
    @Binding var index: Int
    @State var error: String? = nil
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 10) {
                        Text("Регистрация")
                            .foregroundColor(self.index == 1 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(self.index == 1 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                }
                .padding(.top, 30)
                
                VStack{
                    TextField("Электронная почта", text: self.$email)
                    Divider()
                        .background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack{
                    TextField("Пароль", text: self.$pass)
                    Divider()
                        .background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                VStack {
                    TextField("Пароль", text: self.$repass)
                    Divider()
                        .background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                Text(authViewModel.error)
                    .foregroundStyle(.red)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("olive2"))
            .clipShape(CShape1())
            .contentShape(CShape1())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .cornerRadius(35)
            .padding(.horizontal, 20)
            .onTapGesture {
                self.index = 1
            }
            
            Button(action: {
                if pass != repass {
                    return
                }
                
                authViewModel.singUp(email: email, password: pass)
            }) {
                Text("Зарегистрироваться")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("olive"))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: -5)
            }
            .offset(y : 25)
            .opacity(self.index == 1 ? 1 : 0)
        }
    }
}

#Preview {
    SignUpView(index: .constant(0))
}
