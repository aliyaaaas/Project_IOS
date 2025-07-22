//
//  LoginScreen.swift
//  MindMates
//
//  Created by Азалина Файзуллина on 20.07.2025.
//
import SwiftUI

struct LoginScreen: View {
    @State var index = 0 //отвечает за переход между View  с логином и регистрацией

    var body: some View {
        GeometryReader { _ in
            VStack { //для логотипа
                Image("logo1")
                    .resizable()
                    .frame(width: 70, height: 70)
                
                ZStack {
                    SingUp( index: self.$index)
                        .zIndex(Double(self.index))
                    Login( index: self.$index)
                }
                //Spacer()
                //полоска ИЛИ
                HStack(spacing: 15) {
                    Rectangle()
                        .fill(Color("olive"))
                        .frame(height: 1)
                    
                    Text("ИЛИ")
                    
                    Rectangle()
                        .fill(Color("olive"))
                        .frame(height: 1)
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                //Spacer()
                
                //Три иконки для входа
                HStack(spacing: 25) {
                    Button( action: {
                        //
                    }) {
                        Image("apple")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    Button( action: {
                        //
                    }) {
                        Image("vk")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    Button( action: {
                        //
                    }) {
                        Image("google")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 30)
            }
            .padding(.vertical)

                        
        }
        .background(Color("paleGold").edgesIgnoringSafeArea(.all))
        //.preferredColorScheme(.dark)
     
    }
}

#Preview {
    LoginScreen()
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}

struct CShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            //сделали обрезку \
            path.move(to: CGPoint(x: rect.width, y: 100))
            //добавляю линии
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}

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

//для логина и пароля создаем
struct Login : View {
    @State var email = ""
    @State var pass = ""
    @Binding var index : Int
    
    var body : some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack{
                    VStack(spacing: 10){
                        Text("Вход")
                            .foregroundColor(self.index == 0 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        
                        //полосочка под Login
                        Capsule()
                            .fill(self.index == 0 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                    Spacer()
                } .padding(.top, 30)
                //для имэйла
                VStack {
                    HStack{
                        //Image(systemName: "envelop.fill")
                            //.foregroundColor(Color("Color1"))
                        TextField("Электронная почта", text: self.$email)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack {
                    HStack(spacing : 15){
                        //Image(systemName: "eye.slash.fill")
                            //.foregroundColor(Color("Color1"))
                        SecureField("Пароль", text: self.$pass)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.5))
                }.padding(.horizontal)
                    .padding(.top, 30)
                
                HStack {
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        //
                    }) {
                        Text("Забыли пароль?")
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                    
                }.padding(.horizontal)
                    .padding(.top, 30)
            } . padding()
                .padding(.bottom, 65)
                .background(Color("olive2"))
                .clipShape(CShape())
                .contentShape(CShape())
            //тень
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
                .onTapGesture {
                    self.index = 0
                }
                .cornerRadius(35)
                .padding(.horizontal, 20)
            
            Button(action: {
                //
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
            //сместим кнопку
            .offset(y:35)
            .opacity(self.index == 0 ? 1 : 0)
            
            
        }
    }
}
//кнопки для регистраций
struct SingUp : View {
    @State var email = ""
    @State var pass = ""
    //повторный ввод пароля
    @State var Repass = ""
    @Binding var index : Int
    
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
                    HStack(spacing: 15) {
                        //Image(systemName: "envelop.fill")
                            //.foregroundColor(Color("Color1"))
                        TextField("Электронная почта", text: self.$email)
                    }
                    Divider().background(Color.white.opacity(0.5))
                } .padding(.horizontal)
                .padding(.top, 40)
                
                VStack{
                    HStack(spacing: 15) {
                        //Image(systemName: "eye.slash")
                            //.foregroundColor(Color("Color1"))
                        SecureField("Пароль", text: self.$pass)
                    }
                    Divider()
                        .background(Color.white.opacity(0.5))
                } .padding(.horizontal)
                    .padding(.top, 30)
                
                VStack {
                    HStack(spacing: 15){
                        //Image(systemName: "eye.slash")
                            //.foregroundColor(Color("Color1"))
                        SecureField("Пароль", text: self.$Repass)
                    }
                    Divider().background(Color.white.opacity(0.5))
                } .padding(.horizontal)
                .padding(.top, 30)
                
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("olive2"))
            .clipShape(CShape1())
            .contentShape(CShape1())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.index = 1
                
            }
            //закругляем треугольник
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            Button(action: {
                //
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

