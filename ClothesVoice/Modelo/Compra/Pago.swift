//
//  Pago.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 14/9/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

/*
 Clase para añadir y simular el pago de un pedido mediante
 el método seguro de pago Apple Pay, se usa el framework PassKit
 */

import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class ManejadorPago: NSObject {

    private var precioFinal : Int = 0
    private var tasaEnvio : Int = 3
    private var direccion: String = "Direccion"
    static let metodosPago: [PKPaymentNetwork] = [
        .amex,
        .masterCard,
        .visa
    ]

    private var controladorPago: PKPaymentAuthorizationController?
    private var resumenItemsPago = [PKPaymentSummaryItem]()
    private var estadoPago = PKPaymentAuthorizationStatus.failure
    private var manejadorFinalizacion: PaymentCompletionHandler?

    func comenzarPago(completion: @escaping PaymentCompletionHandler) {

        let precio = PKPaymentSummaryItem(label: "Precio", amount: NSDecimalNumber(string: "\(self.precioFinal)"), type: .final)
        let envio = PKPaymentSummaryItem(label: "Envío", amount: NSDecimalNumber(string: "\(self.tasaEnvio)"), type: .final)
        let final = PKPaymentSummaryItem(label: "Precio Final", amount: NSDecimalNumber(string: "\(self.precioFinal + self.tasaEnvio)"), type: .final)
        let total = PKPaymentSummaryItem(label: "", amount: NSDecimalNumber(string: "\(self.precioFinal + self.tasaEnvio)"), type: .pending)

        self.resumenItemsPago = [precio, envio, final, total];
        self.manejadorFinalizacion = completion

        // Crear nuestra solicitud de pago
        let solicitudPago = PKPaymentRequest()
        solicitudPago.paymentSummaryItems = self.resumenItemsPago
        solicitudPago.merchantIdentifier = "merchant.com.scars.com.SCARS"
        solicitudPago.merchantCapabilities = .capability3DS
        solicitudPago.countryCode = "ES"
        solicitudPago.currencyCode = "EUR"
        solicitudPago.requiredShippingContactFields = [.phoneNumber, .emailAddress]
        solicitudPago.supportedNetworks = ManejadorPago.self.metodosPago

        
        // Mostrar nuestra solicitud de pago
        self.controladorPago = PKPaymentAuthorizationController(paymentRequest: solicitudPago)
        self.controladorPago?.delegate = self
        self.controladorPago?.present(completion: { (presented: Bool) in
            if presented {
                NSLog("Controlador de pago presentado")
            } else {
                NSLog("Fallo al presentar el controlador de pago")
                self.manejadorFinalizacion!(false)
             }
         })
      }
    }

    /*
        Conformidad con PKPaymentAuthorizationControllerDelegate.
    */
    extension ManejadorPago: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

        // Realizar una validación muy básica de la información de contacto proporcionada
        if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
            self.estadoPago = .failure
        } else {
            // Aquí enviarías el token de pago a tu servidor o proveedor de pagos para que lo procese
            // Una vez procesado, devuelve un estado apropiado en el controlador de finalización (éxito, fracaso, etc.)
            self.estadoPago = .success
            self.direccion = payment.shippingContact?.emailAddress ?? "Direccion1"
        }

        completion(self.estadoPago)
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.estadoPago == .success {
                    self.manejadorFinalizacion!(true)
                } else {
                    self.manejadorFinalizacion!(false)
                }
            }
        }
    }
        
    func ponerPrecio(precio:Int){
        self.precioFinal = precio
    }
        
    func consultarPrecio() -> Int {
        return self.precioFinal
    }
        
    func consultarEnvio() -> Int {
        return self.tasaEnvio
    }
        
    func consultarDireccion() -> String{
        return self.direccion
    }

}
