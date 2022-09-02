/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Storage for model data.
*/

import FirebaseFirestore
import Firebase
import Combine

struct valoresAsistente: Identifiable{
    var id: Int?
    var color: String
    var categoria: String
    var sexo: String
    var precio: [Int]
    var disponible: Bool
    
    init(){
        self.id = -1
        self.color = ""
        self.categoria = ""
        self.sexo = ""
        self.precio = [-1,-1]
        self.disponible = false
    }
}

final class PrendasModelData: ObservableObject{
    
    private var db = Firestore.firestore()
    @Published var prendas = [Prenda]()
    @Published var valores = valoresAsistente()
    @Published var prendasFiltradas = [Prenda]()
    private var usuarioActual = Auth.auth().currentUser?.uid ?? "SIN_ACCESO"
    
    init() {
        self.obtenerPrendas()
        self.obtenerFavoritosCesta()
    }
    
    var pedido: [Prenda]{
        var prendasPedido = [Prenda]()
        for prenda in self.prendas{
            if prenda.estaEnCesta(){
                prendasPedido.append(prenda)
            }
        }
        return prendasPedido
    }

    var itemsFavoritos: Int{
        var contador = 0
        for prenda in self.prendas{
            if prenda.estaEnFavoritos(){
                contador += 1
            }
        }
        return contador
    }
    
    var itemsCesta: Int{
        var contador = 0
        for prenda in self.prendas{
            if prenda.estaEnCesta(){
                contador += 1
            }
        }
        return contador
    }
    
    var itemsFiltrados: Int{
        return self.prendasFiltradas.count
    }
    
    var sexos: [String: [Prenda]] {
        Dictionary(
            grouping: self.prendas,
            by: { $0.consultarCategoriaSexo().rawValue }
        )
    }
    
    var categorias: [String: [Prenda]] {
        Dictionary(
            grouping: self.prendas,
            by: { $0.consultarCategoriaRopa().rawValue }
        )
    }
    
    func obtenerPrendas(){
        
        self.db.collection("prendas").addSnapshotListener{ [self] (querySnapshot, error) in
            guard let documentos_prendas = querySnapshot?.documents else{
                print("No hay documentos de prendas")
                return
            }
           
            self.prendas = documentos_prendas.map{ (queryDocumentSnapshot) in
                let datos = queryDocumentSnapshot.data()
                
                let id = datos["id"] as? Int ?? -1
                let nombre = datos["nombre"] as? String ?? ""
                let precio = datos["precio"] as? Int ?? -1
                let color = datos["color"] as? String ?? ""
                let descripcion = datos["descripcion"] as? String ?? ""
                let categoria_sexo_datos = datos["categoria_sexo"] as? String ?? "Unisex"
                var categoria_sexo: Prenda.CategoriaSexo? = nil
                
                if categoria_sexo_datos == "Mujer"{
                    categoria_sexo = Prenda.CategoriaSexo.mujer
                }
                else if categoria_sexo_datos == "Hombre"{
                    categoria_sexo = Prenda.CategoriaSexo.hombre
                }
                else if categoria_sexo_datos == "Unisex"{
                    categoria_sexo = Prenda.CategoriaSexo.unisex
                }
                else if categoria_sexo_datos == "Niños"{
                    categoria_sexo = Prenda.CategoriaSexo.niños
                }
                
                let categoria_ropa_datos = datos["categoria_ropa"] as? String ?? "Sudaderas"
                var categoria_ropa: Prenda.CategoriaRopa? = nil
                
                if categoria_ropa_datos == "Camisetas"{
                    categoria_ropa = Prenda.CategoriaRopa.camisetas
                }
                else if categoria_ropa_datos == "Camisas"{
                    categoria_ropa = Prenda.CategoriaRopa.camisas
                }
                else if categoria_ropa_datos == "Sudaderas"{
                    categoria_ropa = Prenda.CategoriaRopa.sudaderas
                }
                
                let foto1 = datos["foto1"] as? String ?? ""
                let foto2 = datos["foto2"] as? String ?? ""
                let foto3 = datos["foto3"] as? String ?? ""
                let foto4 = datos["foto4"] as? String ?? ""
                
                let unidadesXS = datos["unidadesXS"] as? Int ?? -1
                let unidadesS = datos["unidadesS"] as? Int ?? -1
                let unidadesM = datos["unidadesM"] as? Int ?? -1
                let unidadesL = datos["unidadesL"] as? Int ?? -1
                let unidadesXL = datos["unidadesXL"] as? Int ?? -1
                let unidadesXXL = datos["unidadesXXL"] as? Int ?? -1
                
                return Prenda(id: id, nombre: nombre, descripcion: descripcion, precio: precio, color: color, tallas: [(talla: Prenda.TallaPrenda.XS,cantidad: unidadesXS), (talla: Prenda.TallaPrenda.S,cantidad: unidadesS), (talla: Prenda.TallaPrenda.M,cantidad: unidadesM), (talla: Prenda.TallaPrenda.L,cantidad: unidadesL), (talla: Prenda.TallaPrenda.XL,cantidad: unidadesXL), (talla: Prenda.TallaPrenda.XXL,cantidad: unidadesXXL)], categoria_sexo: categoria_sexo, categoria_ropa: categoria_ropa, nombresFotos: [foto1,foto2,foto3,foto4], enFavoritos: nil, enCesta: nil, tallaCesta: nil)
            }
        }
    }
    
