//
//  RelaxMode.swift
//  yuedong002
//
//  Created by Jzh on 2023/7/18.
//

import SwiftUI

struct RelaxMode: View {
    @State private var isLoginPresented = false
    @State private var showSongSelection = false
    
    
    var body: some View {
        ZStack {
            Image("EnterRelax")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.vertical)
                .padding(.horizontal, 14)
                .padding(.trailing, 10)
                        
                    
                    HStack {
//                        Spacer()

                        VStack(spacing: 16) {
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
                        .padding(.top, 226)
                         
                        
                    }
            
            Button(action: {
                                showSongSelection = true
                            }) {
                                Text("             ")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                                    .padding()
                                    .background(
                                        Rectangle()
                                            .fill(Color.white)
                                            .opacity(0.4)
                                    )
                                    .frame(width: 450, height: 100)
                            }
//                            .sheet(isPresented: $showSongSelection) {
//                                Relaxing()
//                            }
                            .padding(.bottom, 40)
                            .padding(.top, 580)
                            .fullScreenCover(isPresented: $showSongSelection, content: {
                                Relaxing()
                            })
                }
        
        
    
    }
}

struct LoginView: View {
    @State private var isAgreed = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Button (action:{
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
            })
            
            
            
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
                    // 执行apple登录操作
                }) {
                    HStack{
                        Image(systemName: "applelogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)

                        Text("Apple登录")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                        
                    )
                    .cornerRadius(10)
                }
            }
            .padding()
            .padding(.top, 50)

        }
        
//        Button(action: {
//               presentationMode.wrappedValue.dismiss()
//           }) {
//               Text("Close")
//                   .padding()
//                   .background(Color.red)
//                   .foregroundColor(.white)
//                   .cornerRadius(10)
//           }
        
        Spacer()
        
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
