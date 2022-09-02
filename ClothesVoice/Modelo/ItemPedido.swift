//
//  ItemPedido.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 12/9/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import SwiftUI

/*
 Clase para cada pedido, sigue los protocolos ObservableObject y Identifiable
 */
final class ItemPedido: ObservableObject, Identifiable{
    
    internal var idItem: String // internal para satisfacer el protocolo Identifiable
    private var idPedido: String
    private var precio: Int
    private var nombre: String
    private var talla: TallaPrenda
    private var cantidad: Int
    private var nombreFoto: String
    
    private var foto: Image{
        Image(self.nombreFoto)
    }
    
    public enum TallaPrenda: String, CaseIterable, Codable{
        case XS = "XS"
        case S = "S"
        case M = "M"
        case L = "L"
        case XL = "XL"
        case XXL = "XXL"
        case NoSeleccionada = ""
    }
    
    // Constructor
    init(idItem:String, idPedido:String, precio:Int, nombre:String, talla:TallaPrenda, cantidad:Int, nombreFoto:String) {
        self.idItem = idItem
        self.idPedido = idPedido
        self.precio = precio
        self.nombre = nombre
        self.talla = talla
        self.cantidad = cantidad
        self.nombreFoto = nombreFoto
    }
    
    // Funciones del ID del ítem
    func consultarIdItem() -> String{
        return self.idItem
    }
    
    // Funciones del ID del pedido
    func consultarIdPedido() -> String{
        return self.idPedido
    }
    
    // Funciones del precio
    func consultarPrecio() -> Int{
        return self.precio
    }
    
    // Funciones del nombre
    func consultarNombre() -> String{
        return self.nombre
    }
    
    // Funciones de la talla
    func consultarTalla() -> String{
        return self.talla.rawValue
    }
    
    // Funciones de la cantidad
    func consultarCantidad() -> Int{
        return self.cantidad
    }
    
    func aumentarCantidad(){
        self.cantidad += 1
    }
    
    func disminuirCantidad(){
        self.cantidad -= 1
    }
    
    // Funciones de la foto
    func consultarFoto() -> Image {
        return self.foto
    }
}

