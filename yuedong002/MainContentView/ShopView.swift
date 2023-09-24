//
//  ShopView.swift
//  yuedong002
//
//  Created by Jzh on 2023/8/7.
//

import SwiftUI


struct OrnamentItem: Identifiable {
    var id = UUID()
    var imageName: String
    var price: Int
    var isSelected: Bool
    var itemID: Int
}

var allOrnamentItems = [
    OrnamentItem(imageName: "sunglasses", price: 100, isSelected: true, itemID: 0),
    OrnamentItem(imageName: "DiamondRing", price: 370, isSelected: true, itemID: 1),
    OrnamentItem(imageName: "CoconutTree", price: 160, isSelected: false, itemID: 2),
    OrnamentItem(imageName: "banana", price: 70, isSelected: false, itemID: 3),
    OrnamentItem(imageName: "AngelRing", price: 42, isSelected: false, itemID: 4),
]

var allOrnamentItemsDict: [Int: OrnamentItem] = [
    0: OrnamentItem(imageName: "sunglasses", price: 100, isSelected: true, itemID: 0),
    1: OrnamentItem(imageName: "DiamondRing", price: 370, isSelected: true, itemID: 1),
    2: OrnamentItem(imageName: "CoconutTree", price: 160, isSelected: false, itemID: 2),
    3: OrnamentItem(imageName: "banana", price: 70, isSelected: false, itemID: 3),
    4: OrnamentItem(imageName: "AngelRing", price: 42, isSelected: false, itemID: 4),
]




func selectOrnamentItem(itemArray: inout [OrnamentItem], selectedid: Int) {
    for i in 0..<itemArray.count {
        itemArray[i].isSelected = false
    }
    itemArray[selectedid].isSelected = true
}





struct ShopView: View {
    @AppStorage("shopItems") var shopItemIDs = [1, 2, 3, 4]
    @AppStorage("myItems") var myItemIDs = [0]
    
    @Binding var totalLeaves: Int
    @Binding var isShowShopView: Bool
    @State var isMineOrShop = false
    @State var selectedItemid = 0
    @State var isShowBuyedView = false
    @State var isShowLackMoneyView = false
    
    @State var isUnpaidItem = true
    
    @ObservedObject var scene: GiraffeScene
    
    let greenTextColor = Color(red: 0.59, green: 0.74, blue: 0.43)
    
