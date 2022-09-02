//
//  Registro.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 19/4/21.
//

import SwiftUI

struct Registro: View {
    
    // Atributos compartidos por otras vistas
    @ObservedObject var usuario : Usuario
    
    // Atributos privados de la vista
    @Environment(\.presentationMode) private var presentation
    
    private let colorFormulario = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    private let colorBoton = Color(red: 113/255.0, green: 200/255.0, blue: 86/255.0, opacity: 1.0)
    private let colorFondo = Color(red: 107/255.0, green: 103/255.0, blue: 103/255.0, opacity: 0.0)
    
    var body: some View {
            
        ZStack{
            
            Image("fondo_inicio").ignoresSafeArea()
            
            // CONTENIDO
            VStack{
                
                EspacioGrande()
                
                Button(action: {self.presentation
                        .wrappedValue
                        .dismiss()},
                       label: {
                            Image(systemName: "arrowshape.turn.up.backward.circle").resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                })
                .foregroundColor(.gray)
                .padding(.trailing, 300.0)
                .padding(.top, 50.0)

                EspacioMedio()
                    
                VStack(spacing: 20){
                    
                    Text("Registro")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 20.0)
                    
                    Spacer()
                    
                    // Campo EMAIL
                    CustomTextField(imagen: "person", placeHolder: "Email", txt: self.$usuario.emailRegistro, pass: false)
                    
                    // Campo CONTRASEÑA
                    CustomTextField(imagen: "lock", placeHolder: "Contraseña", txt: self.$usuario.claveRegistro, pass: true)
                    
                    // Campo REPETIR CONTRASEÑA
                    CustomTextField(imagen: "lock", placeHolder: "Repetir contraseña", txt: self.$usuario.claveRepetida, pass: true)
                   
                    // Campo NOMBRE
                    CustomTextField(imagen: "person", placeHolder: "Nombre", txt: self.$usuario.nombre, pass: false)
                    
                    // Campo APELLIDOS
                    CustomTextField(imagen: "person", placeHolder: "Apellidos", txt: self.$usuario.apellidos, pass: false)
                    
                    Spacer()
                }
                
                /* BOTÓN DE REGISTRO */
                Button(action: {
                    self.usuario.Registrarse()
                    }, label: {
                    Text("Continuar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(self.colorBoton)
                        .cornerRadius(15.0)
                })
                .padding(.vertical)
                .padding(.horizontal, 100.0)

               EspacioMedio()
            } // FIN CONTENIDO
            
            if self.usuario.cargando{
                VistaCargando().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
        .navigationBarHidden(true)
        .padding(.all)
        .alert(isPresented: self.$usuario.alerta, content: {
            Alert(title: Text("Notificación"), message: Text(self.usuario.mensajeAlerta), dismissButton: .destructive(Text("OK"), action: {
                // si se ha enviado el email de verificación se cierra la vista de Registro
                if self.usuario.mensajeAlerta == "El correo de verificación de su cuenta ha sido enviado"{
                    self.usuario.estaRegistrado.toggle()
                    self.usuario.emailRegistro = ""
                    self.usuario.claveRegistro = ""
                    self.usuario.claveRepetida = ""
                }
            }))
        })
    }
    
    struct Registro_Previews: PreviewProvider {
        static var usuario = Usuario()
        static var previews: some View {
            Registro(usuario: self.usuario)
        }
    }
}
