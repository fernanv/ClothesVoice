//
//  Usuario.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 5/5/21.
//

import Firebase
import SwiftUI
import CryptoKit

final class Usuario: ObservableObject, Identifiable{
    
    internal var id: String = "-1"
    @Published var email: String = ""
    @Published var emailRegistro: String = ""
    @Published var claveRegistro: String = ""
    @Published var claveRepetida: String = ""
    @Published var clave: String = "" // Contraseña
    @Published var nombre: String = ""
    @Published var apellidos: String = ""
    @Published var estaRegistrado: Bool = false
    @Published var emailResetear: String = ""
    @Published var linkEnviado: Bool = false
    @Published var cargando: Bool = false
    
    // Alertas de Error
    @Published var alerta = false
    @Published var mensajeAlerta = ""
    
    // Estado del usuario
    @AppStorage("estado") var estado = false
    @AppStorage("reseteada") var reseteada = false
    
    private var db = Firestore.firestore()
    private let usuario = Auth.auth().currentUser
    
    func Identificarse(){
        // Comprobación de errores en los inputs
        if self.email == "" || self.clave == ""{
            self.mensajeAlerta = "Por favor, rellene los campos"
            self.alerta.toggle()
            return
        }
        
        withAnimation{
            self.cargando = true
        }
        
        //Encryptamos la contraseña
        let inputData = Data(self.clave.utf8)
        let hashed :String
        
        if !self.reseteada{
            hashed = SHA256.hash(data: inputData).description
        }
        else{
            hashed = self.clave
        }
        
        Auth.auth().signIn(withEmail: self.email, password: hashed) { (resultado, error) in
            
            if error != nil{
                withAnimation{
                    self.cargando = false
                }
                self.mensajeAlerta = error!.localizedDescription
                self.alerta.toggle()
                return
            }
            
            // Comprobación de si el usuario está verificado
            // si no está verificado se cierra la sesión
            
            if !(self.usuario?.isEmailVerified ?? true){
                withAnimation{
                    self.cargando = false
                }
                self.mensajeAlerta = "Por favor, comprueba tu correo"
                self.alerta.toggle()
                // Cerrar la sesión
                try! Auth.auth().signOut()
                return
            }
            
            self.obtenerDatos()
            
            withAnimation{
                self.cargando = false
            }
            
            // Cambiamos el estado del usuario a true
            withAnimation{
                self.estado = true
            }
            
        }
    }
    
    func Registrarse(){
        // Comprobación de errores en los inputs
        if self.emailRegistro == "" || self.claveRegistro == "" || self.claveRepetida == "" || self.nombre == "" || self.apellidos == ""{
            self.mensajeAlerta = "Por favor, rellene los campos"
            self.alerta.toggle()
            return
        }
        
        if self.claveRegistro != self.claveRepetida{
            self.mensajeAlerta = "La contraseña no coincide con la de arriba"
            self.alerta.toggle()
            return
        }
  
        withAnimation{
            self.cargando = true
        }

        //Encryptamos la contraseña
        let inputData = Data(self.claveRegistro.utf8)
        let hashed = SHA256.hash(data: inputData).description
        
        Auth.auth().createUser(withEmail: self.emailRegistro, password: hashed) { [self] (resultado, error) in
            
            if error != nil{
                withAnimation{
                    self.cargando = false
                }
                self.mensajeAlerta = error!.localizedDescription
                self.alerta.toggle()
                return
            }
            
            self.db.collection("usuarios").addDocument(data: ["apellidos": apellidos, "id_usuario": Auth.auth().currentUser!.uid as String, "nombre": nombre]){ err in
                if let err = err {
                     print("Error añadiendo el documento de usuarios: \(err)")
                } else {
                    print("documento de usuarios añadido correctamente")
                 }
            }
            
            // Enviar el Link de Verificación
            resultado?.user.sendEmailVerification(completion: { (error) in
                if error != nil{
                    withAnimation{
                        self.cargando = false
                    }
                    self.mensajeAlerta = error!.localizedDescription
                    self.alerta.toggle()
                    return
                }
            })
            
            // Avisar al usuario para que compruebe el correo
            self.mensajeAlerta = "El correo de verificación de su cuenta ha sido enviado"
            self.alerta.toggle()
            
            withAnimation{
                self.cargando = false
            }
        }
    }
    
    func cerrarSesion(){
        // Cerrar la sesión
        try! Auth.auth().signOut()
        
        withAnimation{
            self.cargando = true
        }
        
        withAnimation{
            self.estado = false
        }
        
        // Limpiando los datos
        self.id = ""
        self.email = ""
        self.clave = ""
        self.emailRegistro = ""
        self.claveRegistro = ""
        self.claveRepetida = ""
        self.nombre = ""
        self.apellidos = ""
        
        withAnimation{
            self.cargando = false
        }
    }
    
