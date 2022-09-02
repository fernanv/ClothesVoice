//
//  PrendasFiltradas.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 1/9/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import SwiftUI

struct PrendasFiltradas: View {
   
    // Atributos compartidos por otras vistas
    @Binding var login: Bool
    @Binding var perfil: Bool
    @Binding var favoritos: Bool
    @Binding var cesta: Bool
    @Binding var asistente: Bool
    @ObservedObject var usuario : Usuario
    @ObservedObject var prendasModelData : PrendasModelData
    
    // Atributos privados de la vista
    @State private var menu = false
    
    @Environment(\.presentationMode) private var presentation
    
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
                    EspacioPeque()
                    EspacioMedio()
                    
                    Button(action: {
                        self.prendasModelData.salirFiltradas()
                        self.presentation
                            .wrappedValue
                            .dismiss()
                        },
                           label: {
                                Image(systemName: "multiply").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                    })
                    .foregroundColor(.white)
                    .padding(.trailing, 320.0)
                    .padding(.top, 60.0)
                    
                    EspacioPeque()
                    
                    Text("Prendas Filtradas")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                            
                    Group{
                        Text("\(self.prendasModelData.itemsFiltrados) artículos seleccionados")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .padding(.top, 5)
                            .padding(.trailing, 200)
                        EspacioPeque()
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: self.columns, spacing: 20) {
                            ForEach(self.prendasModelData.prendasFiltradas) { prenda in
                                withAnimation{
                                    ElementoCategoria(prenda: prenda, deCesta: Binding.constant(false), prendasModelData: self.prendasModelData, usuario: usuario)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .onAppear(){
                            self.prendasModelData.obtenerPrendasFiltradas()
                            self.usuario.obtenerDatos()
                        }
                        
                    } // Fin ScrollView
                    
                    Group{
                        Spacer()
                        
                        // MENÚ INFERIOR DE NAVEGACIÓN
                        NavMenu(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario)
                    }
                    
                } // Fin CONTENIDO
                .fullScreenCover(isPresented: self.$menu){
                    MenuCabecera(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData)
                }
            } // Fin NavigationView
            .navigationBarHidden(true)
        }
    }

    struct PrendasFiltradas_Previews: PreviewProvider {
        static var usuario = Usuario()
        static var previews: some View {
            PrendasFiltradas(login: Binding.constant(false), perfil: Binding.constant(false),favoritos: Binding.constant(true), cesta: Binding.constant(false), asistente: Binding.constant(false), usuario: self.usuario, prendasModelData: PrendasModelData())
        }
    }
}


