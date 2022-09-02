/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a single category item.
*/

import SwiftUI

struct ElementoCategoria: View {
    
    @ObservedObject var prenda: Prenda
    @Binding var deCesta: Bool
    @ObservedObject var prendasModelData : PrendasModelData
    @ObservedObject var usuario: Usuario
    
    let colorFondo = Color(red: 212/255.0, green: 217/255.0, blue: 211/255.0, opacity: 0.3)
    @State var cantidad: Int = 1
    @State private var tallas: Array<String> = []
    @State var mostrarPrenda = false
    @State private var noRegistrado = false
    
    var body: some View {
        
        if !self.deCesta{
            VStack{
                self.prenda.consultarFoto1()
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 140, height: 130)
                    .cornerRadius(5)
                    .padding(.all,2)
                
                VStack{
                    Text(self.prenda.consultarNombre())
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .frame(width: 180, height: 50, alignment: .center)
                        
                    if  self.prenda.estaEnCesta() && self.prenda.consultarTallaCesta() != ""{
                        Text("Talla  \(self.prenda.consultarTallaCesta()) ").foregroundColor(Color.white)
                        .frame(width: 80, height: 20, alignment: .topLeading)
                    }
                    
                    HStack{
                        // Precio de la prenda
                        Text(" \(self.prenda.consultarPrecio()) €").foregroundColor(Color.white)
                            .frame(width: 80, height: 20, alignment: .topLeading)
                        
                        /* PRENDAS FAVORITAS */
                        Button(action: { self.prendaFavoritos()}, label: {
                                    if !self.prenda.estaEnFavoritos(){
                            Image(systemName: "heart").resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            }
                            else{
                                Image(systemName: "heart.fill").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            }
                        })
                        .padding(.all, 1.5)
                        .padding(.trailing, 10)
                        .foregroundColor(Color.white)
                            
                            
                        if self.usuario.estado{
                            if !self.prenda.estaEnCesta(){
                                // SELECCIONAR TALLA
                                Menu {
                                    ForEach(self.tallas, id: \.self){ talla in
                                        Button {
                                            self.prenda.nuevaTallaCesta(talla: talla)
                                            self.prendaCesta()
                                        } label: {
                                            Text(talla)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "cart")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                }
                                .foregroundColor(.white)
                                .padding(.all, 1.5)
                                .onAppear(){
                                    self.tallas = self.prenda.tallasDisponibles().reversed()
                                }
                            }
                            else{
                                /* CESTA DE COMPRA */
                                Button(action: {
                                    self.prendaCesta() }, label: {
                                      Image(systemName: "cart.fill").resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                })
                                .padding(.all, 1.5)
                                .foregroundColor(Color.white)
                            }
                        }
                        else{
                            /* CESTA DE COMPRA */
                            Button(action: {
                                self.prendaCesta() }, label: {
                                  Image(systemName: "cart").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            })
                            .padding(.all, 1.5)
                            .foregroundColor(Color.white)
                        }
                    }
                }
            }
            .frame(width: 170, height: 250, alignment: .center)
            .padding(.all, 8)
            .background(self.colorFondo)
            .onTapGesture {
                self.mostrarPrenda = true
            }
            .popover(isPresented: self.$mostrarPrenda) {
                VistaPrenda(prendasModelData: self.prendasModelData, prenda: prenda, usuario: usuario)
            }
            .alert(isPresented: self.$noRegistrado, content: {
                Alert(title: Text("Aviso"), message: Text("Debe estar registrado para realizar esta operación"), dismissButton: .destructive(Text("OK")))
            })
        
        }
        else{
            HStack{
                
                Spacer()
                
                self.prenda.consultarFoto1()
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(5)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 3.0){
                    Text(self.prenda.consultarNombre())
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .font(.subheadline)
                    
                    HStack{
                        //Spacer()
                        // Precio de la prenda
                        Text(" \(self.prenda.consultarPrecio()) €")
                            .foregroundColor(Color.white)
                            
                        Spacer()
                        
                        Group{
                            /* QUITAR ÍTEM */
                            Button(action: { self.quitarItem() }, label: {
                                Image(systemName: "minus.circle").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                               
                            })
                            .padding(.all, 1.5)
                            .foregroundColor(Color.white)
                              
                            Text("\(self.cantidad) ítem(s)")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            /* AÑADIR ÍTEM */
                            Button(action: { self.sumarItem() }, label: {
                                Image(systemName: "plus.circle").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                               
                            })
                            .padding(.all, 1.5)
                            .foregroundColor(Color.white)
                        }
                        
                        Spacer()
                        
                        Text("Total \(self.prenda.consultarPrecio()*self.cantidad) €")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                
                    }
                    if self.prenda.consultarTallaCesta() != ""{
                        Text("Talla \(self.prenda.consultarTallaCesta())")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                }
                
                Spacer()
            }
            .padding(.all, 5)
            .background(self.colorFondo)
            .onTapGesture {
                self.mostrarPrenda = true
            }
            .popover(isPresented: self.$mostrarPrenda) {
                VistaPrenda(prendasModelData: self.prendasModelData, prenda: prenda, usuario: usuario)
            }
        }
        
    }
    
    func prendaFavoritos(){

        if !self.usuario.estado{
            self.noRegistrado = true
        }
        else{
            if self.prenda.estaEnFavoritos(){
                self.prendasModelData.Favoritos(poner: false, idPrenda: self.prenda.consultarID())
            }
            else{
                self.prendasModelData.Favoritos(poner: true, idPrenda: self.prenda.consultarID())
            }
        }
    }
    
    func prendaCesta(){
        if !self.usuario.estado{
            self.noRegistrado = true
        }
        else{
            if self.prenda.estaEnCesta(){
                self.prendasModelData.Cesta(poner: false, idPrenda: self.prenda.consultarID(), talla: "")
            }
            else{
                self.prendasModelData.Cesta(poner: true, idPrenda: self.prenda.consultarID(), talla: self.prenda.consultarTallaCesta())
            }
        }
    }
    
    func quitarItem(){
        if (self.cantidad - 1) == 0{
            self.cantidad -= 1
            self.prenda.disminuirCantidad()
            self.prendaCesta()
        }
        else if self.cantidad == 0{
            
        }
        else{
            self.cantidad -= 1
            self.prenda.disminuirCantidad()
        }
    }
    
    func sumarItem(){
        self.cantidad += 1
        self.prenda.aumentarCantidad()
    }
}

struct ElementoCategoria_Previews: PreviewProvider {
    static var previews: some View {
        ElementoCategoria(prenda: PrendasModelData().prendas[0], deCesta: Binding.constant(true), prendasModelData: PrendasModelData(), usuario: Usuario())
            
    }
}
