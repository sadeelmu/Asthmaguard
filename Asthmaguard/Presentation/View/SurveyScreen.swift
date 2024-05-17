//
//  SurveyScreen.swift
//  Asthmaguard
//
//  Created by Sadeel Muwahed on 9/03/2024.
//

import Foundation
import SwiftUI


func ImportanceQuestion( _ title : String ) -> MultipleChoiceQuestion {
    return MultipleChoiceQuestion(title: title, answers: [ "1" , "2", "3", "4", "5"], tag: TitleToTag(title))
}

let SurveyScreen = Survey([
    InlineMultipleChoiceQuestionGroup(title: "Please answer the following questions. 1 is the lowest and 5 is the highest.",
                                      questions: [
                                        
                                        ImportanceQuestion("How severly does POLLEN trigger your asthma?"),
                                        ImportanceQuestion("How severely does AIR QUALITY trigger your asthma?"),
                                        ImportanceQuestion("How severly does COLD TEMPERATURE trigger your asthma?"),
                                        ImportanceQuestion("How severly does HUMIDITY trigger your asthma?"),
                                        ImportanceQuestion("How severly does CLOUDOVER trigger your asthma?"),
                                        ImportanceQuestion("How severe does your HEART RATE INCREASE when you have an asthma attack?"),
                                        ImportanceQuestion("How severe does your RESPIRATORY RATE INCREASE when you have an asthma attack?"),
                                        ImportanceQuestion("How severe does your BLOOD OXYGEN LEVEL DECREASE when you have an asthma attack?"),
                                      ],
                                      tag: "importance-what-improvements"),
],
                          version: "001")
