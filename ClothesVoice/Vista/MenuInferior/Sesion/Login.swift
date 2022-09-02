//
//  Login.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 27/3/21.
//
/*
En esta vista se muestra el formulario típico de inicio de sesión para un usuario, si el usuario no recuerda sus claves o no está registrado dispone de los enlaces para llevar a cabo dichas acciones.
*/

import SwiftUI

struct Login: View {
   
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
    @State private var email_login: String = ""
    @State private var contrasena_login: String = ""
    @State private var falloAutenticacion: Bool = false
    @State private var exitoAutenticacion: Bool = false
    @State private var menu = false
    
    private let colorBoton = Color(red: 113/255.0, green: 200/255.0, blue: 86/255.0, opacity: 1.0)
    @AppStorage("estado") var estado = false

    var body: some View{
          
        if self.usuario.estado{
            Perfil(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData, registroPedidosModelData: self.registroPedidosModelData)
        }
        
        else{
            ZStack{
                
                Image("fondo_inicio")
                    .ignoresSafeArea()
                
                // CONTENIDO
                VStack{
                    
                    EspacioGrande()
                    Spacer()
                    
                    // MENÚ SUPERIOR DESPLEGABLE
                    Button(action: {self.menu = true}, label: {
                        Image("SCARS")
                    })
                    .padding(.bottom, 50.0)

                    VStack(spacing: 20){
                        Spacer()
                        Text("Inicio de Sesión")
                            .font(.custom("Roboto-MediumItalic", size: 30))
                            .foregroundColor(Color.white)
                            .padding(.vertical, 20.0)
                        EspacioMedio()
                        // Campo EMAIL
                        CustomTextField(imagen: "person", placeHolder: "Email", txt: self.$usuario.email, pass: false)
                        // Campo CONTRASEÑA
                        CustomTextField(imagen: "lock", placeHolder: "Contraseña", txt: self.$usuario.clave, pass: true)
                    }
                    
                    /* BOTÓN INICIO DE SESIÓN */
                    Button(action: {
                        self.usuario.Identificarse()
                        }, label: {
                        Text("Iniciar sesión")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(self.colorBoton)
                            .cornerRadius(15.0)
                    })
                    .padding(.vertical, 50.0)
                    .padding(.horizontal, 100.0)

                    /* BOTÓN RECUPERACIÓN CLAVES */
                    Button(action: {self.usuario.resetearClave()}, label: {
                        Text("¿Has olvidado tu contraseña?")
                            .font(.headline)
                            .foregroundColor(Color.red)
                    })
                    .padding(.leading, 55.0)
                    .frame(width: 350, height: 100, alignment: .leading)

                    /* BOTÓN REGISTRO */
                    Button(action: {self.usuario.estaRegistrado.toggle()}, label: {
                        Text("¿Aún no tienes cuenta? Regístrate")
                            .font(.headline)
                            .foregroundColor(Color.white)
                    })
                    .padding(.bottom, 30.0)
                    .padding(.leading, 10.0)
                    .listRowBackground(Color.black)
                    .frame(width: 300, height: 20, alignment: .leading)
                    
                    // MENÚ INFERIOR DE NAVEGACIÓN
                    NavMenu(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario)
                    
                } // FIN CONTENIDO
                
                if self.usuario.cargando{
                    VistaCargando().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: self.$usuario.estaRegistrado){
                Registro(usuario: self.usuario)
            }
            .alert(isPresented: self.$usuario.linkEnviado, content: {
                Alert(title: Text("El email de reseteo de contraseña ha sido enviado"), message: Text(self.usuario.mensajeAlerta), dismissButton: .destructive(Text("OK")))
            
            })
            .fullScreenCover(isPresented: self.$menu){
                MenuCabecera(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData)
            }
           //.offset(y: -presentacionTeclado.currentHeight*0.9)
            .alert(isPresented: self.$usuario.alerta, content: {
                Alert(title: Text("Notificación"), message: Text(self.usuario.mensajeAlerta), dismissButton: .destructive(Text("OK")))
            })
        }
        
    }

    struct Login_Previews: PreviewProvider {
        static var usuario = Usuario()
        static var previews: some View {
            Group {
                Login(login: Binding.constant(true), perfil: Binding.constant(false), favoritos: Binding.constant(false), cesta: Binding.constant(false), asistente: Binding.constant(false), usuario: usuario, prendasModelData: PrendasModelData(), registroPedidosModelData: RegistroPedidosModelData())
            }
        }
    }
}

struct CustomTextField: View{
    
    var imagen: String
    var placeHolder: String
    @Binding var txt: String
    var pass: Bool
    
    var body: some View{
        
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
            
            Image(systemName: self.imagen)
                .font(.system(size: 24))
                .foregroundColor(Color.black)
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Circle())
            
            if !self.pass{
                TextField(self.placeHolder, text: self.$txt)
                    .padding(.horizontal)
                    .padding(.leading,65)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(Color.white.opacity(0.4))
                    .clipShape(Capsule())
            }
            else{
                SecureField(self.placeHolder, text: self.$txt)
                    .padding(.horizontal)
                    .padding(.leading,65)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(Color.white.opacity(0.4))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal)
    }
}

struct VistaCargando: View {
 
  @State private var currentIndex: Int = 5

  func decrementIndex() {
    self.currentIndex -= 1
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
      self.decrementIndex()
    })
  }

  var body: some View {
    GeometryReader { (geometry: GeometryProxy) in
      ForEach(0..<12) { index in
        Group {
          Rectangle()
            .cornerRadius(geometry.size.width / 5)
            .frame(width: geometry.size.width / 8, height: geometry.size.height / 3)
            .offset(y: geometry.size.width / 2.25)
            .rotationEffect(.degrees(Double(-360 * index / 12)))
            .opacity(self.setOpacity(for: index))
        }.frame(width: geometry.size.width, height: geometry.size.height)
      }
    }
    .aspectRatio(1, contentMode: .fit)
    .onAppear {
      self.decrementIndex()
    }
  }

  func setOpacity(for index: Int) -> Double {
    let opacityOffset = Double((index + self.currentIndex - 1) % 11 ) / 12 * 0.9
    return 0.1 + opacityOffset
  }
}
