//
//  NavMenu.swift
//  ClothesVoice
//
//  Esta vista presenta el menu de navegación entre las diferentes secciones de la App.
//
//  Created by Fernando Villalba  on 24/3/21.
//

import SwiftUI

struct NavMenu: View {
    
    // Atributos compartidos por otras vistas
    @Binding var login: Bool
    @Binding var perfil: Bool
    @Binding var favoritos: Bool
    @Binding var cesta: Bool
    @Binding var asistente: Bool
    @ObservedObject var usuario : Usuario
    
    // Atributos privados de la vista
    private let colorMenu = Color(red: 107/255.0, green: 103/255.0, blue: 103/255.0, opacity: 0.4)
    
    var body: some View{
        
        HStack(alignment: .bottom, spacing: 10.0){
            
            Spacer()
            
            /* PERFIL-INICIO DE SESIÓN */
            if self.usuario.estado{
                Button(action: { self.vistaPerfil() }, label: {
                    VStack{
                        Image(systemName: "person.circle.fill").imageScale(.large)
                        Text("Perfil")
                            .font(.body)
                    }
                })
                .padding(.all, 1.5)
                .foregroundColor(Color.white)
                Spacer()
            }
            else{
                Button(action: { self.vistaLogin() }, label: {
                    VStack{
                        Image(systemName: "person").imageScale(.large)
                        Text("Perfil")
                            .font(.body)
                    }
                })
                .padding(.all, 1.5)
                .foregroundColor(Color.white)
                Spacer()
            }
        
            /* PROBADOR - REALIDAD AUMENTADA */
            /*Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                VStack{
                    Image("clothes-icon")
                        .resizable()
                        .frame(width: 25, height: 15)
                    Text("Probador")
                        .font(.body)
                }
            })
            .padding(.all, 1.5)
            .foregroundColor(Color.white)*/

            /* ASISTENTE VIRTUAL */
            Button(action: { self.Asistente() }, label: {
                VStack{
                    Image(systemName: "mic.fill").imageScale(.large)
                    Text("Asistente")
                        .font(.body)
                }
            })
            .padding(.all, 1.5)
            .foregroundColor(Color.white)
            Spacer()
            
            /* PRENDAS FAVORITAS */
            Button(action: { self.Favoritos() }, label: {
                VStack{
                    Image(systemName: "heart.fill").imageScale(.large)
                    Text("Favoritos")
                        .font(.body)
                }
            })
            .padding(.all, 1.5)
            .foregroundColor(Color.white)
            Spacer()
            
            /* CESTA DE COMPRA */
            Button(action: { self.Cesta() }, label: {
                VStack{
                    Image(systemName: "cart.fill").imageScale(.large)
                    Text("Cesta")
                        .font(.body)
                }
            })
            .padding(.all, 1.5)
            .foregroundColor(Color.white)
            
            Spacer()
        }
        .padding(.top, 10.0)
        .padding(.bottom, 40.0)
        .background(self.colorMenu)
        .frame(width: 430)
        
    }
    
    func vistaLogin(){
        
        self.favoritos = false
        self.cesta = false
        self.perfil = false
        self.asistente = false
        
        if !self.login{
            self.login.toggle()
        }
    }
    
    func vistaPerfil(){
        
        self.favoritos = false
        self.cesta = false
        self.login = false
        self.asistente = false
        
        if !self.perfil{
            self.perfil.toggle()
        }
    }
    
    func Favoritos(){

        self.login = false
        self.cesta = false
        self.perfil = false
        self.asistente = false
        
        if !self.favoritos{
            self.favoritos.toggle()
        }
    }
    
    func Cesta(){

        self.login = false
        self.favoritos = false
        self.perfil = false
        self.asistente = false
        
        if !self.cesta{
            self.cesta.toggle()
        }
    }
    
    func Asistente(){

        self.login = false
        self.favoritos = false
        self.perfil = false
        self.cesta = false
        
        if !self.asistente{
            self.asistente.toggle()
        }
    }
    
    struct NavMenu_Previews:
        PreviewProvider {
        static var usuario = Usuario()
        static var previews: some View {
            NavMenu(login: Binding.constant(false), perfil: Binding.constant(false), favoritos: Binding.constant(false), cesta: Binding.constant(false), asistente: Binding.constant(false), usuario: usuario)
        }
    }
}
