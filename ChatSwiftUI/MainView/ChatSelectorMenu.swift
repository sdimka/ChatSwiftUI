//
//  ChatSelectorMenu.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 11.05.2024.
//

import Foundation
import SwiftUI

struct ChatSelectorMenu: View {
    
  
    let action : (String?) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4){
            
            ForEach(0...3, id: \.self){ valueStore in
                
                Button(action: {
                }) {
                    HStack(alignment: .center, spacing: 8) {
                        
                        Image(systemName: "bell")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .clipShape(Circle())
                        
                        VStack (alignment: .leading){
                            Text("ANDROID" )
//                                .font(.custom(Constants.FONT_REGULAR, size: 14))
                                .foregroundColor(Color.white)
                                .padding([.leading, .top], 4)
                            
                            Text("#jetpack")
//                                .font(.custom(Constants.FONT_REGULAR, size: 12))
                                .foregroundColor(Color.gray)
                                .padding([.leading, .bottom], 2)
                            
                        }
                        
                        
                    }.foregroundColor(Color.gray)
                    
                }.frame(width: .none, height: .none, alignment: .center)
                
                
                Divider().background(Color.black)
                
            }
            
        }.padding(.all, 12)
        .background(RoundedRectangle(cornerRadius: 6).foregroundColor(.white).shadow(radius: 2))
        
    }
}

struct ChatSelectorMenu_Previews: PreviewProvider {

    static var previews: some View {
        ChatSelectorMenu(action: {data in}).padding()
    }
}
