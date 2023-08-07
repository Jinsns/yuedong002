//
//  ShopView.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/7.
//

import SwiftUI


struct ShopItem: Identifiable {
    var id = UUID()
    var imageName: String
    var price: String
    var isSelected: Bool
}

var shopItems = [
    ShopItem(imageName: "DiamondRing", price: "370", isSelected: true),
    ShopItem(imageName: "CoconutTree", price: "160", isSelected: false),
    ShopItem(imageName: "wheat", price: "70", isSelected: false),
    ShopItem(imageName: "AngelRing", price: "42", isSelected: false)
]

struct ShopView: View {
    @Binding var isShowShopView: Bool
    @State var isMineOrShop = true
    @State var selectedItem = 1
    
    let greenTextColor = Color(red: 0.59, green: 0.74, blue: 0.43)
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 200) {
                HStack {
                    Button {
                        print("pressed back button in shop")
                        isShowShopView = false
                    } label: {
                        Image("AltArrowLeft")
                            .frame(width: 25.05524, height: 25.05524)
                        Text("返回")
                            .font(Font.custom("DFPYuanW7-GB", size: 20))
                            .kerning(0.4)
                            .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                    }
                }
                
                HStack(spacing: 4) {
                    Text("1,443")
                      .font(Font.custom("LilitaOne", size: 25.05524))
                      .kerning(0.5011)
                      .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 31, height: 33)
    //                  .position(x:40.5, y:16.5)
                      .background(
                        Image("leaf")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 31, height: 33)
                          .clipped()
                      )
                }
            }
            .padding(.top, 80)
            
            Spacer()
            
            VStack {
                HStack(alignment: .center, spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                        Button {
                            print("pressed shop")
                            isMineOrShop = false
                        } label: {
                            Text("商店")
                              .font(Font.custom("DFPYuanW9-GB", size: 16))
                              .multilineTextAlignment(.center)
                              .foregroundColor(!isMineOrShop ? .white : greenTextColor)
                              .frame(maxWidth: .infinity, minHeight: 18, maxHeight: 18, alignment: .top)
                        }

                        
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(!isMineOrShop ? Color(red: 0.49, green: 0.73, blue: 0.22) : .white)
                    .cornerRadius(9)
                    
                    HStack(alignment: .center, spacing: 0) {
                        Button {
                            print("pressed mine")
                            isMineOrShop = true
                        } label: {
                            Text("我的")
                              .font(Font.custom("DFPYuanW9-GB", size: 16))
                              .multilineTextAlignment(.center)
//                              .foregroundColor(.white)
                              .foregroundColor(isMineOrShop ? .white : greenTextColor)
                              .frame(maxWidth: .infinity, minHeight: 18, maxHeight: 18, alignment: .top)
                        }

                        
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .background(isMineOrShop ? Color(red: 0.49, green: 0.73, blue: 0.22) : .white)
                    .cornerRadius(9)
                }
                .padding(7)
                .frame(width: 168, height: 48, alignment: .center)
                .background(.white.opacity(0.6))
                .cornerRadius(8)
                
                if isMineOrShop {
                    MyItems()
                        .offset(x: 10)
                } else {
                    ShopItems(selectedItem: $selectedItem)
                        .offset(x: 10)
                }
                
                
                
                

            }
            .offset(x:100)
        }
    }
    
}

struct MyItems: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20.87937) {
            VStack(alignment: .center, spacing: 2.08794) {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 89.78129, height: 51.15445)
                  .background(
                    Image("sunglasses")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 89.78128814697266, height: 51.15445327758789)
                      .clipped()
                  )
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 12.52762)
            .frame(width: 107.52875, height: 107.52875, alignment: .center)
            .background(.white)
            .cornerRadius(16)
            .shadow(color: Color(red: 0.56, green: 0.77, blue: 0.33).opacity(0.48), radius: 16, x: 0, y: 0)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 7.33974) {
                Text("就它！")
                  .font(Font.custom("DFPYuanW9-GB", size: 24))
                  .kerning(2.88)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 15.41345)
            .frame(width: 154, height: 65, alignment: .trailing)
            .background(Color(red: 0.41, green: 0.63, blue: 0.16))
            .cornerRadius(9)
            .overlay(
              RoundedRectangle(cornerRadius: 9)
                .inset(by: 0.52)
                .stroke(Color(red: 0.41, green: 0.63, blue: 0.16), lineWidth: 1.04)
            )
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 25.05524)
        .frame(width: 168, height: 650, alignment: .top)
        .background(.white.opacity(0.6))
        .cornerRadius(8)
        
    }
}


