//
//  CalendarDataManager.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/6/24.
//

import Foundation

class CalendarDataManager {
    static let shared = CalendarDataManager()
    private init() {}
    
    func updateMedicationsForDate(_ dateComponents: DateComponents, allMedications: [Med]) -> [Med] {
        // Create calendar with user's timezone
        let calendar = Calendar.current
        
        guard let targetDate = calendar.date(from: dateComponents),
              let _ = calendar.startOfDay(for: targetDate) as Date? else {
            return []
        }
        
        return allMedications.filter { medication in
            guard let frequency = medication.frequency else {
                return false // Skip medications with nil frequency
            }
            
            switch frequency {
            case .daily:
                return true
                
            case .weekly:
                // Check if the target date is a Monday
                return calendar.component(.weekday, from: targetDate) == 2
                
            case .biWeekly:
                // Check if the target date is in an even week
                let weekNumber = calendar.component(.weekOfYear, from: targetDate)
                return weekNumber % 2 == 0
            }
        }
    }
    
    func getMedicationTime(_ medication: Med) -> Date? {
        guard let timeString = medication.time else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = Calendar.current.timeZone
        
        return formatter.date(from: timeString)
    }
    
    func shouldShowMedication(_ medication: Med, for date: Date) -> Bool {
        guard medication.frequency != nil else { return false }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let targetDate = calendar.startOfDay(for: date)
        
        // Don't show future medications
        guard targetDate <= today else { return false }
        
        return true
    }
}
