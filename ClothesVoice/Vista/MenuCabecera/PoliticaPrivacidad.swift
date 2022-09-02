//
//  PoliticaPrivacidad.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 27/8/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import SwiftUI

struct PoliticaPrivacidad: View {
    
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
                    Text("Política de privacidad")
                        .font(.title)
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("""
                        SCARS construyó la aplicación SCARS como una aplicación comercial. Este SERVICIO es proporcionado por SCARS y está destinado a ser utilizado como tal.
                        Esta página se utiliza para informar a los visitantes en relación con nuestras políticas de recopilación, uso y divulgación de información personal si alguien decide utilizar nuestro Servicio.
                        Si decide utilizar nuestro Servicio, entonces acepta la recopilación y el uso de la información en relación con esta política. La información personal que recogemos se utiliza para proporcionar y mejorar el Servicio. No utilizaremos ni compartiremos su información con nadie, excepto como se describe en esta Política de Privacidad.
                        Los términos utilizados en esta Política de Privacidad tienen el mismo significado que en nuestros Términos y Condiciones, a los que se puede acceder en SCARS, a menos que se defina lo contrario en esta Política de Privacidad.
                      """)
                    Spacer()
                    Text("Recogida y uso de la información")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("""
                        Para una mejor experiencia, al utilizar nuestro Servicio, podemos requerirle que nos proporcione cierta información personal identificable, incluyendo pero no limitado a nombre, apellido, correo electrónico y contraseña. La información que solicitamos será retenida por nosotros y utilizada como se describe en esta política de privacidad.
                        La aplicación utiliza servicios de terceros que pueden recopilar información utilizada para identificarle.
                        Enlace a la política de privacidad de los proveedores de servicios de terceros utilizados por la aplicación
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
                    }
                    Group{
                    Text("Datos de registro")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("""
                        Queremos informarle de que siempre que utilice nuestro Servicio, en caso de error en la aplicación, recopilamos datos e información (a través de productos de terceros) en su teléfono denominados Datos de Registro. Estos datos de registro pueden incluir información como la dirección del protocolo de Internet ("IP") de su dispositivo, el nombre del dispositivo, la versión del sistema operativo, la configuración de la aplicación al utilizar nuestro Servicio, la hora y la fecha de su uso del Servicio y otras estadísticas.
                     """)
                    Spacer()
                    Text("Cookies")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("""
                        Las cookies son archivos con una pequeña cantidad de datos que se utilizan habitualmente como identificadores únicos anónimos. Se envían a su navegador desde los sitios web que visita y se almacenan en la memoria interna de su dispositivo.
                        Este Servicio no utiliza estas "cookies" explícitamente. Sin embargo, la aplicación puede utilizar código y bibliotecas de terceros que utilizan "cookies" para recopilar información y mejorar sus servicios.
                     Usted tiene la opción de aceptar o rechazar estas "cookies" y saber cuándo se envía una "cookie" a su dispositivo. Si decide rechazar nuestras cookies, es posible que no pueda utilizar algunas partes de este Servicio.
                     """)
                    }
                    Group{
                    Spacer()
                    Text("Proveedores de servicios")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("""
                        Podemos emplear a terceras empresas y personas por las siguientes razones
                        - Para facilitar nuestro Servicio;
                        - Para prestar el Servicio en nuestro nombre;
                        - Para realizar servicios relacionados con el Servicio;
                        - Para ayudarnos a analizar cómo se utiliza nuestro Servicio.
                        Queremos informar a los usuarios de este Servicio de que estos terceros tienen acceso a sus Datos Personales.
                        El motivo es realizar las tareas que se les asignan en nuestro nombre. Sin embargo, están obligados a no divulgar ni utilizar la información para ningún otro fin.
                     """)
                    Spacer()
                    }
                    Group{
                    Text("Seguridad")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("""
                        Valoramos su confianza al proporcionarnos sus datos personales, por lo que nos esforzamos en utilizar medios comercialmente aceptables para protegerlos. Pero recuerde que ningún método de transmisión por Internet, o método de almacenamiento electrónico es 100% seguro y fiable, y no podemos garantizar su absoluta seguridad.
                     """)
                    Spacer()
                    Text("Enlaces a otros sitios web")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
                    }
                    Group{
                    Text("""
                        Este Servicio puede contener enlaces a otros sitios. Si hace clic en un enlace de terceros, será dirigido a ese sitio. Tenga en cuenta que estos sitios externos no son operados por nosotros.
                        Por lo tanto, le aconsejamos encarecidamente que revise la política de privacidad de estos sitios web. No tenemos ningún control ni asumimos ninguna responsabilidad por el contenido, las políticas de privacidad o las prácticas de los sitios o servicios de terceros.
                     """)
                    Spacer()
                    Text("Privacidad de los niños")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("""
                        Estos Servicios no se dirigen a personas menores de 13 años. No recopilamos conscientemente información personal identificable de niños menores de 13 años. En el caso de que descubramos que un niño menor de 13 años nos ha proporcionado información personal, la eliminamos inmediatamente de nuestros servidores. Si usted es un padre o tutor y tiene conocimiento de que su hijo nos ha proporcionado información personal, póngase en contacto con nosotros para que podamos tomar las medidas necesarias.
                     """)
                    Spacer()
                    }
                    Group{
                        
                    Text("Cambios en esta política de privacidad")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("""
                        Es posible que actualicemos nuestra política de privacidad de vez en cuando. Por lo tanto, se le aconseja que revise esta página periódicamente para ver si hay cambios. Le notificaremos cualquier cambio publicando la nueva Política de Privacidad en esta página.
                        Esta política es efectiva a partir del 13-07-2021
                     """)
                    Spacer()
                    Text("Contacto")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("""
                        Si tiene alguna pregunta o sugerencia sobre nuestra política de privacidad, no dude en ponerse en contacto con nosotros en fernandovillalba1998@gmail.com.
                        Esta página de política de privacidad fue creada en [ privacypolicytemplate.net](https://www.privacypolicytemplate.net) y modificada/generada por
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
    
    struct PoliticaPrivacidad_Previews: PreviewProvider {
        static var usuario = Usuario()
        static var previews: some View {
            Group {
                PoliticaPrivacidad()
            }
        }
    }
}