    func eliminarCuenta(){
        
        let alerta = UIAlertController(title: "Eliminar cuenta", message: "Se eliminarán todos sus datos definitivamente", preferredStyle: .alert)
        
        let seguir = UIAlertAction(title: "Eliminar", style: .default) { _ in

            print(Auth.auth().currentUser?.email! ?? "SIN_ACCESO")
            self.db.collection("usuarios")
                .whereField("id_usuario", isEqualTo: self.id)
                .addSnapshotListener{
                (querySnapshot, error) in
                 guard let documentosUsuarios = querySnapshot?.documents else{
                     print("No hay documentos de usuarios")
                     return
                 }
                
                for queryDocumentSnapshot in documentosUsuarios{
                    self.db.collection("usuarios").document("\(queryDocumentSnapshot.documentID)").delete(){ err in
                        if let err = err {
                             print("Error eliminando el documento de usuarios: \(err)")
                        } else {
                            print("documento de usuarios eliminado")
                         }
                     }
                 }
             }
            
            self.db.collection("favoritos_cesta")
                .whereField("id_usuario", isEqualTo: self.id)
                .addSnapshotListener{
                (querySnapshot1, error1) in
                 guard let documentosFavoritosCesta = querySnapshot1?.documents else{
                     print("No hay documentos de favoritos_cesta")
                     return
                 }
                
                for queryDocumentSnapshot1 in documentosFavoritosCesta{
                    self.db.collection("favoritos_cesta").document("\(queryDocumentSnapshot1.documentID)").delete(){ err in
                        if let err = err {
                             print("Error eliminando el documento de favoritos_cesta: \(err)")
                        } else {
                            print("documento de favoritos_cesta eliminado")
                         }
                     }
                 }
             }
            
            self.db.collection("pedido")
                .whereField("email", isEqualTo: Auth.auth().currentUser?.email! ?? "SIN_ACCESO")
                .addSnapshotListener{
                (querySnapshot2, error2) in
                 guard let documentosPedido = querySnapshot2?.documents else{
                     print("No hay documentos de pedido")
                     return
                 }
                
                for queryDocumentSnapshot2 in documentosPedido{
                    self.db.collection("pedido").document("\(queryDocumentSnapshot2.documentID)").delete(){ err in
                        if let err = err {
                             print("Error eliminando el documento de pedido: \(err)")
                        } else {
                            
                            let idPedido = queryDocumentSnapshot2.data()["id_pedido"] as? String ?? "-1"
                            
                            print("documento de pedido eliminado")
                            
                            self.db.collection("item_pedido")
                                .whereField("id_pedido", isEqualTo: idPedido)
                                .addSnapshotListener{
                                (querySnapshot3, error2) in
                                 guard let documentosItems = querySnapshot3?.documents else{
                                     print("No hay documentos de item_pedido")
                                     return
                                 }
                                
                                for queryDocumentSnapshot3 in documentosItems{
                                    self.db.collection("item_pedido").document("\(queryDocumentSnapshot3.documentID)").delete(){ err in
                                        if let err = err {
                                             print("Error eliminando el documento de item_pedido: \(err)")
                                        } else {
                                            print("documento de item_pedido eliminado")
                                         }
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
            
            // Eliminar usuario
            Auth.auth().currentUser!.delete(){
                (error) in
                print(error ?? "Error al eliminar el usuario")
                return
            }
            
            withAnimation{
                self.cargando = true
            }
            
            withAnimation{
                self.estado = false
            }
            
            // Limpiando los datos
            self.id = ""
            self.email = ""
            self.clave = ""
            self.emailRegistro = ""
            self.claveRegistro = ""
            self.claveRepetida = ""
            self.nombre = ""
            self.apellidos = ""
            
            withAnimation{
                self.cargando = false
            }
        }
        
        withAnimation{
            self.cargando = false
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        alerta.addAction(cancelar)
        alerta.addAction(seguir)
        
        // Presentación
        UIApplication.shared.windows.first?.rootViewController?.present(alerta, animated: true)
    }
    
    func resetearClave(){
        
        let alerta = UIAlertController(title: "Resetear contraseña", message: "Introduce tu email para resetear tu contraseña", preferredStyle: .alert)
        
        alerta.addTextField{ (pass) in
            pass.placeholder = "Email"
        }
        
        let seguir = UIAlertAction(title: "Resetear", style: .default) { (_) in
            
            // Enviar link de reseteo de la contraseña
            if alerta.textFields![0].text! != ""{
                
                withAnimation{
                    self.cargando = true
                }
                
                Auth.auth().sendPasswordReset(withEmail: alerta.textFields![0].text!){
                    (error) in
                    
                    if error != nil{
                        withAnimation{
                            self.cargando = false
                        }
                        self.mensajeAlerta = error!.localizedDescription
                        self.alerta.toggle()
                        return
                    }
                    
                    // Avisar al usuario para que compruebe el correo
                    self.mensajeAlerta = "El correo de reseteo de la contraseña ha sido enviado"
                    self.alerta.toggle()
                    
                    withAnimation{
                        self.cargando = false
                        self.reseteada = true
                    }
                }
            }
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        alerta.addAction(cancelar)
        alerta.addAction(seguir)
        
        // Presentación
        UIApplication.shared.windows.first?.rootViewController?.present(alerta, animated: true)
    }
    
    func obtenerDatos(){
        self.db.collection("usuarios").addSnapshotListener{
            (querySnapshot, error) in
             guard let documentosUsuarios = querySnapshot?.documents else{
                 print("No hay documentos de usuarios")
                 return
             }
            
            for queryDocumentSnapshot in documentosUsuarios{
                let datos = queryDocumentSnapshot.data()
                if (Auth.auth().currentUser?.uid) == datos["id_usuario"] as? String{
                     self.id = datos["id_usuario"] as? String ?? "-1"
                     self.nombre = datos["nombre"] as? String ?? ""
                     self.apellidos = datos["apellidos"] as? String ?? ""
                     self.email = datos["email"] as? String ?? ""
                 }
             }
         }
    }
    

}
