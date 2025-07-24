//
//  SingIn.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 23.07.2025.
//

import SwiftUI
import Firebase

struct SignInView: View {
    @State var pass = ""
    @State var email = ""
    @Binding var index : Int
    @State var hasError: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body : some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack{
                    VStack(alignment: .leading,spacing: 10){
                        Text("Вход")
                            .foregroundColor(self.index == 0 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(self.index == 0 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                    Spacer()
                } .padding(.top, 30)
                
                VStack {
                    HStack{
                        TextField("Электронная почта", text: self.$email)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack {
                    HStack(spacing : 15){
                        SecureField("Пароль", text: self.$pass)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.5))
                }.padding(.horizontal)
                    .padding(.top, 30)
                
                Text(authViewModel.error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("olive2"))
            .clipShape(CShape())
            .contentShape(CShape())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .cornerRadius(35)
            .padding(.horizontal, 20)
            .onTapGesture {
                self.index = 0
            }
            
            Button(action: {
                authViewModel.login(email: email, password: pass)
            }) {
                Text("Войти")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("olive"))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1) ,radius: 5, x: 0, y: 5)
                
            }
            .offset(y:35)
            .opacity(self.index == 0 ? 1 : 0)
        }
        
    }
}

#Preview {
    SignInView(index: .constant(0))
}


struct CShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}
