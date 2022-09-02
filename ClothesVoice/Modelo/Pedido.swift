//
//  Pedido.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 12/9/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import SwiftUI

/*
 Clase para cada pedido, sigue los protocolos ObservableObject y Identifiable
 */
final class Pedido: ObservableObject, Identifiable{
    
    internal var id: String // internal para satisfacer el protocolo Identifiable
    private var email: String
    private var precio: Int
    private var completado: Bool
    private var fecha: String
    
    // Constructor
    init(id:String?, email:String?, precio:Int?, fecha:String?) {
        self.id = id ?? ""
        self.email = email ?? ""
        self.precio = precio ?? -1
        self.completado = false
        self.fecha = fecha ?? ""
    }
    
    // Funciones del ID
    func consultarID() -> String{
        return self.id
    }
    
    // Funciones del email
    func consultarEmail() -> String{
        return self.email
    }
    
    // Funciones del precio
    func consultarPrecio() -> Int{
        return self.precio
    }
    
    func nuevoPrecio(precio:Int){
        self.precio = precio
    }
    
    // Funciones de completado
    func estaCompletado() -> Bool{
        return self.completado
    }
    
    func completar(){
        self.completado = true
    }
    
    // Funciones de la fecha
    func consultarFecha() -> String{
        return self.fecha
    }
    
    func actualizarFecha(fecha:String){
        self.fecha = fecha
    }
    
}
