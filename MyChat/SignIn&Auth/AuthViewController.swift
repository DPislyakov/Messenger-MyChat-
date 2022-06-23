//
//  ViewController.swift
//  MyChat
//
//  Created by Дмитрий Писляков on 09.06.2022.
//

import UIKit
import GoogleSignIn
import Firebase
import GoogleSignInSwift

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: UIImage(named: "logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroungColor: .buttonBlack())
    
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backgroungColor: .white, isShadow: true)
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroungColor: .white, isShadow: true)
    
    let signUpVC = SignUpViewController()
    let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleButton.customizeGoogleButton()
        view.backgroundColor = .white
        setupConstraints()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        signUpVC.delegate = self
        loginVC.delegate = self
        
    }
    
    @objc private func emailButtonTapped() {
        present(signUpVC, animated: true, completion: nil)
        print(#function)
    }
    
    @objc private func loginButtonTapped() {
        present(loginVC, animated: true, completion: nil)
        print(#function)
    }
    
    @objc private func googleButtonTapped() {
        
    }
}


// MARK: Setup Constraints
extension AuthViewController {
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
    }
}

extension AuthViewController: AuthNavigationDelegate {
    
    func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true, completion: nil)
    }
    
}

extension AuthViewController {
    
    func sign() {
        
        guard let clientId = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientId)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            AuthenticationService.shared.googleLogin(user: user, error: error) { result in
                switch result {
                    
                case .success(let user):
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                            
                        case .success(let muser):
                            self.showAlert(with: "Успешно", and: "Вы зарегистрированы") {
                                let mainTabBar = MainTabBarController(currentUser: muser)
                                mainTabBar.modalPresentationStyle = .fullScreen
                                self.present(mainTabBar, animated: true, completion: nil)
                            }
                        case .failure(let error):
                            self.showAlert(with: "Успешно", and: "Вы зарегистрированы") {
                                self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                            }
                        }
                    }
                case .failure(let error):
                    self.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: SwiftUI
import SwiftUI

struct AuthVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = AuthViewController()
        
        func makeUIViewController(context: Context) -> AuthViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
