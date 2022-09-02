//
//  PedidosModeloVista.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 12/9/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import FirebaseFirestore
import Firebase
import Combine

final class PedidoModelData: ObservableObject{
    
    private var db = Firestore.firestore()
    @Published var pedido : Pedido
    @Published var itemsPedido = [ItemPedido]()
    let emailUsuario = Auth.auth().currentUser?.email
    private let idPedido = UUID().uuidString // Garantiza un ID único en todos los dispositivos del mundo
    
    init() {
        let fecha = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let fechaString = formatter.string(from: fecha)
        self.pedido = Pedido(id: self.idPedido, email: self.emailUsuario, precio: nil, fecha: fechaString)
    }

    var tamPedido: Int{
        var cantidad = 0
        for item in self.itemsPedido{
            cantidad += item.consultarCantidad()
        }
        return cantidad
    }
    
    func Crear(items: [Prenda]){
        
        var precioTotal = 0
        
        for itemCesta in items{
            
            let idItem = UUID().uuidString
            let precioItem = itemCesta.consultarPrecio() * itemCesta.consultarCantidad()

            self.db.collection("item_pedido").addDocument(data: ["id_item": idItem, "id_pedido": self.idPedido, "nombre": itemCesta.consultarNombre(), "cantidad": itemCesta.consultarCantidad(), "precio": precioItem, "foto": itemCesta.consultarFoto(indice: 0), "talla": itemCesta.consultarTallaCesta() ]){ err in
                if let err = err {
                     print("Error añadiendo el documento de item_pedido: \(err)")
                } else {
                    print("documento de item_pedido añadido correctamente")
                 }
            }
            
            precioTotal += precioItem
        }
        
        self.db.collection("item_pedido")
            .whereField("id_pedido", isEqualTo: self.idPedido)
            .addSnapshotListener{ [self] (querySnapshot, error) in
             guard let documentos_items = querySnapshot?.documents else{
                 print("No hay documentos de item_pedido")
                 return
             }
                    
             self.itemsPedido = documentos_items.map{ (queryDocumentSnapshot) in
            
                let datos = queryDocumentSnapshot.data()
                 
                let id_item = datos["id_item"] as? String ?? ""
                let nombre = datos["nombre"] as? String ?? ""
                let precio = datos["precio"] as? Int ?? -1
                let cantidad = datos["cantidad"] as? Int ?? -1
                let talla_datos = datos["talla"] as? String ?? ""
                let talla = ItemPedido.TallaPrenda.init(rawValue: talla_datos)
                let nombreFoto = datos["foto"] as? String ?? ""
                
                return ItemPedido(idItem: id_item, idPedido: self.idPedido, precio: precio, nombre: nombre, talla: talla ?? ItemPedido.TallaPrenda.NoSeleccionada, cantidad: cantidad, nombreFoto: nombreFoto)
            }
        }
        
        self.pedido.nuevoPrecio(precio: precioTotal)
        let fecha = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let fechaString = formatter.string(from: fecha)
        self.pedido.actualizarFecha(fecha: fechaString)
        
        self.db.collection("pedido").addDocument(data: ["id_pedido": self.idPedido, "completado": false, "email": self.emailUsuario ?? "SIN_ACCESO", "fecha": fechaString, "precio": precioTotal]){ err in
            if let err = err{
                 print("Error añadiendo el documento de pedido: \(err)")
            }
            else{
                print("documento de pedido añadido correctamente")
            }
        }
    }
    
    func Borrar(){
        
        self.db.collection("item_pedido")
            .whereField("id_pedido", isEqualTo: self.idPedido)
            .addSnapshotListener{ (querySnapshot3, error) in
            guard let documentos_items1 = querySnapshot3?.documents else{
                print("No hay documentos de item_pedido")
                return
            }
        
            for queryDocumentSnapshot3 in documentos_items1{
                self.db.collection("item_pedido").document("\(queryDocumentSnapshot3.documentID)").delete(){ err in
                    if let err = err{
                         print("Error eliminando el documento de item_pedido: \(err)")
                    }
                    else{
                        print("documento de item_pedido eliminado")
                    }
                 }
             }
         }
        
        self.db.collection("pedido")
            .whereField("id_pedido", isEqualTo: self.idPedido)
            .addSnapshotListener{ (querySnapshot1, error) in
            guard let documentos_pedido1 = querySnapshot1?.documents else{
                print("No hay documentos de pedido")
                return
            }
        
            for queryDocumentSnapshot1 in documentos_pedido1{
                self.db.collection("pedido").document("\(queryDocumentSnapshot1.documentID)").delete(){ err in
                    if let err = err{
                         print("Error eliminando el documento de pedido: \(err)")
                    }
                    else{
                        print("documento de pedido eliminado")
                    }
                 }
             }
         }
    }
    
    func completarPedido(){
        self.db.collection("pedido")
            .whereField("id_pedido", isEqualTo: self.idPedido)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print(err)
                } else {
                    let document = querySnapshot!.documents.first
                    document?.reference.updateData([
                        "completado": true
                    ])
                }
            }
        self.pedido.completar()
    }
   
}
