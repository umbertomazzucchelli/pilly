//
//  AuthManager.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/6/24.
//

import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private var currentUser: User?
    
    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser != nil    }
    
    typealias AuthStateCallback = (Bool) -> Void
    private var authStateCallbacks: [AuthStateCallback] = []
    
    func configure() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }
            
            if let user = user {
                // User is signed in
                self.handleUserSignIn(user)
            } else {
                // User is signed out
                self.handleUserSignOut()
            }
        }
    }
    
    private func handleUserSignIn(_ user: FirebaseAuth.User) {
        // Update Firestore user data
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching user data: \(error)")
                return
            }
            
            // Notify all callbacks of signed in state
            DispatchQueue.main.async {
                self?.notifyAuthStateCallbacks(true)
            }
        }
    }
    
    private func handleUserSignOut() {
        currentUser = nil
        DispatchQueue.main.async {
            self.notifyAuthStateCallbacks(false)
        }
    }
    
    func addAuthStateCallback(_ callback: @escaping AuthStateCallback) {
        authStateCallbacks.append(callback)
    }
    
    private func notifyAuthStateCallbacks(_ isLoggedIn: Bool) {
        authStateCallbacks.forEach { $0(isLoggedIn) }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
            return
        }
        
        user.getIDTokenForcingRefresh(true) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
}
