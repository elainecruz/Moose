//
//  SearchBarView.swift
//  MeusTopArtistas
//
//  Created by Samuel Brasileiro on 16/11/20.
//

import SwiftUI

/// The search bar view
struct SearchBarView: View{
    @ObservedObject var bank: PaintingsBank
    
    let color = Color(red: 0xd1/0xff, green: 0x78/0xff, blue: 0x30/0xff)
    
    var body: some View{
        // Search view
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search", text: $bank.searchText, onEditingChanged: { isEditing in
                    self.bank.isSearching = true
                }, onCommit: {
                    print("onCommit")
                }).foregroundColor(Color(.systemGray3))
                
                Button(action: {
                    self.bank.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(bank.searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.systemGray5))
            .cornerRadius(10.0)
            
            if bank.isSearching  {
                Button("Cancel") {
                    UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                    self.bank.searchText = ""
                    self.bank.isSearching = false
                }
                .foregroundColor(color)
                
            }
            else{
                Button(action:{
                    bank.clear()
                    bank.addItems()
                }){
                    Image(systemName: "repeat")
                        .foregroundColor(color)
                }
            }
        }
        .padding(.horizontal)
    }
    
}

struct SearchBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchBarView(bank: PaintingsBank())
        
    }
}
