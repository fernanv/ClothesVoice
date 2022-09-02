//
//  Favoritos.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 11/4/21.
//
/*
En esta vista se muestran las prendas que han sido añadidas a favoritos, con un botón para retirar cada una de esta sección de favoritos y otro para añadir o retirar la prenda de la cesta.
*/

import SwiftUI

struct Favoritos: View {
   
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
                    
                    // MENÚ SUPERIOR DESPLEGABLE
                    Button(action: {self.menu.toggle()}, label: {
                        Image("SCARS")
                    })
                    .padding(.bottom, 45.0)
                    
                    Spacer()
                    Spacer()
                    
                    Text("Favoritos")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .padding(.trailing, 290)
                    
                    if self.usuario.estado{
                            
                        Group{
                            Text("\(self.prendasModelData.itemsFavoritos) artículos seleccionados")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color.white)
                                .padding(.top, 5)
                                .padding(.trailing, 200)
                        }
                        
                        EspacioPeque()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: self.columns, spacing: 20) {
                                ForEach(self.prendasModelData.prendas, id: \.id) { prenda in
                                    if prenda.estaEnFavoritos() {
                                        withAnimation{
                                            ElementoCategoria(prenda: prenda, deCesta: Binding.constant(false), prendasModelData: self.prendasModelData, usuario: self.usuario)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        } // Fin ScrollView
                        .onAppear(){
                            self.prendasModelData.obtenerFavoritosCesta()
                            self.usuario.obtenerDatos()
                        }
                        
                    }
                    else{
                        Group{
                            EspacioGrande()
                            EspacioGrande()
                            EspacioGrande()
                            EspacioGrande()
                            EspacioGrande()
                            EspacioGrande()
                            Spacer()
                        }
                        
                        Button(action: { self.cesta.toggle(); self.login.toggle() }, label: {
                            Text("Inicia sesión aquí")
                                .font(.title)
                                .frame(alignment: .center)
                                .foregroundColor(.yellow)
                        })
                        
                        Group{
                            EspacioGrande()
                            EspacioGrande()
                            EspacioGrande()
                            EspacioGrande()
                            EspacioGrande()
                            EspacioGrande()
                        }
                    }
                    
                    Spacer()
                    
                    // MENÚ INFERIOR DE NAVEGACIÓN
                    NavMenu(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario)
                    
                } // Fin CONTENIDO
                .fullScreenCover(isPresented: self.$menu){
                    MenuCabecera(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData)
                }
            } // Fin NavigationView
            .navigationBarHidden(true)
        }
    }

    struct Favoritos_Previews: PreviewProvider {
        static var prendas = PrendasModelData().prendas
        static var usuario = Usuario()
        static var previews: some View {
            Favoritos(login: Binding.constant(false), perfil: Binding.constant(false),favoritos: Binding.constant(true), cesta: Binding.constant(false), asistente: Binding.constant(false), usuario: usuario, prendasModelData: PrendasModelData())
        }
    }
}