    /*
    func obtenerPrendasFavoritosCesta(){
        
        db.collection("prendas").addSnapshotListener{ [self] (querySnapshot, error) in
             guard let documentos_prendas = querySnapshot?.documents else{
                 print("No hay documentos de prendas")
                 return
             }
            
            db.collection("favoritos_cesta")
                .whereField("id_usuario", isEqualTo: self.usuarioActual)
                .addSnapshotListener{ [self] (querySnapshot1, error) in
                 guard let documentos_favoritos = querySnapshot1?.documents else{
                     print("No hay documentos de prendas")
                     return
                 }

                for queryDocumentSnapshot1 in documentos_favoritos{
                        
                    self.prendas = documentos_prendas.map{ (queryDocumentSnapshot) in
                    
                    let datos = queryDocumentSnapshot.data()
                    let datosFav = queryDocumentSnapshot1.data()
                         
                     let id = datos["id"] as? Int ?? -1
                     let nombre = datos["nombre"] as? String ?? ""
                     let precio = datos["precio"] as? Int ?? -1
                     let color = datos["color"] as? String ?? ""
                     let descripcion = datos["descripcion"] as? String ?? ""
                     let categoria_sexo_datos = datos["categoria_sexo"] as? String ?? "Unisex"
                     var categoria_sexo: Prenda.CategoriaSexo? = nil
                     
                     if categoria_sexo_datos == "Mujer"{
                         categoria_sexo = Prenda.CategoriaSexo.mujer
                     }
                     else if categoria_sexo_datos == "Hombre"{
                         categoria_sexo = Prenda.CategoriaSexo.hombre
                     }
                     else if categoria_sexo_datos == "Unisex"{
                         categoria_sexo = Prenda.CategoriaSexo.unisex
                     }
                     else if categoria_sexo_datos == "Niños"{
                         categoria_sexo = Prenda.CategoriaSexo.niños
                     }
                     
                     let categoria_ropa_datos = datos["categoria_ropa"] as? String ?? "Sudaderas"
                     var categoria_ropa: Prenda.CategoriaRopa? = nil
                     
                     if categoria_ropa_datos == "Camisetas"{
                         categoria_ropa = Prenda.CategoriaRopa.camisetas
                     }
                     else if categoria_ropa_datos == "Camisas"{
                         categoria_ropa = Prenda.CategoriaRopa.camisas
                     }
                     else if categoria_ropa_datos == "Sudaderas"{
                         categoria_ropa = Prenda.CategoriaRopa.sudaderas
                     }
                     
                     let foto1 = datos["foto1"] as? String ?? ""
                     let foto2 = datos["foto2"] as? String ?? ""
                     let foto3 = datos["foto3"] as? String ?? ""
                     let foto4 = datos["foto4"] as? String ?? ""
                    
                    let id_prenda = datosFav["id_prenda"] as? Int ?? -1
                    //let id_usuario = datosFav["id_usuario"] as? String ?? ""
                    let cesta = datosFav["cesta"] as? Bool ?? false
                    let favoritos = datosFav["favoritos"] as? Bool ?? false
                    let talla = datosFav["talla"] as? String ?? ""
                     
                    if id == id_prenda{
                        if favoritos{
                            self.prendasFavoritos.append( Prenda(id: id, nombre: nombre, descripcion: descripcion, precio: precio, color: color, tallas: nil, categoria_sexo: categoria_sexo, categoria_ropa: categoria_ropa, nombresFotos: [foto1,foto2,foto3,foto4], enFavoritos: favoritos, enCesta: cesta, tallaCesta: Prenda.TallaPrenda.init(rawValue: talla)) )
                        }
                        if cesta{
                            self.prendasCesta.append( Prenda(id: id, nombre: nombre, descripcion: descripcion, precio: precio, color: color, tallas: nil, categoria_sexo: categoria_sexo, categoria_ropa: categoria_ropa, nombresFotos: [foto1,foto2,foto3,foto4], enFavoritos: favoritos, enCesta: cesta, tallaCesta: Prenda.TallaPrenda.init(rawValue: talla)) )
                        }
                    }
                        
                        return Prenda(id: id, nombre: nombre, descripcion: descripcion, precio: precio, color: color, tallas: nil, categoria_sexo: categoria_sexo, categoria_ropa: categoria_ropa, nombresFotos: [foto1,foto2,foto3,foto4], enFavoritos: favoritos, enCesta: cesta, tallaCesta: Prenda.TallaPrenda.init(rawValue: talla))
                    }
                }
            }
        }
    }*/
    
