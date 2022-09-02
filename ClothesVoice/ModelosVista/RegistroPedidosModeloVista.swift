//
//  RegistroPedidosModeloVista.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 19/9/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import FirebaseFirestore
import Firebase
import Combine

final class RegistroPedidosModelData: ObservableObject{
    
    private var db = Firestore.firestore()
    @Published var pedidos = [Pedido]()
    @Published var items = [ItemPedido]()
    
    init(){
        self.obtenerPedidos()
        self.obtenerItems()
    }
    
    func obtenerPedidos(){
        self.db.collection("pedido")
            .whereField("email", isEqualTo: Auth.auth().currentUser?.email! ?? "SIN_ACCESO")
            .whereField("completado", isEqualTo: true)
            .addSnapshotListener{ [self] (querySnapshot, error) in
             guard let documentos_pedidos = querySnapshot?.documents else{
                 print("No hay documentos de pedidos")
                 return
             }
        
            
             self.pedidos = documentos_pedidos.map{ (queryDocumentSnapshot2) in
                let datos = queryDocumentSnapshot2.data()
                
                let idPedido = datos["id_pedido"] as? String ?? "-1"
                let precio = datos["precio"] as? Int ?? -1
                let email = datos["email"] as? String ?? ""
                let fecha = datos["fecha"] as? String ?? ""
                
                return Pedido(id: idPedido, email: email, precio: precio+3, fecha: fecha)
            }
        }
    }
    
    func obtenerItems(){
        
        self.items.removeAll()
        
        for pedido in self.pedidos{
            
            self.db.collection("item_pedido")
                .whereField("id_pedido", isEqualTo: pedido.consultarID())
               .addSnapshotListener{ (querySnapshot1, error) in
                guard let documentos_items = querySnapshot1?.documents else{
                    print("No hay documentos de item_pedido")
                    return
                }

                for queryDocumentSnapshot1 in documentos_items{
           
                   let datos1 = queryDocumentSnapshot1.data()
                    
                   let id_item = datos1["id_item"] as? String ?? ""
                   let nombre = datos1["nombre"] as? String ?? ""
                   let precio = datos1["precio"] as? Int ?? -1
                   let cantidad = datos1["cantidad"] as? Int ?? -1
                   let talla_datos = datos1["talla"] as? String ?? ""
                   let talla = ItemPedido.TallaPrenda.init(rawValue: talla_datos)
                   let nombreFoto = datos1["foto"] as? String ?? ""
                   self.items.append( ItemPedido(idItem: id_item, idPedido: pedido.consultarID(), precio: precio, nombre: nombre, talla: talla ?? ItemPedido.TallaPrenda.NoSeleccionada, cantidad: cantidad, nombreFoto: nombreFoto) )
                   }
               
               }
        }
    }
    
}
