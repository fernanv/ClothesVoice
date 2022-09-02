//
//  BotonSaltar.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 5/4/21.
//

import SwiftUI

struct BotonSaltar: View {
   
    // Atributos compartidos por otras vistas
    @Binding var tutorial: Bool
    
    var body: some View {
        
        Button(action: { self.dismiss() }, label: {
            Text("Saltar el tutorial").underline()
        })

    }
    
    func dismiss(){
        withAnimation{
            self.tutorial.toggle()
            UserDefaults.standard.set(true, forKey: "tutorial")
        }
    }

    struct BotonSaltar_Previews: PreviewProvider {
        static var previews: some View {
            BotonSaltar(tutorial: Binding.constant(true))
        }
    }
}
