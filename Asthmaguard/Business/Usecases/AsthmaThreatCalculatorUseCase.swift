//
//  AsthmaThreatCalculatorUseCase.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 06/05/2024.
//

import Foundation
import CoreLocation

struct AsthmaSeverity {
    var repositoryRateSeverity: Double
    var bloodOxygenSeverity: Double
    var heartRateSeverity: Double
    var pollutionSeverity: Double
    var pollenSeverity: Double
}

func AsthmaSeverityCalculator(){
    //Use functions defined in Enviromental usecase to get enviromental data and parse it
    
    //Use functions defined in BioSignalDataUseCase to get biosignal data
}

