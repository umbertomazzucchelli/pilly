//
//  DataSyncManager.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/6/24.
//

import FirebaseFirestore
import FirebaseAuth

class DataSyncManager {
    static let shared = DataSyncManager()
    private init() {}
    
    private let db = Firestore.firestore()
    private var listeners: [String: ListenerRegistration] = [:]
    private let syncQueue = DispatchQueue(label: "com.pilly.datasync", qos: .userInitiated)
    
    func fetchMedications(completion: @escaping (Result<[Med], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "DataSync", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        let medicationsRef = db.collection("users").document(userId).collection("medications")
        medicationsRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let medications = snapshot?.documents.compactMap { document -> Med? in
                let data = document.data()
                let startTimestamp = data["startDate"] as? Timestamp
                return Med(
                    id: document.documentID,
                    title: data["title"] as? String,
                    amount: data["amount"] as? String,
                    dosage: Dosage(rawValue: (data["dosage"] as? String) ?? ""),
                    frequency: Frequency(rawValue: (data["frequency"] as? String) ?? ""),
                    time: data["time"] as? String,
                    isChecked: data["isChecked"] as? Bool ?? false,
                    startDate: startTimestamp?.dateValue()
                )
            } ?? []
            
            completion(.success(medications))
        }
    }
    
    func updateMedicationStatus(medId: String, isChecked: Bool, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "DataSync", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        syncQueue.async {
            let medicationRef = self.db.collection("users").document(userId)
                .collection("medications").document(medId)
            
            medicationRef.updateData([
                "isChecked": isChecked,
                "lastModified": FieldValue.serverTimestamp()
            ]) { error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func deleteMedication(medicationId: String, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "DataSync", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        syncQueue.async {
            let medicationRef = self.db.collection("users").document(userId)
                .collection("medications").document(medicationId)
            
            medicationRef.delete { error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func startMedicationSync(_ completion: @escaping ([Med]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let listener = db.collection("users").document(userId)
            .collection("medications")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching medications: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let medications = documents.compactMap { document -> Med? in
                    let data = document.data()
                    return Med(
                        id: document.documentID,
                        title: data["title"] as? String,
                        amount: data["amount"] as? String,
                        dosage: Dosage(rawValue: (data["dosage"] as? String) ?? ""),
                        frequency: Frequency(rawValue: (data["frequency"] as? String) ?? ""),
                        time: data["time"] as? String,
                        isChecked: data["isChecked"] as? Bool ?? false
                    )
                }
                
                completion(medications)
            }
        
        listeners["medications"] = listener
    }
    
    func stopMedicationSync() {
        listeners["medications"]?.remove()
        listeners.removeValue(forKey: "medications")
    }
    
    deinit {
        listeners.values.forEach { $0.remove() }
        listeners.removeAll()
    }
}
