//
//  BioSignalDataUseCase.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 29/04/2024.
//

import Foundation
import HealthKit

class BioSignalData {
    
    static let healthStore: HKHealthStore = HKHealthStore()
    
    // MARK: - Authorization

    class func requestHealthDataAccessIfNeeded(completion: @escaping (_ success: Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("Health data is not available!")
        }
        
        let readDataTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
            HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
            HKObjectType.quantityType(forIdentifier: .respiratoryRate)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { (success, error) in
            if let error = error {
                print("requestAuthorization error:", error.localizedDescription)
            }
            
            if success {
                print("HealthKit authorization request was successful!")
            } else {
                print("HealthKit authorization was not successful.")
            }
            
            completion(success)
        }
    }
    
    // MARK: - Fetch Vital Signs
    
    class func fetchHeartRateSamples(completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            completion(samples as? [HKQuantitySample], error)
        }
        
        healthStore.execute(query)
    }
    
    class func fetchOxygenSaturationSamples(completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        let oxygenSaturationType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: oxygenSaturationType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            completion(samples as? [HKQuantitySample], error)
        }
        
        healthStore.execute(query)
    }
    
    class func fetchRespiratoryRateSamples(completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        let respiratoryRateType = HKObjectType.quantityType(forIdentifier: .respiratoryRate)!
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: respiratoryRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            completion(samples as? [HKQuantitySample], error)
        }
        
        healthStore.execute(query)
    }
}