    var body: some View {
        ZStack {
            VStack {
    //            VStack(alignment: .leading, spacing: 0) {
    //                Rectangle()
    //                    .foregroundColor(.black.opacity(0.4))
    //            }
    //            .padding(0)
    //            .cornerRadius(13)
    //            .frame(width: 170, height: 696)
    //            .offset(x: 104, y: 68)
    //            .blur(radius: 10)
                
                VStack {
                    HStack(alignment: .center, spacing: 200) {
                        HStack(spacing: 2) {
                            Button {
                                print("pressed back button in shop")
                                isShowShopView = false
                                scene.moveCameraNodeAndNeckNodeToGamePosition()
                                if isUnpaidItem {
                                    scene.removeOrnament()
                                }
                                
                            } label: {
                                Image("backFromShop")
                                    .frame(width: 6.26382, height: 12.94523)
                                Text("返回")
                                    .font(Font.custom("DFPYuanW7-GB", size: 20))
                                    .kerning(0.4)
                                    .foregroundColor(Color(red: 0.41, green: 0.63, blue: 0.16))
                            }
                        }
                        
                        HStack(spacing: 4) {
                            Text("\(totalLeaves)")
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
                    .padding(.top, 60)
                    
                }
                
                Spacer()
                
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack(alignment: .center , spacing: -1.044) {
                            HStack(alignment: .center, spacing: 0) {
                                HStack(alignment: .center, spacing: 0) {
                                    Button {
                                        print("pressed shop")
                                        isMineOrShop = false
                                        if let url = Bundle.main.url(forResource: "Overall_ClickButton", withExtension: "mp3") {
                                                    let player = AVAudioPlayerPool().playerWithURL(url: url)
                                                    player?.play()
                                                }
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
        //                        .cornerRadius(isMineOrShop ? 0 : 9)
                                
                                HStack(alignment: .center, spacing: 0) {
                                    Button {
                                        print("pressed mine")
                                        isMineOrShop = true
                                        if let url = Bundle.main.url(forResource: "Overall_ClickButton", withExtension: "mp3") {
                                                    let player = AVAudioPlayerPool().playerWithURL(url: url)
                                                    player?.play()
                                                }
                                        
                                    } label: {
                                        Text("我的")
                                          .font(Font.custom("DFPYuanW9-GB", size: 16))
                                          .multilineTextAlignment(.center)
                                          .foregroundColor(isMineOrShop ? .white : greenTextColor)
                                          .frame(maxWidth: .infinity, minHeight: 18, maxHeight: 18, alignment: .top)
                                    }

                                    
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .background(isMineOrShop ? Color(red: 0.49, green: 0.73, blue: 0.22) : .white)
                                .cornerRadius(9)
        //                        .cornerRadius(isMineOrShop ? 9 : 0)
                                
                            }
                            .padding(7)
                            .frame(width: 160, height: 48, alignment: .center)
    //                        .background(.white.opacity(0.7))
        //                    .background(.black)
                            .cornerRadius(8)
                        }
                        .padding(0)
                        .padding(.leading, 7.8)
        //                .cornerRadius(10)
                        
                        
                        if isMineOrShop {
                            MyItems(scene: scene, myItemIDs: $myItemIDs, shopItemIDs: $shopItemIDs, isUnpaidItem: $isUnpaidItem)
                                .offset(x: 8, y: -8)
        //                        .background(.black)
                        } else {
                            ShopItems(selectedItemid: $selectedItemid, scene: scene, totalLeaves: $totalLeaves, isShowBuyedView: $isShowBuyedView, isShowLackMoneyView: $isShowLackMoneyView, myItemIDs: $myItemIDs, shopItemIDs: $shopItemIDs)
                                .offset(x: 8, y: -8)
                        }
                        

                    }  //outer stack containing 商店，我的，items
    //                .padding(0)
                    .cornerRadius(13)
                    .padding(.trailing, 20)
        //                .offset(x:100, y: -10)
        //                .scaleEffect(<#T##scale: CGSize##CGSize#>)
                    .background(
                        Image("blurredbg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 170, height: 696)
                            .clipped()
                    )
                }
                
            }
            
            if isShowBuyedView {
                Image("buyed")
                    .offset(x: 0, y: -160)
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeOut(duration: 0.8)) {
                                isShowBuyedView = false
                            }
                            
                        }
                    }
            }
            
            if isShowLackMoneyView {
                Image("lackMoney")
                    .offset(x: 0, y: -160)
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeOut(duration: 0.8)) {
                                isShowLackMoneyView = false
                            }
                            
                        }
                    }
                
            }
            
        }

        
    }
    
}

struct MyItems: View {
    @ObservedObject var scene: GiraffeScene
    
    @Binding var myItemIDs: [Int]
    @Binding var shopItemIDs: [Int]
    @State var myItems: [OrnamentItem] = []
    @Binding var isUnpaidItem: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 20.87937) {
            VStack(alignment: .center, spacing: 2.08794) {
                ForEach(myItems.indices, id: \.self) { i in
                    Button {
                        print("pressed sunglasses button")
                        if let url = Bundle.main.url(forResource: "换装声音2", withExtension: "wav") {
                            let player = AVAudioPlayerPool().playerWithURL(url: url)
                            player?.play()
                        }
                        scene.addOrnament(ornamentName: myItems[i].imageName)
                    } label: {
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 89.78129, height: 51.15445)
                          .background(
                            Image(myItems[i].imageName)
                              .resizable()
                              .aspectRatio(contentMode: .fill)
                              .frame(width: 89.78128814697266, height: 51.15445327758789)
                              .clipped()
                          )
                    }

                }
                .padding(.horizontal, 0)
                .padding(.vertical, 12.52762)
                .frame(width: 107.52875, height: 107.52875, alignment: .center)
                .background(.white)
                .cornerRadius(16)
                .shadow(color: Color(red: 0.56, green: 0.77, blue: 0.33).opacity(0.48), radius: 16, x: 0, y: 0)
                }
                
                
            
            Spacer()
            
            HStack(alignment: .center, spacing: 7.33974) {
                Button {
                    print("pressed jiu ta")
                    isUnpaidItem = false
                    if let url = Bundle.main.url(forResource: "换装声音2", withExtension: "wav") {
                        let player = AVAudioPlayerPool().playerWithURL(url: url)
                        player?.play()
                    }
                    
                } label: {
                    Text("就它!")
                      .font(Font.custom("DFPYuanW9-GB", size: 24))
                      .kerning(2.88)
                      .padding(.leading, 1.8)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                }

                
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 15.41345)
            .frame(width: 140, height: 60, alignment: .center)
            .background(Color(red: 0.41, green: 0.63, blue: 0.16))
            .cornerRadius(9)
            .offset(x: -4)