    func obtenerValoresAsistente(){
        
        self.db.collection("asistente")
            .whereField("id", isEqualTo: 1)
            .addSnapshotListener{ (querySnapshot, error) in
            guard let documentos_asistente = querySnapshot?.documents else{
                print("No hay documentos del Asistente")
                return
            }
        
                if documentos_asistente.count == 1 && !self.valores.disponible{
                for queryDocumentSnapshot in documentos_asistente{
                    let datos = queryDocumentSnapshot.data()
                    
                    guard let precio_inferior_inicial = Int(datos["precio_inferior"] as! String) else {
                        print(error ?? Error.self)
                        return
                    }
                    
                    guard let precio_superior_inicial = Int(datos["precio_superior"] as! String) else {
                        print(error ?? Error.self)
                        return
                    }
                    
                    var precio_inferior = Int(datos["precio_inferior"] as! String)
                    var precio_superior = Int(datos["precio_superior"] as! String)
                    
                    if precio_inferior_inicial > precio_superior_inicial{
                        let precio = precio_superior
                        precio_superior = precio_inferior
                        precio_inferior = precio
                    }
                    
                    let color: String = datos["color"] as! String
                    let categoria_sexo: String = datos["categoria_sexo"] as! String
                    let categoria_ropa: String = datos["categoria_ropa"] as! String
                    let disponible: Bool = datos["disponible"] as! Bool
                    
                    if disponible{
                        self.valores.id = 1
                        self.valores.sexo = categoria_sexo
                        self.valores.categoria = categoria_ropa
                        self.valores.color = color
                        self.valores.precio = [precio_inferior!, precio_superior!]
                        self.valores.disponible = true
                    }
                }
            }
        }
    }
    
    func salirFiltradas(){
        self.db.collection("asistente")
            .whereField("id", isEqualTo: 1)
            .addSnapshotListener{ (querySnapshot, error) in
                guard (querySnapshot?.documents) != nil else{
                print("No hay documentos del Asistente")
                return
            }
                
            let document = querySnapshot!.documents.first
            document?.reference.updateData([
                "disponible": false
            ])
        }
    }
    
    func obtenerPrendasFiltradas(){
        
        self.prendasFiltradas.removeAll()
        
        for prenda in self.prendas{
            if prenda.consultarColor() == self.valores.color && prenda.consultarPrecio() >= self.valores.precio[0] && prenda.consultarPrecio() <= self.valores.precio[1] && prenda.consultarCategoriaSexo().rawValue == self.valores.sexo && prenda.consultarCategoriaRopa().rawValue == self.valores.categoria{
                self.prendasFiltradas.append(prenda)
            }
        }
    }
        
    func obtenerFavoritosCesta() -> Void{
        
        self.db.collection("favoritos_cesta")
            .whereField("id_usuario", isEqualTo: self.usuarioActual)
            .addSnapshotListener{ (querySnapshot, error) in
            guard let documentos_fav_cesta = querySnapshot?.documents else{
                print("No hay documentos de favoritos_cesta")
                return
            }
            
            for queryDocumentSnapshot in documentos_fav_cesta{
                let datos = queryDocumentSnapshot.data()
                
                let id_prenda = datos["id_prenda"] as? Int ?? -1
                let id_usuario = datos["id_usuario"] as? String ?? ""
                let cesta = datos["cesta"] as? Bool ?? false
                let favoritos = datos["favoritos"] as? Bool ?? false
                let talla = datos["talla"] as? String ?? ""
        
                for prenda in self.prendas{
                    if prenda.consultarID() == id_prenda && id_usuario == self.usuarioActual{
                        if cesta{
                            prenda.ponerCesta()
                            prenda.nuevaTallaCesta(talla: talla)
                        }
                        else{
                            prenda.quitarCesta()
                            prenda.nuevaTallaCesta(talla: talla)
                        }
                        if favoritos{
                            prenda.ponerFavoritos()
                        }
                        else{
                            prenda.quitarFavoritos()
                        }
                    }
                }  
            }
        }
    }
    
