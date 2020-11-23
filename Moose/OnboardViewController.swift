//
//  OnboardViewController.swift
//  moose
//
//  Created by Samuel Brasileiro on 23/11/20.
//

import SwiftUI
import UIKit
protocol onboardDelegate{
    func presentNextVC()
}
class OnboardViewController: UIViewController, onboardDelegate {
    var onboardController: UIHostingController<OnboardView>?
    
    func presentNextVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Main")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardController = UIHostingController(rootView: OnboardView(delegate: self))
        onboardController?.view.backgroundColor = .clear
        self.view.backgroundColor = .systemGray6
        
        onboardController?.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(onboardController!.view)
        onboardController!.view.backgroundColor = .clear
        let constraints = [
            onboardController!.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            onboardController!.view.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            onboardController!.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            onboardController!.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            onboardController!.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
}

struct OnboardView: View{
    let color = Color(red: 0xd1/0xff, green: 0x78/0xff, blue: 0x30/0xff)
    var delegate: onboardDelegate?
    var body: some View{
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Text("Bem vindo ao")
                    .font(.largeTitle)
                    .bold()
                Text("Moose.")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(color)
            }.padding()
            .padding(.top, 40)
            Spacer()
            VStack(spacing: 40){
                HStack{
                    Image(systemName: "camera.viewfinder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                    VStack(alignment: .leading){
                        Text("Habilite a câmera")
                            .font(.headline)
                            .bold()
                        Text("Permita que o aplicativo utilize a câmera.")
                            .font(.subheadline)
                            .foregroundColor(Color(.systemGray))
                        
                    }
                }.frame(maxWidth: 300)
                
                HStack{
                    Image(systemName: "text.below.photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                    VStack(alignment: .leading){
                        Text("Selecione uma obra")
                            .font(.headline)
                            .bold()
                        Text("Escolha uma das obras do acervo de Harvard Art Museum.")
                            .font(.subheadline)
                            .foregroundColor(Color(.systemGray))
                        
                    }
                }.frame(maxWidth: 300)
                HStack{
                    Image(systemName: "camera.metering.unknown")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                    VStack(alignment: .leading){
                        Text("Monte seu museu")
                            .font(.headline)
                            .bold()
                        Text("Aponte para uma parede lisa e veja a obra escolhida.")
                            .font(.subheadline)
                            .foregroundColor(Color(.systemGray))
                        
                    }
                }.frame(maxWidth: 300)
            }
            
            Spacer()
            Button(action: {
                delegate?.presentNextVC()
            }){
                Text("Começar")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 100.0)
                    .padding()
                    .background(color)
                    .cornerRadius(14)
                    .padding(.bottom, 40)
            }
            
        }
        .background(Color.clear)
    }
}

struct OnboardView_Previews: PreviewProvider{
    
    static var previews: some View{
        OnboardView()
    }
}
