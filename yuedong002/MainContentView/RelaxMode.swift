//
//  RelaxMode.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/18.
//

import SwiftUI

struct RelaxMode: View {
    @State private var isLoginPresented = false
    
    
    var body: some View {
        ZStack {
                    Image("EnterRelax")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    HStack {
//                        Spacer()

                        VStack(spacing: 8) {
                            Button(action: {
                                // 处理第一个按钮的点击事件
                                print("Button 1 tapped")
                                isLoginPresented = true
                            }) {
                                Text("              ")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(Color.white)
                                            .opacity(0.4)
                                    )
                                    .frame(width: 100, height: 100)
                            }
                            .sheet(isPresented: $isLoginPresented) {
                                LoginView()
                            }

                            Button(action: {
                                // 处理第二个按钮的点击事件
                                print("Button 2 tapped")
                            }) {
                                Text("             ")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                                    .padding()
                                    .background(
                                        Circle()
                                            .fill(Color.white)
                                            .opacity(0.4)
                                    )
                                    .frame(width: 100, height: 100)
                            }
                        }
                        .padding(.leading, 300)
                        .padding(.top, 210)
                         
                        
                    }
                }
        
        
    
    }
}

struct LoginView: View {
    @State private var isAgreed = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                // 执行手机号登录操作
            }) {
                HStack{
                    Image("WeChatIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)

                    Text("WeChat登录")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.green)
                .cornerRadius(10)
            }
                    
                    Button(action: {
                        // 执行手机号登录操作
                    }) {
                        HStack{
                            Image(systemName: "phone")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)

                            Text("手机号登录")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    
            Button(action: {
                // 执行手机号登录操作
            }) {
                HStack{
                    Image(systemName: "applelogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)

                    Text("Apple登录")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.black)
                .cornerRadius(10)
            }
        }
                .padding()
        
        Button(action: {
               presentationMode.wrappedValue.dismiss()
           }) {
               Text("Close")
                   .padding()
                   .background(Color.red)
                   .foregroundColor(.white)
                   .cornerRadius(10)
           }
        
        HStack(spacing: 8) {
                        Circle()
                            .stroke(Color.black, lineWidth: 2)
                            .foregroundColor(isAgreed ? .green : .gray)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                                    .opacity(isAgreed ? 1 : 0)
                            )
                            .onTapGesture {
                                isAgreed.toggle()
                            }
                        
                        Text("同意协议")
                            .font(.footnote)
                    }
    }
}


struct RelaxMode_Previews: PreviewProvider {
    static var previews: some View {
        RelaxMode()
    }
}
