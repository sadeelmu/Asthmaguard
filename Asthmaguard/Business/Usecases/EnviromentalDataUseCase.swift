//
//  EnviromentalDataUseCase.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 29/04/2024.
//

import Foundation

struct AsthmaSurvey {
    var exerciseActivitySeverity: Double
    var age: Int
    var dustSeverity: Double
    var seasonalAllergiesSeverity: Double
    var weatherChangesSeverity: Double
    var coldAirSeverity: Double
    var pollenSeverity: Double
    var smogSeverity: Double
    var rainSeverity: Double
    var humiditySeverity: Double
    var hayFever: Bool
    var typePollen: String
}

func calculateAsthmaAttackThreat(survey: AsthmaSurvey) -> Double {
    var weightSmog = 0.1
    weightSmog = weightSmog / 11.0
    var weightHumidity = 0.1
    weightHumidity = weightHumidity / 11.0
    var weightRain = 0.2
    weightRain = weightRain / 11.0
    var algorithm = 0.3
    algorithm = algorithm / 11.0
    var weightDust = 0.1
    weightDust = weightDust / 11.0
    var weightSeasonalAllergies = 0.1
    weightSeasonalAllergies = weightSeasonalAllergies / 11.0
    var weightExerciseActivity = 0.1
    weightExerciseActivity = weightExerciseActivity / 11.0
    var weightWeatherChanges = 0.1
    weightWeatherChanges = weightWeatherChanges / 11.0
    var weightColdAir = 0.1
    weightColdAir = weightColdAir / 11.0
    var weightPollen = 0.1
    weightPollen = weightPollen / 11.0

    let weightedSeverity = algorithm +
        survey.dustSeverity * weightDust +
        survey.exerciseActivitySeverity * weightExerciseActivity +
        survey.weatherChangesSeverity * weightWeatherChanges +
        survey.coldAirSeverity * weightColdAir +
        survey.pollenSeverity * weightPollen +
        survey.smogSeverity * weightSmog +
        survey.rainSeverity * weightRain +
        survey.humiditySeverity * weightHumidity
    
    // Ensure threat percentage is within range
    let threatPercentage = max(0.0, min(1.0, weightedSeverity))
    
    // Convert to percentage
    return threatPercentage * 100.0
}
