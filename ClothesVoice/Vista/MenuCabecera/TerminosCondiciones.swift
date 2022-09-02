//
//  TerminosCondiciones.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 27/8/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import SwiftUI

struct TerminosCondiciones: View {
    
    // Atributos privados de la vista
    @Environment(\.presentationMode) private var presentation
    
    var body: some View {
            
        ZStack{
            
            Image("fondo_inicio")
                .ignoresSafeArea()
            
            // CONTENIDO
            VStack{

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
               
                ScrollView(.vertical, showsIndicators: false){
                   
            Group{
            Spacer()
            Text("Términos y Condiciones")
                .font(.title)
                .foregroundColor(.yellow)
            Spacer()
            Text("""
              Al descargar o utilizar la aplicación, estos términos se aplicarán automáticamente a usted; por lo tanto, debe asegurarse de leerlos cuidadosamente antes de utilizar la aplicación. No está permitido copiar o modificar la aplicación, ninguna parte de la misma o nuestras marcas comerciales de ninguna manera.
              No está permitido intentar extraer el código fuente de la aplicación, y tampoco debe intentar traducir la aplicación a otros idiomas, o hacer versiones derivadas. La aplicación en sí misma, así como todas las marcas comerciales, los derechos de autor, los derechos de la base de datos y otros derechos de propiedad intelectual relacionados con ella, siguen perteneciendo a SCARS.
                SCARS se compromete a garantizar que la aplicación sea lo más útil y eficiente posible. Por ello, nos reservamos el derecho a realizar cambios en la aplicación o a cobrar por sus servicios, en cualquier momento y por cualquier motivo. Nunca le cobraremos por la aplicación o sus servicios sin dejarle bien claro por qué está pagando.
                La aplicación SCARS almacena y procesa los datos personales que usted nos ha proporcionado, con el fin de proporcionar nuestro Servicio. Es su responsabilidad mantener su teléfono y el acceso a la aplicación seguros. Por lo tanto, te recomendamos que no hagas jailbreak o root a tu teléfono, que es el proceso de eliminar las restricciones y limitaciones de software impuestas por el sistema operativo oficial de tu dispositivo. Podría hacer que su teléfono sea vulnerable a malware/virus/programas maliciosos, comprometer las características de seguridad de su teléfono y podría significar que la aplicación SCARS no funcione correctamente o en absoluto.
              La aplicación utiliza servicios de terceros que declaran sus propios términos y condiciones.
              Enlace a los términos y condiciones de los proveedores de servicios de terceros utilizados por las aplicaciones:
              """)
            Group{
            Spacer()
            Link("Servicios de Google Play", destination: URL(string: "https://policies.google.com/privacy")!)
                .foregroundColor(.blue)
                .padding(.trailing, 185)
            Spacer()
            Link("Servicios de Firebase Crashlytics", destination: URL(string: "https://firebase.google.com/support/privacy/")!)
                .foregroundColor(.blue)
                .padding(.trailing, 122)
            Spacer()
            }
            Text("""
                Debes tener en cuenta que hay ciertas cosas de las que SCARS no se hace responsable. Algunas funciones de la aplicación requieren que la aplicación tenga una conexión a Internet activa. La conexión puede ser Wi-Fi, o proporcionada por su proveedor de red móvil, pero SCARS no puede responsabilizarse de que la aplicación no funcione a pleno rendimiento si no tiene acceso a Wi-Fi, y no le queda nada de su asignación de datos.
                Si utiliza la aplicación fuera de una zona con Wi-Fi, debe recordar que se seguirán aplicando las condiciones del acuerdo con su proveedor de red móvil. En consecuencia, es posible que tu proveedor de telefonía móvil te cobre el coste de los datos durante la conexión mientras accedes a la aplicación, o bien otros cargos de terceros. Al utilizar la aplicación, usted acepta la responsabilidad de dichos cargos, incluidos los cargos por datos en itinerancia si utiliza la aplicación fuera de su territorio (es decir, región o país) sin desactivar la itinerancia de datos. Si usted no es el pagador de la factura del dispositivo en el que está utilizando la aplicación, tenga en cuenta que suponemos que ha recibido el permiso del pagador de la factura para utilizar la aplicación.
                En la misma línea, SCARS no siempre puede asumir la responsabilidad por la forma en que usted utiliza la aplicación, es decir, debe asegurarse de que su dispositivo permanece cargado; si se queda sin batería y no puede encenderlo para utilizar el Servicio, SCARS no puede aceptar la responsabilidad.
                Con respecto a la responsabilidad de SCARS por el uso que usted haga de la aplicación, es importante que tenga en cuenta que, aunque nos esforzamos por garantizar que esté actualizada y sea correcta en todo momento, dependemos de terceros que nos proporcionan información para poder ponerla a su disposición. SCARS no acepta ninguna responsabilidad por cualquier pérdida, directa o indirecta, que experimente como resultado de confiar totalmente en esta funcionalidad de la aplicación.
                Es posible que en algún momento queramos actualizar la aplicación. La aplicación está actualmente disponible en iOS - los requisitos del sistema (y de cualquier sistema adicional al que decidamos ampliar la disponibilidad de la aplicación) pueden cambiar, y usted tendrá que descargar las actualizaciones si quiere seguir utilizando la aplicación. SCARS no se compromete a actualizar siempre la app para que sea relevante para usted y/o funcione con la versión de iOS que tenga instalada en su dispositivo. Sin embargo, usted se compromete a aceptar siempre las actualizaciones de la aplicación cuando se le ofrezcan, También es posible que deseemos dejar de proporcionar la aplicación, y podemos terminar el uso de la misma en cualquier momento sin dar aviso de la terminación a usted. Salvo que le indiquemos lo contrario, al producirse cualquier rescisión, (a) los derechos y licencias que se le conceden en estas condiciones finalizarán; (b) deberá dejar de utilizar la aplicación y (si es necesario) borrarla de su dispositivo.
              """)
            }
            Group{
                Spacer()
                Text("Cambios en estas condiciones")
                    .font(.title2)
                    .foregroundColor(.yellow)
                Spacer()
            Text("""
                Es posible que actualicemos nuestros Términos y Condiciones de vez en cuando. Por lo tanto, se le aconseja que revise esta página periódicamente para ver si hay cambios. Le notificaremos cualquier cambio publicando los nuevos Términos y Condiciones en esta página.
                Estos términos y condiciones son efectivos a partir del 13-07-2021
              """)
                    Spacer()
                    }
                    Group{
                    Spacer()
                    Text("Contacto")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
            Text("""
                Si tiene alguna pregunta o sugerencia sobre nuestros Términos y Condiciones, no dude en ponerse en contacto con nosotros en fernandovillalba1998@gmail.com.
                Esta página de Términos y Condiciones fue generada por
                """)
                Link("App Privacy Policy Generator", destination: URL(string: "https://app-privacy-policy-generator.nisrulz.com")!)
                    .foregroundColor(.blue)
                    Spacer()
                    }
                    
                } // Fin ScrollView
                .padding()
                .foregroundColor(.white)
                
                EspacioMedio()
                
            } // FIN CONTENIDO
            .navigationBarHidden(true)
        }
    }
    
    struct TerminosCondiciones_Previews: PreviewProvider {
        static var usuario = Usuario()
        static var previews: some View {
            Group {
                TerminosCondiciones()
            }
        }
    }
}
