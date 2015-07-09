//
//  ColorServiceManager.swift
//  ConnectedColors
//
//  Created by Leonardo Geus on 04/07/15.
//  Copyright (c) 2015 Leonardo Geus. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ColorServiceManagerDelegate { //cria um delegate para avisar a UI dos eventos de conexão
    
    func connectedDevicesChanged(manager : ColorServiceManager, connectedDevices: [String])   //mostra quem conectou na UI
    func colorChanged(manager : ColorServiceManager, colorString: String) //mostra que cor foi recebida do outro dispositivo
    
}

class ColorServiceManager : NSObject {
    
    private let ColorServiceType = "shake-it-out"  //nome do servico
    private let myPeerId = MCPeerID(displayName: UIDevice.currentDevice().name)  //nome do dispositivo
     let serviceAdvertiser : MCNearbyServiceAdvertiser //classe que faz o multipeer
    var serviceBrowser : MCNearbyServiceBrowser //classe que procura outros devices para multipeer
    var delegate : ColorServiceManagerDelegate?
    var collectionView = CollectionInicial()
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: ColorServiceType)  //inicia a classe serviceAdvertiser
        
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: ColorServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self //chama um delegate de extensão pra tratar a informaçao
        //self.serviceAdvertiser.startAdvertisingPeer() //inicia a classe
        
        self.serviceBrowser.delegate = self //chama o delegate do servicebrowser
//        self.serviceBrowser.startBrowsingForPeers() //e inicia ele para procurar dispositivos
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    lazy var session: MCSession = {     //cria uma inicializaçao lazy(so cria qnd precisa dele, nao inicia de cara) para criar uma secao com o outro dispositivo
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        session?.delegate = self
        return session
        }()
    var oi = 1
    func sendColor(colorName : String) {  //funcao para mandar a cor
        NSLog("%@", "sendColor: \(colorName)")
        
        if session.connectedPeers.count > 0 { //manda para o lazy session acima
            var error : NSError?
            if !self.session.sendData(colorName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error) { //manda a colorame que peguei na interface para o outro dispositivo atraves de toPeers   "colorName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)"= data que envio
                NSLog("%@", "\(error)")
            }
        }
        
    }
    
}

extension ColorServiceManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session) //da true para qualquer pessoa que queira parear, nao barra ngn, se quiser da pra modificar isso por aqui
    }
    
}

extension ColorServiceManager : MCNearbyServiceBrowserDelegate {
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")  //funcao de erro se nao conseguir ligar o browser
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        NSLog("%@", "foundPeer: \(peerID)")    //funcao de achou dispositivo
        NSLog("%@", "invitePeer: \(peerID)")   //funcao de estou pareando
        browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        NSLog("%@", "lostPeer: \(peerID)")     //se perdeu a conexao do browser
    }
    
}

extension MCSessionState {
    
    func stringValue() -> String {    //cria um valor de string para mostrar o que ocorre para iniciar  a secao
        switch(self) {
        case .NotConnected: return "NotConnected"  //se nao conectar
        case .Connecting: return "Connecting" //...
        case .Connected:
            DataManager.instance.mandarTransacao = true
            return "Connected" //...
        default: return "Unknown"
        }
    }
    
}

extension ColorServiceManager : MCSessionDelegate {   //del egate do iniciar seção, trata toda a informaçao com o outro dispositivo
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) { //joga para a extension MCSessionSate e diz quando mudou de estado
        NSLog("%@", "peer \(peerID) didChangeState: \(state.stringValue())")
        self.delegate?.connectedDevicesChanged(self, connectedDevices: session.connectedPeers.map({$0.displayName})) //manda para o delegate do topo dessa página. Detalhe que tem o $0.displayName que pega a primeira conexão
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) { //aqui trata qnd recebe dados
        NSLog("%@", "didReceiveData: \(data.length) bytes")
        let str = NSString(data: data, encoding: NSUTF8StringEncoding) as! String //cria uma string com o nome do que foi recebido
        NSLog("AQUIII \(str)")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let peerUser = "\(peerID)"
        let userInfo = ["teste":str,"peerID":peerUser]
        
        
        notificationCenter.postNotificationName("receberData", object: nil, userInfo: userInfo)
        
        //collectionView.showSimpleAlertWithTitle("recebeu", message: "\(str)", viewController: )
        
        DataManager.instance.desligarServico()

        self.delegate?.colorChanged(self, colorString: str) //manda para a funçao no topo da página que notifica a ui que o outro dispositivo quer mudar a cor
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
}