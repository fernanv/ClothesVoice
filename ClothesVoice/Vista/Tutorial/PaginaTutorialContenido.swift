//
//  TabDetails.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 5/4/21.
//

import SwiftUI

struct PaginaTutorialContenido: View {
   
    // Atributos compartidos por otras vistas
    let index :Int
    
    var body: some View {
        
        VStack{
            Text(tabs[self.index].title)
                .font(.title3)
                .foregroundColor(Color.white)
                .bold()
            Image(tabs[self.index].image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 400)
            Text(tabs[self.index].text)
                .foregroundColor(Color.white)
                .padding()
        }
        .foregroundColor(.white)
    }

    
    struct PaginaTutorialContenido_Previews: PreviewProvider {
        static var previews: some View {
            PaginaTutorialContenido(index: 0)
        }
    }
}

