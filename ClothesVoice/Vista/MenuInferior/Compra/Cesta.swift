//
//  Cesta.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 12/4/21.
//
/*
En esta vista se muestran las prendas que han sido añadidas a la cesta para su posterior compra, con un botón para retirar cada una de la cesta y otro para realizar el proceso de pago.
*/

import SwiftUI

struct Cesta: View {
   
    // Atributos compartidos por otras vistas
    @Binding var login: Bool
    @Binding var perfil: Bool
    @Binding var favoritos: Bool
    @Binding var cesta: Bool
    @Binding var asistente: Bool
    @ObservedObject var usuario : Usuario
    @ObservedObject var prendasModelData : PrendasModelData
    @ObservedObject var pedidoModelData : PedidoModelData
    
    // Atributos privados de la vista
    @State private var menu = false
    @State private var pago: Bool = false
    
    private let colorBoton = Color(red: 113/255.0, green: 200/255.0, blue: 86/255.0, opacity: 1.0)
    
    var body: some View {
        
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

                    Text("Cesta de la compra")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .padding(.trailing, 200)
                    
                    if self.usuario.estado{
                            
                        Group{
                            
                            Text("\(self.prendasModelData.itemsCesta) artículos seleccionados")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color.white)
                                .padding(.top, 5)
                                .padding(.trailing, 200)
                        }
                        
                        EspacioPeque()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack{
                                ForEach(self.prendasModelData.prendas) {
                                    prenda in
                                    if prenda.estaEnCesta(){
                                        withAnimation{
                                            ElementoCategoria(prenda: prenda, deCesta: Binding.constant(true), prendasModelData: self.prendasModelData, usuario: self.usuario)
                                        }
                                    }
                                }
                                .onAppear(){
                                    self.prendasModelData.obtenerFavoritosCesta()
                                    self.usuario.obtenerDatos()
                                }
                            }
                            .padding(.vertical)
                        } // Fin ScrollView
                        
                        if self.prendasModelData.itemsCesta != 0{
                            Group{
                                /* BOTÓN PAGO */
                                Button(action: { self.pago.toggle() }, label: {
                                    Text("CONTINUAR")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(width: 170, height: 50)
                                        .background(self.colorBoton)
                                        .cornerRadius(50.0)
                                })
                                .padding(.all, 5)
                                .padding(.trailing, 10)
                                .foregroundColor(Color.white)
                                .disabled(self.prendasModelData.itemsCesta == 0)
                            }
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
                        
                        EspacioGrande()
                        EspacioGrande()
                        EspacioGrande()
                        EspacioGrande()
                        EspacioGrande()
                        EspacioGrande()
                    }
                    Spacer()
                    
                    // MENÚ INFERIOR DE NAVEGACIÓN
                    NavMenu(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario)
                    
                } // FIN CONTENIDO
                .fullScreenCover(isPresented: self.$menu){
                    MenuCabecera(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData)
                }
                .fullScreenCover(isPresented: self.$pago){
                    ResumenPedido(usuario: self.usuario, prendasModelData: self.prendasModelData, pedido: self.pedidoModelData)
                }
            }// Fin NavigationView
            .navigationBarHidden(true)
            
        }
    
    }

    struct Cesta_Previews: PreviewProvider {
        static var prendas = PrendasModelData().prendas
        static var usuario = Usuario()
        static var previews: some View {
            Cesta(login: Binding.constant(false), perfil: Binding.constant(false),favoritos: Binding.constant(false),cesta: Binding.constant(true), asistente: Binding.constant(false), usuario: self.usuario,
                  prendasModelData: PrendasModelData(), pedidoModelData: PedidoModelData())
        }
    }
}
