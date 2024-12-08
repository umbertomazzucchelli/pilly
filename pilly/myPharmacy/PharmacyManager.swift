//
//  PharmacyManager.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/7/24.
//

import FirebaseAuth
import FirebaseFirestore
import MapKit

class PharmacyManager {
    static let shared = PharmacyManager()
    private init() {}
    
    private let db = Firestore.firestore()
    
    struct FavoritePharmacy: Codable {
        let name: String
        let address: String
        let latitude: Double
        let longitude: Double
        let phone: String?
    }
    
    func saveFavoritePharmacy(pharmacy: MKMapItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "PharmacyManager", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        let pharmacyData: [String: Any] = [
            "name": pharmacy.name ?? "Unknown Pharmacy",
            "address": pharmacy.placemark.formattedAddress ?? "No address available",
            "latitude": pharmacy.placemark.coordinate.latitude,
            "longitude": pharmacy.placemark.coordinate.longitude,
            "phone": pharmacy.phoneNumber ?? "",
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(userId).updateData([
            "favoritePharmacy": pharmacyData
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                // Successfully saved, complete with success
                completion(.success(()))
            }
        }
    }
    
    func getFavoritePharmacy(completion: @escaping (Result<FavoritePharmacy?, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "PharmacyManager", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data(),
                  let pharmacyData = data["favoritePharmacy"] as? [String: Any] else {
                completion(.success(nil))
                return
            }
            
            let pharmacy = FavoritePharmacy(
                name: pharmacyData["name"] as? String ?? "Unknown Pharmacy",
                address: pharmacyData["address"] as? String ?? "No address available",
                latitude: pharmacyData["latitude"] as? Double ?? 0.0,
                longitude: pharmacyData["longitude"] as? Double ?? 0.0,
                phone: pharmacyData["phone"] as? String
            )
            
            completion(.success(pharmacy))
        }
    }
}

extension Notification.Name {
    static let favoritePharmacyUpdated = Notification.Name("favoritePharmacyUpdated")
}
