//
//  Tutorial.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 5/4/21.
//

import SwiftUI

struct Tutorial: View {
   
    // Atributos compartidos por otras vistas
    @Binding var tutorial: Bool
    
    // Atributos privados de la vista
    @State private var seleccion = 0
    
    var body: some View {
        
        NavigationView{
            ZStack{
               
                Image("fondo_inicio").ignoresSafeArea()
                
                // CONTENIDO
                VStack{   
                    EspacioGrande()
                    Image("SCARS")
                    PaginaTutorial(seleccion: self.$seleccion)
                    Spacer()
                    BotonesTutorial(seleccion: self.$seleccion)
                    Spacer()
                    BotonSaltar(tutorial: self.$tutorial)
                    EspacioGrande()
                } // Fin CONTENIDO
            }
            .navigationBarHidden(true)
            .transition(.move(edge: .bottom))
        }
    }

    
    struct Tutorial_Previews: PreviewProvider {
        static var previews: some View {
            Tutorial(tutorial: Binding.constant(true))
        }
    }
}
