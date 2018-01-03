//
//  Alerts.swift
//  Kesley-Challenge-iOS-Agap2IT
//
//  Created by Kesley Ribeiro on 3/Jan/18.
//  Copyright © 2018 Kesley Ribeiro. All rights reserved.
//

import Foundation
import SwiftMessages

class Alerts {
    
    /*
        Método que mostra um alerta personalizado ao usuário
        - 1 vai mostrar alerta do tipo warning - yellow
        - 2 vai mostrar alerta do tipo error - red
        - 3 vai mostrar alerta do tipo success - green
     */

    func exibirAlertaPersonalizado(_ mensagem: String, tipoAlerta: Int) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        
        var config = SwiftMessages.defaultConfig
        
        switch tipoAlerta {
            
        case 1:
            
            // Define o tipo e o estilo do alerta
            view.configureTheme(.warning)
            
            // Add a drop shadow.
            view.configureDropShadow()
            
            // Slide up from the bottom.
            //config.presentationStyle = .Bottom
            
            // Define por quanto tempo o alerta aparece na tela
            config.duration = .seconds(seconds: 3)
            
            // Define o título do alerta
            view.configureContent(title: "Attention!", body: mensagem)
            
            // Exibe o alerta
            SwiftMessages.show(config: config, view: view)
            
        case 2:
            
            // Define o tipo e o estilo do alerta
            view.configureTheme(.error)
            
            // Add a drop shadow.
            view.configureDropShadow()
            
            // Slide up from the bottom.
            //config.presentationStyle = .Bottom
            
            // Define por quanto tempo o alerta aparece na tela
            config.duration = .seconds(seconds: 3)
            
            // Define o título do alerta
            view.configureContent(title: "Error!", body: mensagem)
            
            // Exibe o alerta
            SwiftMessages.show(config: config, view: view)
            
        case 3:
            
            // Define o tipo e o estilo do alerta
            view.configureTheme(.success)
            
            // Add a drop shadow.
            view.configureDropShadow()
            
            // Dim the background like a popover view. Hide when the background is tapped.
            //config.dimMode = .Color(color: UIColor.redColor(), interactive: true) //.Gray(interactive: true)
            
            // Define por quanto tempo o alerta aparece na tela
            config.duration = .seconds(seconds: 3)
            
            view.configureContent(title: "Success!", body: mensagem)
            
            // Exibe o alerta
            SwiftMessages.show(config: config, view: view)
            
        default: break
        }
    }
}


