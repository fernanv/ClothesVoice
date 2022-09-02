//
//  ResumenPedido.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 13/9/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import SwiftUI

struct ResumenPedido: View {
    
    // Atributos compartidos por otras vistas
    @ObservedObject var usuario : Usuario
    @ObservedObject var prendasModelData : PrendasModelData
    @ObservedObject var pedido : PedidoModelData
    
    // Atributos privados de la vista
    @State private var manejadorPago = ManejadorPago()
    @State private var noEnviado = false
    
    @Environment(\.presentationMode) private var presentation
    
    private let colorBoton = Color(red: 113/255.0, green: 200/255.0, blue: 86/255.0, opacity: 1.0)
    
    var body: some View {

        NavigationView{
            
            ZStack{
                
                Image("fondo_inicio").ignoresSafeArea()
                
                // CONTENIDO
                VStack{

                    EspacioMedio()
                    
                    Button(action: {
                        self.presentation
                            .wrappedValue
                            .dismiss()
                        self.pedido.Borrar()
                           },
                           label: {
                                Image(systemName: "arrowshape.turn.up.backward.circle").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                    })
                    .foregroundColor(.gray)
                    .padding(.trailing, 300.0)
                    .padding(.top, 50.0)

                    EspacioMedio()

                    Group{
                        Text("Resumen del pedido")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .padding(.trailing, 200)
                        
                        Text("\(self.pedido.tamPedido) artículos seleccionados")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .padding(.top, 5)
                            .padding(.trailing, 200)
                        EspacioPeque()
                    }
                        
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack{
                            ForEach(self.pedido.itemsPedido) {
                                item in
                                
                                Spacer()
                                
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
                            }
                        }
                        .padding(.vertical)
                    } // Fin ScrollView
                    
                    Spacer()

                    /* BOTÓN PAGO */
                    Button(action: {
                        self.manejadorPago.ponerPrecio(precio: self.pedido.pedido.consultarPrecio())
                        self.manejadorPago.comenzarPago { (resultadoCorrecto) in
                                if resultadoCorrecto{
                                    let direccion = self.manejadorPago.consultarDireccion()
                                    self.usuario.obtenerDatos()
                                    let rutaArchivo = pedidoPDF(direccion: direccion);
                                    print(rutaArchivo)
                                    print(self.pedido.emailUsuario ?? "SIN_ACCESO")
                                    let email = Email(destinatario: self.pedido.emailUsuario ?? "SIN_ACCESO", ruta: rutaArchivo);
                                    email.enviarMail()
                                    self.prendasModelData.vaciarCesta()
                                    self.pedido.completarPedido()
                                    self.presentation
                                        .wrappedValue
                                        .dismiss()
                                }
                                else{
                                    self.noEnviado = true
                                    print("Fallo en el proceso de pago")
                                }
                            }
                        }, label: {
                            Text("PAGAR CON  APPLE")
                            .font(Font.custom("HelveticaNeue-Bold", size: 16))
                            .padding()
                            .foregroundColor(.white)
                            .frame(width: 210, height: 50)
                            .background(colorBoton)
                            .cornerRadius(50.0)
                    })
                    .onAppear(){
                        self.usuario.obtenerDatos()
                    }
                    
                    
                    Group{
                        EspacioGrande()
                        EspacioGrande()
                        EspacioPeque()
                    }
                    
                } // FIN CONTENIDO
                .onAppear(){
                    self.usuario.obtenerDatos()
                    self.pedido.Crear(items: self.prendasModelData.pedido)
                }
                .alert(isPresented: self.$noEnviado, content: {
                    Alert(title: Text("Fallo en la operación"), message: Text("No ha sido posible realizar la operación."), dismissButton: .destructive(Text("OK")))
                })
            }// Fin NavigationView
            .navigationBarHidden(true)
        }
    }
    
    /*
     Función que genera el pedido en formato PDF para su posterior envío
     al cliente y que devuelve la ruta a dicho archivo
     */
    func pedidoPDF(direccion:String) -> String {
        
        // 1. Generar código html e indicar como formato de impresión
        
        var itemsPedido : String = ""
        for item in self.pedido.itemsPedido{
            let s = "<tr> <td align=\"center\" width=\"300px\" length=\"100px\"> <strong>\(item.consultarNombre())</strong> </td> <td align=\"center\" width=\"200px\" length=\"100px\"> Talla \(item.consultarTalla()) </td> <td align=\"center\" width=\"200px\" length=\"100px\"> Cantidad: \(item.consultarCantidad()) ítem(s) </td> <td align=\"center\" width=\"200px\" length=\"100px\"> Precio: \(item.consultarPrecio()) €</td> </tr>"
                itemsPedido += s
        }
        
        let html = "<html><body><head><style>h1{display: block;font-size: 2em;margin-top: 0.67em;margin-bottom: 0.67em;margin-left: 0;margin-right: 0;font-weight: bold;text-align:center; font-style: oblique;}</style></head><br>" +
                    "<h1 class=\"h1\">Detalles de su pedido</h1>" +
                    "<table Border=\"1\"" +
                    "<br><br><br>" +
                    "<p> Localizador: <strong> \(self.pedido.pedido.consultarID()) </strong> </p>" +
                    itemsPedido +
                    "</table>" +
                    "<br><br>" +
                    "<p> Cliente: \(self.usuario.nombre) \(self.usuario.apellidos)</p>" +
                    "<p> Dirección de envío: \(direccion)</p>" +
                    "<p> Fecha del pedido: \(self.pedido.pedido.consultarFecha()) </p><br>" +
                    "<p> \(self.pedido.tamPedido) artículo(s) comprado(s) </p>" +
                    "<p> Precio del envío: \(self.manejadorPago.consultarEnvio()) € </p>" +
                    "<p> Precio final (envío incluido): <strong>\(self.manejadorPago.consultarPrecio()+self.manejadorPago.consultarEnvio()) € </strong></p><br>" +
                    "<p> Gracias por comprar en SCARS, esperamos que vuelvas pronto.</p>" +
                    "<p> Si tienes alguna consulta puedes escribir un email a nuestra dirección scarsthebrand@gmail.com</p><br>" +
                    "<p> Este es un correo automático, por favor, no responda a este correo. </p></html></body>"

        let fmt = UIMarkupTextPrintFormatter(markupText: html)

        // 2. Asignar el formato de impresión a UIPrintPageRenderer

        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

        // 3. Asignar paperRect y printableRect

        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

        // 4. Crear el contexto del PDF y pintarlo

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        // 5. Guardar el archivo PDF

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let rutaArchivo = "\(documentsPath)/pedido_\(self.pedido.emailUsuario ?? "").pdf"
        pdfData.write(toFile: rutaArchivo, atomically: true)
        
        return rutaArchivo
    }
}
