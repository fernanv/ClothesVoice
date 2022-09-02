//
//  ContentView.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 8/3/21.
//

import SwiftUI

struct VistaInicio: View {
    
    // Atributos que son creados en esta vista y compartidos con otras vistas
    @State private var tutorial = true
    @State private var login = false
    @State private var perfil = false
    @State private var asistente = false
    @State private var favoritos = false
    @State private var cesta = false
    @ObservedObject private var prendasModelData = PrendasModelData()
    @ObservedObject private var pedidoModelData = PedidoModelData()
    @ObservedObject private var registroPedidosModelData = RegistroPedidosModelData()
    @ObservedObject private var usuario = Usuario()
    
    var body: some View {
         return Group{
            
            if self.tutorial && !UserDefaults.standard.bool(forKey: "tutorial"){
            //if self.tutorial{
                Tutorial(tutorial: self.$tutorial)
            }
            
            else{
                
                if self.login{
                    Login(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData, registroPedidosModelData: self.registroPedidosModelData)
                 }
                 
                else if self.perfil{
                    Perfil(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData, registroPedidosModelData: self.registroPedidosModelData)
                 }
                 
                else if self.asistente{
                    Asistente(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta,asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData)
                        .popover(isPresented: self.$prendasModelData.valores.disponible, content: {
                            PrendasFiltradas(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos,cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData)
                        })
                 }
                 
                else if self.favoritos{
                    Favoritos(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData)
                 }
                 
                else if self.cesta{
                    Cesta(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos,cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData, pedidoModelData: self.pedidoModelData)
                 }
                 
                 else{
                    Inicio(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData)
                 }
            }
         }
    }

}

struct VistaInicio_Previews: PreviewProvider {
    static var previews: some View {
        VistaInicio()
    }
}
