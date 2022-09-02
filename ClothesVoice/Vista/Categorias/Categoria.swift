//
//  CategoriasRopa.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 5/4/21.
//
/*
 En esta vista se muestran las prendas llamando a la vista CategoryRow.swift pero filtrando con la categoría seleccionada.
*/

import SwiftUI

struct Categoria: View {
   
    // Atributos compartidos por otras vistas
    @Binding var login: Bool
    @Binding var perfil: Bool
    @Binding var favoritos: Bool
    @Binding var cesta: Bool
    @Binding var asistente: Bool
    @Binding var categoria_ropa: String
    @Binding var opcion_sexo: Int // 0 --> HOMBRE, 1 --> MUJER, 2 --> NIÑO, 3 --> UNISEX
    @ObservedObject var usuario : Usuario
    @ObservedObject var prendasModelData : PrendasModelData
    
    // Atributos privados de la vista
    @State private var menu = false
    
    @Environment(\.presentationMode) private var presentation

    private let sexos = ["Mujer","Hombre","Niños","Unisex"]
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View{
        
        NavigationView{
            
            ZStack{
                
                Image("fondo_inicio").ignoresSafeArea()
                
                // CONTENIDO
                VStack{
                    
                    EspacioMedio()
                    EspacioMedio()
                    
                    HStack{
                        
                        EspacioMedio()
                        
                        Button(action: {self.presentation
                                .wrappedValue
                                .dismiss()},
                               label: {
                                    Image(systemName: "arrow.backward.circle").resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                               })
                        .foregroundColor(.white)
                        
                        EspacioGrande()
                        EspacioMedio()
                        EspacioMedio()
                        
                        Text(self.categoria_ropa)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .padding(.top, 5)
                        
                        EspacioGrande()
                        EspacioGrande()
                        EspacioGrande()
                    }
                    
                    EspacioMedio()
                    
                    ScrollView(.vertical, showsIndicators: false){
                        LazyVGrid(columns: self.columns, spacing: 20){
                            ForEach(self.prendasModelData.prendas){
                                prenda in
                                if (prenda.consultarCategoriaRopa().rawValue == self.categoria_ropa) && ( (prenda.consultarCategoriaSexo().rawValue == self.sexos[opcion_sexo]) || ((prenda.consultarCategoriaSexo().rawValue == "Unisex") && (self.opcion_sexo == 0 || self.opcion_sexo == 1))){
                                    withAnimation{
                                        ElementoCategoria(prenda: prenda, deCesta: Binding.constant(false), prendasModelData: self.prendasModelData, usuario: self.usuario)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    } // Fin ScrollView
                    
                }// FIN CONTENIDO
                .onAppear(){
                    self.prendasModelData.obtenerFavoritosCesta()
                    self.usuario.obtenerDatos()
                }
            }
            .navigationBarHidden(true)
        } // Fin NavigationView
        .navigationBarHidden(true)
    }

    
    struct Categoria_Previews: PreviewProvider {
        static var usuario = Usuario()
        static var previews: some View {
            Categoria(login: Binding.constant(false), perfil: Binding.constant(false), favoritos: Binding.constant(false), cesta: Binding.constant(false), asistente: Binding.constant(false), categoria_ropa: Binding.constant("Sudaderas"),
                      opcion_sexo: Binding.constant(0), usuario: self.usuario, prendasModelData: PrendasModelData())
        }
    }
}