struct ShopItems: View {
    @Binding var selectedItem: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 20.87937) {
            
            //a list to contains shopItems
//            List {
//                ForEach(shopItems) { shopItem in
//                    VStack(alignment: .center, spacing: 2.08794) {
//                        Rectangle()
//                          .foregroundColor(.clear)
//                          .frame(width: 61.59414, height: 63.68208)
//                          .background(
//                            Image(shopItem.imageName)
//                              .resizable()
//                              .aspectRatio(contentMode: .fill)
//                              .frame(width: 61.594139099121094, height: 63.68207550048828)
//                              .clipped()
//                          )
//                        HStack {
//                            Text(shopItem.price)
//                              .font(Font.custom("Lilita One", size: 20.87937))
//                              .kerning(0.41759)
//                              .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
//                            Rectangle()
//                              .foregroundColor(.clear)
//                              .frame(width: 19.8354, height: 19.8354)
//                              .background(
//                                Image("leaf")
//                                  .resizable()
//                                  .aspectRatio(contentMode: .fill)
//                                  .frame(width: 19.835399627685547, height: 19.835399627685547)
//                                  .clipped()
//                              )
//                        }
//                    }
//                    .padding(.horizontal, 0)
//                    .padding(.vertical, 12.52762)
//                    .frame(width: 107.52875, height: 107.52875, alignment: .bottom)
//                    .background(.white.opacity(0.5))
//                    .cornerRadius(16)
//                }
//            }
            
            //first item
            Button(action: {
                print("pressed shop item 1")
                selectedItem = 1
            }, label: {
                VStack(alignment: .center, spacing: 2.08794) {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 61.59414, height: 63.68208)
                      .background(
                        Image("DiamondRing")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 61.594139099121094, height: 63.68207550048828)
                          .clipped()
                      )
                    HStack {
                        Text("370")
                          .font(Font.custom("Lilita One", size: 20.87937))
                          .kerning(0.41759)
                          .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 19.8354, height: 19.8354)
                          .background(
                            Image("leaf")
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(width: 19.835399627685547, height: 19.835399627685547)
                              .clipped()
                          )
                    }
                }
            })
            .padding(.horizontal, 0)
            .padding(.vertical, 12.52762)
            .frame(width: 107.52875, height: 107.52875, alignment: .bottom)
            .background(selectedItem == 1 ? .white : .white.opacity(0.5))
            .cornerRadius(16)
            .shadow(color: selectedItem == 1 ? Color(red: 0.56, green: 0.77, blue: 0.33).opacity(0.48) : Color.clear, radius: 16, x: 0, y: 0)

            //second item
            Button(action: {
                print("pressed shop item 2")
                selectedItem = 2
            
            }, label: {
                VStack(alignment: .center, spacing: 2.08794) {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 61.59414, height: 65.77001)
                      .background(
                        Image("CoconutTree")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 61.594139099121094, height: 65.77001190185547)
                          .clipped()
                      )

                    HStack {
                        Text("160")
                          .font(Font.custom("Lilita One", size: 20.87937))
                          .kerning(0.41759)
                          .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 19.8354, height: 19.8354)
                          .background(
                            Image("leaf")
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(width: 19.835399627685547, height: 19.835399627685547)
                              .clipped()
                          )
                    }

                }
            })
            .padding(.horizontal, 0)
            .padding(.vertical, 12.52762)
            .frame(width: 107.52875, height: 107.52875, alignment: .bottom)
            .background(selectedItem == 2 ? .white : .white.opacity(0.5))
            .cornerRadius(16)
            .shadow(color: selectedItem == 2 ? Color(red: 0.56, green: 0.77, blue: 0.33).opacity(0.48) : Color.clear, radius: 16, x: 0, y: 0)

            //third item
            Button(action: {
                print("pressed shop item 3")
                selectedItem = 3
            
            }, label: {
                VStack(alignment: .center, spacing: 2.08794) {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 73.07779, height: 59.5062)
                      .background(
                        Image("wheat")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 73.07778930664062, height: 59.50619888305664)
                          .clipped()
                      )

                    HStack {
                        Text("70")
                          .font(Font.custom("Lilita One", size: 20.87937))
                          .kerning(0.41759)
                          .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 19.8354, height: 19.8354)
                          .background(
                            Image("leaf")
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(width: 19.835399627685547, height: 19.835399627685547)
                              .clipped()
                          )
                    }
                }
            })
            .padding(.horizontal, 0)
            .padding(.vertical, 12.52762)
            .frame(width: 107.52875, height: 107.52875, alignment: .bottom)
            .background(selectedItem == 3 ? .white : .white.opacity(0.5))
            .cornerRadius(16)
            .shadow(color: selectedItem == 3 ? Color(red: 0.56, green: 0.77, blue: 0.33).opacity(0.48) : Color.clear, radius: 16, x: 0, y: 0)

            //fourth item
            Button {
                print("pressed shop item 4")
                selectedItem = 4
            } label: {
                VStack(alignment: .center, spacing: 2.08794) {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 111.76781, height: 44.89064)
                      .background(
                        Image("AngelRing")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 111.76780700683594, height: 44.89064407348633)
                          .clipped()
                      )

                    HStack {
                        Text("42")
                          .font(Font.custom("Lilita One", size: 20.87937))
                          .kerning(0.41759)
                          .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 19.8354, height: 19.8354)
                          .background(
                            Image("leaf")
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(width: 19.835399627685547, height: 19.835399627685547)
                              .clipped()
                          )
                    }

                }

            }
            .padding(.horizontal, 0)
            .padding(.vertical, 12.52762)
            .frame(width: 107.52875, height: 107.52875, alignment: .bottom)
            .background(selectedItem == 4 ? .white : .white.opacity(0.5))
            .cornerRadius(16)
            .shadow(color: selectedItem == 4 ? Color(red: 0.56, green: 0.77, blue: 0.33).opacity(0.48) : Color.clear, radius: 16, x: 0, y: 0)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 7.33974) {
                Text("买它！")
                  .font(Font.custom("DFPYuanW9-GB", size: 24))
                  .kerning(2.88)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 25.41345)
            .frame(width: 154, height: 65, alignment: .trailing)
            .background(Color(red: 0.41, green: 0.63, blue: 0.16))
            .cornerRadius(9)
            .overlay(
              RoundedRectangle(cornerRadius: 9)
                .inset(by: 0.52)
                .stroke(Color(red: 0.41, green: 0.63, blue: 0.16), lineWidth: 1.04)
            )
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 25.05524)
        .frame(width: 168, height: 650, alignment: .bottom)
        .background(.white.opacity(0.6))
        .cornerRadius(8)
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView(isShowShopView: .constant(true))
    }
}
