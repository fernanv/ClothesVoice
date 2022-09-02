//
//  VistaPrenda.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 12/4/21.
//
/*
En esta vista se muestra una prenda de forma individual después de seleccionarla  desde la vista de la categoría concreta donde se encontraba dicha prenda (CategoriaIndividual.swift) o desde las vistas de Favoritos (Favoritos.swift) o Cesta (Cesta.swift).
 En ella se muestran las imágenes asociadas a la prenda, nombre, precio y descripción de la misma y 3 botones, uno para trasladar o quitar la prenda de la sección de favoritos, otro para hacer lo propio con la sección de la cesta y uno para compartir la prenda fuera de la App.
*/


import SwiftUI
import UIKit

struct VistaPrenda: View {
    
    @ObservedObject var prendasModelData : PrendasModelData
    @ObservedObject var prenda: Prenda
    @ObservedObject var usuario: Usuario
    
    @Environment(\.presentationMode) var presentation
    @State private var tallas: Array<String> = []
    @State private var showShareSheet = false
    @State private var noRegistrado = false
    
    var body: some View {
    
        ZStack{
            
            Image("fondo_inicio").ignoresSafeArea()
            
            // CONTENIDO
            VStack{
                
                Spacer()
                Spacer()
                
                Button(action: {self.presentation
                        .wrappedValue
                    .dismiss()
                    },
                       label: {
                            Image(systemName: "multiply").resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                })
                .foregroundColor(.white)
                .padding(.trailing, 320.0)
                .padding(.top, 60.0)
                
                ScrollView{
                    
                    Spacer()
                    
                    // Fotos de la prenda
                    TabView{
                        self.prenda.consultarFoto1()
                            // Imagen principal
                            .renderingMode(.original)
                            .resizable()
                            .padding(.horizontal, 10.0)
                             
                        self.prenda.consultarFoto2()
                            .renderingMode(.original)
                            .resizable()
                            .padding(.horizontal, 10.0)
                        
                        self.prenda.consultarFoto3()
                            .renderingMode(.original)
                            .resizable()
                            .padding(.horizontal, 10.0)
                        
                        self.prenda.consultarFoto4()
                            .renderingMode(.original)
                            .resizable()
                            .padding(.horizontal, 10.0)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 520.0, alignment: .bottom)
                    
                    // Nombre de la prenda
                    Text(self.prenda.consultarNombre())
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(width: 370, height: 20, alignment: .topLeading)
                    
                    // Precio de la prenda
                    Text(" \(self.prenda.consultarPrecio()) €").foregroundColor(Color.white)
                        .frame(width: 380, height: 20, alignment: .topLeading)
                    
                    // Sección de Botones
                    HStack{
                        
                        Spacer()
                        
                        /* BOTÓN DE COMPARTIR */
                        Button(action: self.compartir) {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36, height: 36)
                        }
                        .padding(.all, 1.5).foregroundColor(Color.white)
                      
                        Spacer()
                        
                        /* PRENDAS FAVORITAS */
                        Button(action: { self.prendaFavoritos() }, label: {
                            if !self.prenda.estaEnFavoritos(){
                                Image(systemName: "heart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36, height: 36)
                            }
                            else{
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36, height: 36)
                            }
                        }).padding(.all, 1.5).foregroundColor(Color.white)
                        
                        Spacer()
                        
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
                                        .frame(width: 36, height: 36)
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
                                        .frame(width: 36, height: 36)
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
                                    .frame(width: 36, height: 36)
                            })
                            .padding(.all, 1.5)
                            .foregroundColor(Color.white)
                        }
                        
                        Spacer()
                        
                    }// Fin Sección de Botones
                    
                    if self.prenda.consultarTallaCesta() != ""{
                        Text("Talla \(self.prenda.consultarTallaCesta())")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Text(self.prenda.consultarDescripcion())
                        .foregroundColor(Color.white)
                        .padding(.all)
                      
                } // Fin ScrollView
                
                Spacer()
                
            } // Fin CONTENIDO
            .onAppear(){
                self.prendasModelData.obtenerFavoritosCesta()
                self.usuario.obtenerDatos()
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [URL(string: "https://www.instagram.com/scarsthebrand/")!])
                    }
            .alert(isPresented: self.$noRegistrado, content: {
                Alert(title: Text("Aviso"), message: Text("Debe estar registrado para realizar esta operación"), dismissButton: .destructive(Text("OK")))
            })
        }
        .navigationBarHidden(true)
        .padding(.all)
        
    }
    
    func prendaFavoritos(){
        if !self.usuario.estado{
            self.noRegistrado = true
        }
        else{
            self.noRegistrado = false
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
                self.prendasModelData.Cesta(poner: false, idPrenda: self.prenda.consultarID(), talla: "")        }
            else{
                self.prendasModelData.Cesta(poner: true, idPrenda: self.prenda.consultarID(), talla: self.prenda.consultarTallaCesta())
            }
        }
    }
    
    func compartir() {
        showShareSheet.toggle()
    }
    
    struct VistaPrenda_Previews:
        PreviewProvider {
        static var prendasModelData = PrendasModelData()
        static var previews: some View {
            VistaPrenda(prendasModelData: prendasModelData, prenda: prendasModelData.prendas[0], usuario: Usuario()).environmentObject(PrendasModelData())
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
