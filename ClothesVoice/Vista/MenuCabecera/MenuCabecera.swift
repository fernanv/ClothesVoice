//
//  MenuCabecera.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 20/4/21.
//

import SwiftUI

struct MenuCabecera: View {
    
    // Atributos compartidos por otras vistas
    @Binding var login: Bool
    @Binding var perfil: Bool
    @Binding var favoritos: Bool
    @Binding var cesta: Bool
    @Binding var asistente: Bool
    @ObservedObject var usuario : Usuario
    @ObservedObject var prendasModelData : PrendasModelData
    
    // Atributos de la vista
    @State var opcion_sexo = 0
    
    let sexos = [("MUJER", 0), ("HOMBRE", 1), ("NIÑOS", 2)]
    
    // Atributos privados de la vista
    @Environment(\.presentationMode) private var presentation

    private let colorFondo = Color(red: 107/255.0, green: 103/255.0, blue: 103/255.0, opacity: 0.2)
    
    var body: some View{
         
        NavigationView{
            
            ZStack{
                
                Image("fondo_inicio").ignoresSafeArea()
                
                // CONTENIDO
                VStack{
                    
                    Button(action: {
                        self.presentation
                            .wrappedValue
                            .dismiss();
                        },
                           label: {
                                Image(systemName: "multiply")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
                    })
                    .foregroundColor(.white)
                    .padding(.trailing, 300.0)
                    .padding(.top, 80.0)
                    
                    HStack(spacing: 35){
                        ForEach(self.sexos, id: \.0){ value in
                            Button(action: {
                                self.opcion_sexo =  value.1
                            }){
                                Text(value.0)
                                    .font(.system(size: 15))
                                    .foregroundColor(value.1 == self.opcion_sexo
                                        ? Color.white
                                        : Color.gray)
                                NavigationLink(destination: EmptyView()) {
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .padding(.top, 50.0)
                    
                    Spacer()
                    
                    VStack{
                        // Obtengo todas las categorías donde hay al menos una prenda
                        ForEach(self.prendasModelData.categorias.keys.sorted(), id: \.self){ key in
                           
                            NavigationLink( destination: Categoria(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, categoria_ropa: Binding.constant(key), opcion_sexo: self.$opcion_sexo, usuario: self.usuario, prendasModelData: self.prendasModelData) ){
                                Text(key)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.all, 35).foregroundColor(Color.white)
                        }
                        .navigationBarHidden(true)
                    }
                    
                    EspacioGrande()
                    
                    NavigationLink( destination: PoliticaPrivacidad()){
                        Text("Política de privacidad")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom)
                    .padding(.trailing, 166.5)
                    .foregroundColor(.yellow)
                    
                    NavigationLink( destination: TerminosCondiciones()){
                        Text("Términos y condiciones")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom)
                    .foregroundColor(.yellow)
                    .padding(.trailing, 150)
                    

                    EspacioPeque()
                } // FIN CONTENIDO
            }
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
    
    struct MenuCabecera_Previews:
        PreviewProvider{
        static var usuario = Usuario()
        static var previews: some View {
            MenuCabecera(login: Binding.constant(false), perfil: Binding.constant(false), favoritos: Binding.constant(false), cesta: Binding.constant(false), asistente: Binding.constant(false), usuario: self.usuario, prendasModelData: PrendasModelData())
        }
    }
}
