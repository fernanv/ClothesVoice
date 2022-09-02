//
//  Prenda.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 12/3/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SwiftUI

/*
 Clase para cada prenda de ropa, sigue los protocolos ObservableObject y Identifiable
 */
final class Prenda: ObservableObject, Identifiable{
    
    @Published internal var id: Int // internal para satisfacer el protocolo Identifiable
    private var precio: Int
    private var nombre: String
    private var color: String
    private var nombresFotos: Array<String> = Array(repeating: "", count: 4)
    private var descripcion: String = ""
    private var tallas: [(talla: TallaPrenda, cantidad: Int)]
    private var tallaCesta: TallaPrenda = TallaPrenda.NoSeleccionada
    private var categoria_sexo: CategoriaSexo
    private var categoria_ropa: CategoriaRopa
    private var cantidad: Int = 1
    @Published var enFavoritos: Bool
    @Published var enCesta: Bool
    
    private var fotoPrenda1: Image{
        Image(self.nombresFotos[0])
    }
    
    private var fotoPrenda2: Image{
        Image(self.nombresFotos[1])
    }
    
    private var fotoPrenda3: Image{
        Image(self.nombresFotos[2])
    }
    
    private var fotoPrenda4: Image{
        Image(self.nombresFotos[3])
    }
    
    enum CategoriaSexo: String, CaseIterable, Codable{
        case mujer = "Mujer"
        case hombre = "Hombre"
        case niños = "Niños"
        case unisex = "Unisex"
    }
    
    enum CategoriaRopa: String, CaseIterable, Codable{
        case camisetas = "Camisetas"
        case camisas = "Camisas"
        case sudaderas = "Sudaderas"
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
    init(id:Int, nombre:String?, descripcion:String, precio:Int, color:String, tallas:[(talla: TallaPrenda, cantidad: Int)], categoria_sexo:CategoriaSexo?, categoria_ropa:CategoriaRopa?, nombresFotos:Array<String>, enFavoritos:Bool?, enCesta:Bool?, tallaCesta:TallaPrenda?) {
        self.id = id
        self.nombre = nombre ?? "Prenda sin catalogar"
        self.descripcion = descripcion
        self.precio = precio
        self.color = color
        self.tallas = tallas
        self.categoria_sexo = categoria_sexo ?? CategoriaSexo.unisex
        self.categoria_ropa = categoria_ropa ?? CategoriaRopa.sudaderas
        self.nombresFotos = nombresFotos
        self.enFavoritos = enFavoritos ?? false
        self.enCesta = enCesta ?? false
        self.tallaCesta = tallaCesta ?? TallaPrenda.NoSeleccionada
    }
    
    // Funciones del ID
    func consultarID() -> Int{
        return self.id
    }
    
    // Funciones del nombre
    func consultarNombre() -> String{
        return self.nombre
    }
    
    // Funciones del precio
    func consultarPrecio() -> Int{
        return self.precio
    }
    
    func modificarPrecio(nuevoPrecio:Int){
        self.precio = nuevoPrecio
    }
    
    func aplicarDescuento(porcentaje:Int){
        self.precio -= self.precio*(porcentaje/100)
    }
    
    // Funciones del color
    func consultarColor() -> String{
        return self.color
    }
    
    func modificarColor(nuevoColor:String){
        self.color = nuevoColor
    }
    
    // Funciones de la talla
    func actualizarTalla(talla: TallaPrenda, cantidad: Int){
        for var t in self.tallas{
            if t.talla == talla{
                t.cantidad -= cantidad
            }
        }
    }
    
    func tallasDisponibles() -> [String]{
        var tallas:Array<String> = []
        for t in self.tallas{
            if t.cantidad > 0{
                tallas.append(t.talla.rawValue)
            }
        }
        return tallas
    }
    
    func cantidadTalla(talla:String) -> Int{
        var cantidad = 0
        for t in self.tallas{
            if t.talla.rawValue == talla{
                cantidad = t.cantidad
            }
        }
        return cantidad
    }
    
    func nuevaTallaCesta(talla:String){
        self.tallaCesta = Prenda.TallaPrenda.init(rawValue: talla) ?? TallaPrenda.NoSeleccionada
    }
    
    func consultarTallaCesta() -> String{
        return self.tallaCesta.rawValue
    }
    
    // Funciones de la descripción
    func consultarDescripcion() -> String{
        return self.descripcion
    }
    
    func modificarDescripcion(nuevaDescripcion:String){
        self.descripcion = nuevaDescripcion
    }
    
    // Funciones de favoritos
    func estaEnFavoritos() -> Bool{
        return self.enFavoritos
    }
    
    func ponerFavoritos(){
        self.enFavoritos = true
    }
    
    func quitarFavoritos(){
        self.enFavoritos = false
    }
    
    // Funciones de la cesta
    func estaEnCesta() -> Bool{
        return self.enCesta
    }
    
    func ponerCesta(){
        self.enCesta = true
    }
    
    func quitarCesta(){
        self.enCesta = false
    }
    
    // Funciones foto
    func consultarFoto(indice:Int) -> String{
        return self.nombresFotos[indice]
    }
    
    func cambiarFotos(nuevasFotos:Array<String>){
        var contador = 0
        for foto in nombresFotos{
            self.nombresFotos[contador] = foto
            contador+=1
        }
    }
    
    // Funciones categoría sexo
    func consultarCategoriaSexo() -> CategoriaSexo{
        return self.categoria_sexo
    }
    
    // Funciones categoría de ropa
    func consultarCategoriaRopa() -> CategoriaRopa{
        return self.categoria_ropa
    }
    
    func modificarCategoriaRopa(nuevaCategoria:CategoriaRopa){
        self.categoria_ropa = nuevaCategoria
    }
    
    // Funciones de cantidad
    func aumentarCantidad(){
        self.cantidad += 1
    }
    
    func disminuirCantidad(){
        self.cantidad -= 1
    }
    
    func consultarCantidad() -> Int{
        return self.cantidad
    }
    
    // Funciones de las fotos
    func consultarFoto1() -> Image{
        return self.fotoPrenda1
    }

    func consultarFoto2() -> Image{
        return self.fotoPrenda2
    }
    
    func consultarFoto3() -> Image{
        return self.fotoPrenda3
    }
    
    func consultarFoto4() -> Image{
        return self.fotoPrenda4
    }
}
