//
//  PageTab.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 5/4/21.
//

import SwiftUI

struct PaginaTutorial: View {
   
    // Atributos compartidos por otras vistas
    @Binding var seleccion :Int
    
    var body: some View {
        
        TabView(selection: self.$seleccion){
            ForEach(tabs.indices, id: \.self){ index in
                PaginaTutorialContenido(index: index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }

    
    struct PaginaTutorial_Previews: PreviewProvider {
        static var previews: some View {
            PaginaTutorial(seleccion: Binding.constant(0))
        }
    }
}
