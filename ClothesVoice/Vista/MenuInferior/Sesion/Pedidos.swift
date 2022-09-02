//
//  Pedidos.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 19/9/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import SwiftUI

struct Pedidos: View {
    
    // Atributos compartidos por otras vistas
    @ObservedObject var registroPedidos : RegistroPedidosModelData
    @ObservedObject var usuario : Usuario
    
    // Atributos privados de la vista
    @Environment(\.presentationMode) private var presentation
    
    var body: some View {
            
        ZStack{
            
            Image("fondo_inicio").ignoresSafeArea()
            
            // CONTENIDO
            VStack{

                EspacioMedio()
                
                Button(action: {
                        self.presentation
                            .wrappedValue
                            .dismiss()
                       },
                       label: {
                            Image(systemName: "multiply").resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                })
                .foregroundColor(.gray)
                .padding(.trailing, 300.0)
                .padding(.top, 50.0)

                EspacioMedio()

                Text("Pedidos completados")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)

                if self.registroPedidos.pedidos.count != 0{
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack{
                            ForEach(self.registroPedidos.pedidos) {
                                pedido in
                                
                                EspacioMedio()
                                
                                VStack(alignment: .leading){
                                    Text("Resumen del pedido: ")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                    Text("\(pedido.consultarID())")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.white)
                                    
                                    Text("Fecha: \(pedido.consultarFecha())")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .padding(.top, 5)
                                    
                                    Text("Precio Total: \(pedido.consultarPrecio())")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .padding(.top, 5)
                                    
                                    EspacioPeque()
                                }
                                
                                ForEach(self.registroPedidos.items) {
                                    item in
                                    if pedido.consultarID() == item.consultarIdPedido(){
                                    HStack{
                                        
                                        Spacer()
                                        
                                        item.consultarFoto()
                                            .renderingMode(.original)
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                            .cornerRadius(5)
                                        
                                        EspacioMedio()
                                        
                                        VStack(alignment: .leading, spacing: 3.0){
                                            Text(item.consultarNombre())
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                                .font(.subheadline)
                                            
                                            HStack{
                                                // Precio de la prenda
                                                Text(" \(item.consultarPrecio()/item.consultarCantidad()) €")
                                                    .foregroundColor(Color.white)
                                                    
                                                Spacer()
                                                
                                                Text("\(item.consultarCantidad()) ítem(s)")
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                
                                                Spacer()
                                                
                                                Text("Total \(item.consultarPrecio()) €")
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                
                                                Spacer()
                                        
                                            }
                                            
                                            Text("Talla \(item.consultarTalla())")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                                .font(.subheadline)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.all, 1)
                                    .padding(.leading, 28)
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    } // Fin ScrollView
                }
                else{
                    EspacioPeque()
                    EspacioGrande()
                    VStack(alignment:.center){
                        Text("Aún no dispone de pedidos completados.")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                    }
                }
                Group{
                    EspacioGrande()
                    EspacioGrande()
                    EspacioPeque()
                }
                
            } // FIN CONTENIDO
        }
        .onAppear{
            self.registroPedidos.obtenerPedidos()
            self.registroPedidos.obtenerItems()
            self.usuario.obtenerDatos()
        }
    }

}
