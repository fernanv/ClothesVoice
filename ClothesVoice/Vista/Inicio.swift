//
//  Inicio.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 5/4/21.
//

import SwiftUI
import AVKit

struct Inicio: View {
   
    // Atributos compartidos por otras vistas
    @Binding var login: Bool
    @Binding var perfil: Bool
    @Binding var favoritos: Bool
    @Binding var cesta: Bool
    @Binding var asistente: Bool
    @ObservedObject var usuario : Usuario
    @ObservedObject var prendasModelData : PrendasModelData
    
    // Atributos privados de la vista
    @State private var menu = false
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                Image("fondo_inicio").ignoresSafeArea()
                
                // CONTENIDO
                VStack{
                    
                    Spacer()
                    EspacioGrande()
                    
                    // MENÚ SUPERIOR DESPLEGABLE
                    Button(action: {self.menu = true}, label: {
                        Image("SCARS")
                    })
                    .padding(.bottom, 50.0)
                
                    EspacioGrande()
                    
                    LoopingPlayer()
                    
                    EspacioGrande()
                    
                    // MENÚ INFERIOR DE NAVEGACIÓN
                    NavMenu(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario)

                }// FIN CONTENIDO
                .fullScreenCover(isPresented: self.$menu){
                    MenuCabecera(login: self.$login, perfil: self.$perfil, favoritos: self.$favoritos, cesta: self.$cesta, asistente: self.$asistente, usuario: self.usuario, prendasModelData: self.prendasModelData)

                }
            }
            .navigationBarHidden(true)
        } // Fin NavigationView
    }
            
    struct Inicio_Previews: PreviewProvider {
        static var usuario = Usuario()
        static var previews: some View {
            Inicio(login: Binding.constant(false), perfil: Binding.constant(false), favoritos: Binding.constant(false), cesta: Binding.constant(false), asistente: Binding.constant(false), usuario: self.usuario, prendasModelData: PrendasModelData())
        }
    }
}

struct LoopingPlayer: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return QueuePlayerUIView(frame: .zero)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Do nothing here
    }
}

class QueuePlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let url = Bundle.main.path(forResource: "video", ofType: "mp4")!
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: url))
        
        // Setup Player
        let player = AVQueuePlayer(playerItem: playerItem)
        self.playerLayer.player = player
        self.playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(self.playerLayer)
        
        // Loop
        self.playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        // Play
        player.play()
        player.isMuted = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) Video has not been implemented")
    }
}

class PlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup Player
        let url = Bundle.main.path(forResource: "video", ofType: "mp4")!
        let player = AVPlayer(url: URL(fileURLWithPath: url))
        self.playerLayer.player = player
        self.playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(self.playerLayer)
        
        // Loop
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(self.rewindVideo(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        // Play
        player.play()
    }
    
    @objc
    func rewindVideo(notification: Notification) {
        self.playerLayer.player?.seek(to: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) Video has not been implemented")
    }
}
