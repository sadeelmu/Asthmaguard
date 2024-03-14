//
//  SurveyScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 9/03/2024.
//

import Foundation
import SwiftUI


func ImportanceQuestion( _ title : String ) -> MultipleChoiceQuestion {
    return MultipleChoiceQuestion(title: title, answers: [ "1" , "2", "3"], tag: TitleToTag(title))
}

let SurveyScreen = Survey([
        InlineMultipleChoiceQuestionGroup(title: "Please answer the following questions. 1 is the lowest and 3 is the highest.",
                                      questions: [
                                        
                                        ImportanceQuestion("How severly does DUST trigger your asthma?"),
                                        ImportanceQuestion("How severely do RESPIRATORY INFECTIONS COLDS trigger your asthma?"),
                                        ImportanceQuestion("How severly does ALLERGIES trigger your asthma?"),
                                        ImportanceQuestion("How severly does EXCERISE trigger your asthma?"),
                                        ImportanceQuestion("How severly does PETS trigger your asthma?"),

                                      ],
                                      tag: "importance-what-improvements"),
],
version: "001")
