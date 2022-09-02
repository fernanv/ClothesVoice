//
//  BotonesTutorial.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 5/4/21.
//

import SwiftUI

struct BotonesTutorial: View {
   
    // Atributos compartidos por otras vistas
    @Binding var seleccion :Int
    
    // Atributos privados de la vista
    private let buttons = ["Anterior", "Siguiente"]
    
    var body: some View {
        
        HStack{
            ForEach(self.buttons, id: \.self){ buttonLabel in
                Button(action: {self.buttonAction(buttonLabel)}, label: {
                    Text(buttonLabel)
                        .font(.headline)
                        .padding()
                        .frame(width: 150, height: 44)
                        .background(Color.black.opacity(0.27))
                        .cornerRadius(12)
                        .padding(.horizontal)
                })
            }
        }
        .foregroundColor(.white)
        .padding()
        
    }
    
    func buttonAction(_ buttonLabel: String){
        withAnimation{
            if buttonLabel == "Anterior" && self.seleccion > 0{
                self.seleccion -= 1
            }
            else if buttonLabel == "Siguiente" && self.seleccion < tabs.count - 1{
                self.seleccion += 1
            }
            else{
            }
        }
    }

    
    struct BotonesTutorial_Previews: PreviewProvider {
        static var previews: some View {
            BotonesTutorial(seleccion: Binding.constant(0))
        }
    }
}
