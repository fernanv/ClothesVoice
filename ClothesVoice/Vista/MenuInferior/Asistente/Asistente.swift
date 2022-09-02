//
//  Overlay.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 20/7/21.
//  Copyright © 2021 fernanv. All rights reserved.
//

import SwiftUI
import UIKit
import WebKit

struct Asistente: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = Controlador
    
    // Atributos compartidos por otras vistas
    @Binding var login: Bool
    @Binding var perfil: Bool
    @Binding var favoritos: Bool
    @Binding var cesta: Bool
    @Binding var asistente: Bool
    @ObservedObject var usuario : Usuario
    @ObservedObject var prendasModelData : PrendasModelData
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        return UIViewControllerType(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self._usuario, prendas: self._prendasModelData)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        self.prendasModelData.obtenerValoresAsistente()
    }
    
    func makeCoordinator() -> Asistente.Coordinator {
        return Coordinator()
    }
}
 
class Controlador: UIViewController, UIGestureRecognizerDelegate , UIWebViewDelegate, WKNavigationDelegate  {

    // Atributos compartidos por otras vistas
     @Binding var login: Bool
     @Binding var perfil: Bool
     @Binding var favoritos: Bool
     @Binding var cesta: Bool
     @Binding var asistente: Bool
     @ObservedObject var usuario : Usuario
     @ObservedObject var prendasModelData : PrendasModelData
    
    init(login: Binding<Bool>, perfil: Binding<Bool>, favoritos: Binding<Bool>, cesta: Binding<Bool>, asistente: Binding<Bool>, usuario: ObservedObject<Usuario>, prendas: ObservedObject<PrendasModelData> ) {
        self._login = login
        self._perfil = perfil
        self._favoritos = favoritos
        self._cesta = cesta
        self._asistente = asistente
        self._usuario = usuario
        self._prendasModelData = prendas
        super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
        
     private let url = NSURL(string:"https://console.dialogflow.com/api-client/demo/embedded/32421d5b-de72-4285-bab3-ee33d8cfa5d2")
     private var webView: WKWebView!

     override func viewDidLoad() {
        
        super.viewDidLoad()

        // WEBVIEW
        self.webView = WKWebView(frame: CGRect( x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 140 ), configuration: WKWebViewConfiguration() )
        
        self.view.addSubview(self.webView)
        let req = NSURLRequest(url:self.url! as URL)
        self.webView.load(req as URLRequest)
        self.webView.allowsBackForwardNavigationGestures = true
        
        // NAVMENU
        let navmenu = UIHostingController(rootView: NavMenu(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario))
        navmenu.view.translatesAutoresizingMaskIntoConstraints = false
        navmenu.view.frame = self.webView.bounds
        let margins = view.layoutMarginsGuide
        
        self.view.addSubview(navmenu.view)
        self.view.sendSubviewToBack(navmenu.view)
        
        NSLayoutConstraint.activate([
            navmenu.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
            navmenu.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
            navmenu.view.heightAnchor.constraint(equalToConstant: 1610),
        ])
     }

     override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }
    
}
