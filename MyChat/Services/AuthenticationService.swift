//
//  AuthenticationService.swift
//  MyChat
//
//  Created by Дмитрий Писляков on 16.06.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthenticationService {
    
    static let shared = AuthenticationService()
    private let auth = Auth.auth()
    
    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let email = email,
              let password = password
        else {
            completion(.failure(AuthError.notFilled))
            return
        }

        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func googleLogin(user: GIDGoogleUser!, error: Error!, completion: @escaping (Result<User, Error>) -> Void) {
        
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let auth = user?.authentication,
              let idToken = auth.idToken
        else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
        
        Auth.auth().signIn(with: credential) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword)
        else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthError.passwordNotMatch))
            return
        }
        
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
}