//            .overlay(
//              RoundedRectangle(cornerRadius: 9)
//                .inset(by: 0.52)
//                .stroke(Color(red: 0.41, green: 0.63, blue: 0.16), lineWidth: 1.04)
//                .offset(x: -8)
//
//            )
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 25.05524)
        .frame(width: 168, height: 650, alignment: .top)
//        .background(.black.opacity(0.6))
//        .background(Image("blurredbg"))
        .cornerRadius(8)
        .onAppear() {
            for id in myItemIDs {
                
                myItems.append(allOrnamentItemsDict[id]!)
            }
        
        }
        
    }
}



struct ShopItems: View {
    @Binding var selectedItemid: Int
    @ObservedObject var scene: GiraffeScene
    @State var itemPrice: Int = 0
    @Binding var totalLeaves: Int
    @Binding var isShowBuyedView: Bool
    @Binding var isShowLackMoneyView: Bool
    
    @Binding var myItemIDs: [Int]
    @Binding var shopItemIDs: [Int]
    @State var shopItems: [OrnamentItem] = []
    
    @State var curSelectedi: Int = 0
//    @Binding var isUnpaidItem: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 20.87937) {
            
            ForEach(shopItems.indices, id: \.self) { i in
                Button(action: {
                    print("pressed shop item 1")
                    if let url = Bundle.main.url(forResource: "换装声音2", withExtension: "wav") {
                        let player = AVAudioPlayerPool().playerWithURL(url: url)
                        player?.play()
                    }
                    selectOrnamentItem(itemArray: &shopItems, selectedid: i)
                    selectedItemid = shopItems[i].itemID
                    itemPrice = shopItems[i].price
                    scene.addOrnament(ornamentName: shopItems[i].imageName)
                    curSelectedi = i
                }, label: {
                    VStack(alignment: .center, spacing: 2.08794) {
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 61.59414, height: 63.68208)
                          .background(
                            Image(shopItems[i].imageName)
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 61.594139099121094)
                              .clipped()
                          )
                        HStack {
                            Text(String(shopItems[i].price))
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
                .background(shopItems[i].isSelected ? .white : .white.opacity(0.5))
                .cornerRadius(16)
                .shadow(color: shopItems[i].isSelected ? Color(red: 0.56, green: 0.77, blue: 0.33).opacity(0.48) : Color.clear, radius: 16, x: 0, y: 0)
    
            }
            

            
            Spacer()
            
            HStack(alignment: .center, spacing: 7.33974) {
                Button {
                    
                    if totalLeaves >= itemPrice {
                        print("pressed buy button: buy success")
                        withAnimation {
                            isShowBuyedView = true
                        }
                        
                        if let url = Bundle.main.url(forResource: "Shop_BuyItBtn", withExtension: "mp3") {
                            let player = AVAudioPlayerPool().playerWithURL(url: url)
                            player?.play()
                        }
                        totalLeaves -= itemPrice
                        if myItemIDs.contains(allOrnamentItemsDict[selectedItemid]!.itemID) == false {
                            myItemIDs.append(allOrnamentItemsDict[selectedItemid]!.itemID)
                        }
                       
                        shopItemIDs.remove(at: curSelectedi)
                        shopItems.remove(at: curSelectedi)
                        
                    } else {
                        print("pressed buy button: lack money")
                        withAnimation {
                            isShowLackMoneyView = true
                        }
                        
                    }
                    
                    
                } label: {
                    Text("买它！")
                      .font(Font.custom("DFPYuanW9-GB", size: 24))
                      .kerning(2.88)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                }
                
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 25.41345)
            .frame(width: 150, height: 60, alignment: .trailing)
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
//        .background(.white.opacity(0.6))
//        .background(Image("blurredbg"))
        .cornerRadius(8)
        .onAppear() {
            for itemID in shopItemIDs {
                print("!!", allOrnamentItemsDict[itemID])
                shopItems.append(allOrnamentItemsDict[itemID]!)
            }
            print("!!!!--", shopItems)
            
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView(totalLeaves: .constant(1443), isShowShopView: .constant(true), scene: GiraffeScene())
    }
}


extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
