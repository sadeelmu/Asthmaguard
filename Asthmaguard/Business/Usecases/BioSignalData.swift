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
              completion(false)
              return
          }

          let readDataTypes: Set<HKObjectType> = [
              HKObjectType.quantityType(forIdentifier: .heartRate)!,
              HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,
              HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!
          ]

          healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { (success, error) in
              if let error = error {
                  print("HealthKit authorization error:", error.localizedDescription)
                  completion(false)
                  return
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

