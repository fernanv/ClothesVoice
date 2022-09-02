//
//  Perfil.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 14/5/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import SwiftUI

struct Perfil: View {
       
    // Atributos compartidos por otras vistas
    @Binding var login: Bool
    @Binding var perfil: Bool
    @Binding var favoritos: Bool
    @Binding var cesta: Bool
    @Binding var asistente: Bool
    @ObservedObject var usuario : Usuario
    @ObservedObject var prendasModelData : PrendasModelData
    @ObservedObject var registroPedidosModelData : RegistroPedidosModelData
    
    // Atributos privados de la vista
    @State private var mostrarPedidos = false
    @State private var menu = false

    private let colorBoton1 = Color(red: 181/255.0, green: 112/255.0, blue: 97/255.0, opacity: 1.0)
    private let colorBoton2 = Color(red: 223/255.0, green: 105/255.0, blue: 80/255.0, opacity: 1.0)
    
    var body: some View {
            
        ZStack{
            
            Image("fondo_inicio")
                .ignoresSafeArea()
            
            // CONTENIDO
            VStack{

                EspacioGrande()
                
                Group{
                    // MENÚ SUPERIOR DESPLEGABLE
                    Button(action: {self.menu.toggle()}, label: {
                        Image("SCARS")
                    })
                    .padding(.bottom, 6.0)

                    Spacer()
                }
                
                Group{
                    EspacioGrande()
                    EspacioGrande()
                    EspacioGrande()
                }
                
                Group{
                    Text("Bienvenido/a")
                        .padding(.vertical, 10.0)
                    Text("\(self.usuario.nombre) \(self.usuario.apellidos)")
                    EspacioGrande()
                    EspacioGrande()
                }
                .font(.custom("Roboto-MediumItalic", size: 20))
                //.fontWeight(.semibold)
                .foregroundColor(Color.white)
                .onAppear(){
                    self.usuario.obtenerDatos()
                }
    
                Group{
                    EspacioGrande()
                    
                    /* BOTÓN CONSULTAR PEDIDOS */
                    Button(action: {
                        self.mostrarPedidos = true
                        }, label: {
                        Text("Consultar pedidos")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(self.colorBoton2)
                            .cornerRadius(15.0)
                    })
                    .padding(.vertical, 30.0)
                    .padding(.horizontal, 100.0)
                    
                    Spacer()
                    
                    /* BOTÓN CERRAR SESIÓN */
                    Button(action: {
                        self.cerrarSesion()
                        }, label: {
                        Text("Cerrar sesión")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(self.colorBoton1)
                            .cornerRadius(15.0)
                    })
                    .padding(.vertical, 30.0)
                    .padding(.horizontal, 100.0)
                    
                    Spacer()
                    
                    /* BOTÓN CERRAR SESIÓN */
                    Button(action: {
                        self.eliminarCuenta()
                        }, label: {
                        Text("Eliminar mi cuenta")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.red)
                            .cornerRadius(15.0)
                    })
                    .padding(.vertical, 30.0)
                    .padding(.horizontal, 100.0)
                }
                
                Group{
                    EspacioPeque()
                }
                
                // MENÚ INFERIOR DE NAVEGACIÓN
                NavMenu(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario)
                
            } // FIN CONTENIDO
            .fullScreenCover(isPresented: self.$menu){
                MenuCabecera(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData)
            }
            
            if self.usuario.cargando{
                VistaCargando().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
        .popover(isPresented: self.$mostrarPedidos) {
            Pedidos(registroPedidos: self.registroPedidosModelData, usuario: self.usuario)
        }
    }
    
    func cerrarSesion(){
        self.login = true
        self.usuario.cerrarSesion()
    }
    
    func eliminarCuenta(){
        self.login = true
        self.usuario.eliminarCuenta()
    }

    struct Perfil_Previews: PreviewProvider {
        static var usuario = Usuario()
        static var previews: some View {
            Group {
                Perfil(login: Binding.constant(true), perfil: Binding.constant(false), favoritos: Binding.constant(false), cesta: Binding.constant(false), asistente: Binding.constant(false), usuario: self.usuario, prendasModelData: PrendasModelData(), registroPedidosModelData: RegistroPedidosModelData())
            }
        }
    }
}

