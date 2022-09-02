//
//  Email.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 13/9/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

/*
 Clase para enviar un correo con el pedido adjunto en formato PDF al destinatario indicado (cliente que
 realiza el pedido) mediante el correo del administrador. Se usa el paquete SwiftSMTP para esta tarea.
 */

import PDFKit
import SwiftSMTP

final class Email: Identifiable{

    private let smtp: SMTP
    private let archivoAdjunto : Attachment
    private let htmlArchivoAdjunto : Attachment
    private let datosArchivoAdjunto : Attachment
    private let mail : Mail
    
    init(destinatario:String, ruta:String) {
        
        self.smtp = SMTP(
            hostname: "smtp.gmail.com",  // SMTP dirección del servidor
            email: "mucho.atletico@gmail.com",   // nombre del usuario a iniciar sesión
            password: "kupfyP-9birvi-fawzof"   // contraseña del usuario a iniciar sesión
        )
        
        // Crear un archivo adjunto
        self.archivoAdjunto = Attachment(
            filePath: "/Users/fernandovillalba/Desktop/TFG/App/ClothesVoice/ClothesVoice/Assets.xcassets/SCARS.imageset/SCARS.png",
            // "CONTENT-ID" permite referenciar esto en otro archivo adjunto
            additionalHeaders: ["CONTENT-ID": "scars"]
        )
        
        self.htmlArchivoAdjunto = Attachment(
            htmlContent: "<html> <p><img src=\"cid:scars\"/> </p> <br> <p>Gracias por comprar en SCARS, le adjuntamos su pedido en PDF.</p></html>",
            relatedAttachments: [self.archivoAdjunto]
        )
    
        let pdf = PDFDocument(url: URL.init(fileURLWithPath: ruta))
        
        self.datosArchivoAdjunto = Attachment(
            data: pdf!.dataRepresentation()!,
            mime: "application/pdf",
            name: "pedido_SCARS",
            inline: false
        )
        
        // Crear un correo e incluir los archivos adjuntos
        self.mail = Mail(
            from: Mail.User.init(email: "fernandovillalba1998@gmail.com"),
            to: [Mail.User.init(email: "\(destinatario)")],
            subject: "¡Aquí tiene su pedido de SCARS!",
            // Archivos adjuntos creados anteriormente
            attachments: [self.htmlArchivoAdjunto ,self.datosArchivoAdjunto]
        )
    }

    func enviarMail(){
        // Enviar el correo
        self.smtp.send(mail) { (error) in
            if let error = error {
                print(error)
            }
        }
    }

}