    func Favoritos(poner:Bool, idPrenda:Int) -> Void{
        
        self.db.collection("favoritos_cesta")
            .whereField("id_usuario", isEqualTo: self.usuarioActual)
            .whereField("id_prenda", isEqualTo: idPrenda)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print(error)
                } else if querySnapshot!.documents.count != 1 {
                    self.db.collection("favoritos_cesta").addDocument(data: ["id_usuario": self.usuarioActual, "id_prenda": idPrenda, "favoritos": poner, "cesta": false, "talla": ""])
                } else {
                    let document = querySnapshot!.documents.first
                    document?.reference.updateData([
                        "favoritos": poner
                    ])
                }
            }

        for prenda in self.prendas{
            if prenda.consultarID() == idPrenda{
                if poner{
                    prenda.ponerFavoritos()
                }
                else{
                    prenda.quitarFavoritos()
                }
            }
        }
    }
    
    func Cesta(poner:Bool, idPrenda:Int, talla:String) -> Void{
        
        self.db.collection("favoritos_cesta")
            .whereField("id_usuario", isEqualTo: self.usuarioActual)
            .whereField("id_prenda", isEqualTo: idPrenda)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print(err)
                } else if querySnapshot!.documents.count != 1 {
                    self.db.collection("favoritos_cesta").addDocument(data: ["id_usuario": self.usuarioActual, "id_prenda": idPrenda, "favoritos": true, "cesta": poner, "talla": talla])
                } else {
                    let document = querySnapshot!.documents.first
                    document?.reference.updateData([
                        "cesta": poner,
                        "talla": talla
                    ])
                    
                }
            }
        
        for prenda in self.prendas{
            if prenda.consultarID() == idPrenda{
                if poner{
                    prenda.ponerCesta()
                    prenda.nuevaTallaCesta(talla: talla)
                }
                else{
                    prenda.quitarCesta()
                    prenda.nuevaTallaCesta(talla: "")
                }
            }
        }
    
    }
    
    func vaciarCesta(){
        DispatchQueue.main.async {
        let alerta = UIAlertController(title: "Pedido realizado", message: "Se ha enviado el correo con los detalles del pedido !Gracias por comprar en SCARS¡", preferredStyle: .alert)
        
        let confirmar = UIAlertAction(title: "Ok", style: .default) { (_) in
            
            for prenda in self.prendas{
                self.db.collection("favoritos_cesta")
                    .whereField("id_usuario", isEqualTo: self.usuarioActual)
                    .whereField("id_prenda", isEqualTo: prenda.consultarID())
                    .whereField("cesta", isEqualTo: true)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print(err)
                        }
                        else {
                            let document = querySnapshot!.documents.first
                            document?.reference.updateData([
                                "cesta": false
                            ])
                        }
                    }
                if prenda.estaEnCesta(){
                    prenda.quitarCesta()
                    self.actualizarCantidadTalla(prenda: prenda)
                }
            }
        }

        alerta.addAction(confirmar)
        
        // Presentación
        UIApplication.shared.windows.last?.rootViewController?.present(alerta, animated: true)
        }
    }
    
    func actualizarCantidadTalla(prenda:Prenda){
            
        let talla = prenda.consultarTallaCesta()
        let cantidad = prenda.consultarCantidad()
  
        self.db.collection("prendas")
            .whereField("id", isEqualTo: prenda.consultarID())
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print(err)
                }
                else {
                    let document = querySnapshot!.documents.first
                    document?.reference.updateData([
                        "unidades\(talla)": prenda.cantidadTalla(talla: talla) - cantidad
                    ])
                }
            }
        
        prenda.actualizarTalla(talla: Prenda.TallaPrenda.init(rawValue: talla) ?? Prenda.TallaPrenda.NoSeleccionada, cantidad: cantidad)
    }
    
}
