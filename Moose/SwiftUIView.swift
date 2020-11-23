//
//  SwiftUIView.swift
//  Moose
//
//  Created by Samuel Brasileiro on 17/11/20.
//

import SwiftUI
struct PaintingView: View{
    @ObservedObject var painting: Painting
    
    let color = Color(red: 0xd1/0xff, green: 0x78/0xff, blue: 0x30/0xff)
    
    var body: some View{
        VStack{
            if painting.image != nil{
                Image(uiImage: painting.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
            }
            else{
                
            }
            Text(painting.name)
                .font(.title3)
                .bold()
                .lineLimit(3)
                .foregroundColor(.primary)
            if let name = painting.artist{
                Text(name)
                    .foregroundColor(Color(.systemGray2))
                    .font(.subheadline)
                    .lineLimit(3)
            }
        }
    }
    
}

struct RootView: View {
    @ObservedObject var bank: PaintingsBank
    @State private var isSelected = false
    
    @State var selectedIndex: Int? = nil
    
    let color = Color(red: 0xd1/0xff, green: 0x78/0xff, blue: 0x30/0xff)
    
    var body: some View {
        
        VStack{
            if !isSelected{
                SearchBarView(bank: bank)
                    .padding(.vertical)
                ScrollView(.vertical, showsIndicators: true){
                    LazyVGrid(columns: [GridItem(), GridItem()], alignment: .leading, spacing: 10){
                        
                        ForEach(bank.getSelectedItems(), id: \.self){ index in
                            Button(action:{
                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                self.bank.searchText = ""
                                self.bank.isSearching = false
                                selectedIndex = index
                                isSelected = true
                                print("die")
                            }){
                                PaintingView(painting: bank.paintings[index])
                            }
                        }
                    }
                    
                    .padding(.horizontal)
                    
                }
                .resignKeyboardOnDragGesture()
                .padding(.bottom, 100.0)
            }
            
            else if let painting = bank.paintings[self.selectedIndex!]{
                VStack{
                    Button(action:{
                        isSelected = false
                        selectedIndex = nil
                    }){
                        HStack{
                            Image(systemName: "chevron.backward")
                                .padding(.leading)
                            Text("Back")
                            Spacer()
                        }
                        .foregroundColor(color)
                    }
                    ScrollView{
                        VStack{
                            if let image = painting.image{
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(20)
                                    .frame(maxWidth: 400, maxHeight: 400, alignment: .center)
                            }
                            
                            Text(painting.name)
                                .font(.title3)
                                .bold()
                                .padding(.horizontal)
                            if let name = painting.artist{
                                Text(name)
                                    .foregroundColor(Color(.systemGray2))
                                    .font(.subheadline)
                                    .padding(.horizontal)
                            }
                            Spacer()
                            if let description = painting.description{
                                Text(description)
                                    .padding()
                            }
                            Button(action: {
                                if let image = painting.image{
                                    bank.addSelectedPainting(image: image)
                                    bank.isCardOpen = false
                                    bank.cardPosition = UIScreen.main.bounds.height - 120
                                }
                            }){
                                Text("Add to your home")
                                    .padding()
                                    .background(color)
                                    .foregroundColor(.primary)
                                    .cornerRadius(10)
                                    .padding()
                            }
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            
        }
        .background(Color(.systemGray6).cornerRadius(20, corners: [.topLeft,.topRight]))
        .tag(0)
        
        
    }
    
}

struct ContentView: View {
    var bank: PaintingsBank
    var body: some View {
        SlideOverView(bank: bank){
            RootView(bank: bank)
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bank: PaintingsBank())
    }
}
