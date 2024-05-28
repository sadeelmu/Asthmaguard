import Foundation
import SwiftUI
import Charts
import CoreLocation

@available(iOS 17.0, *)
struct AsthmaThreatChart: View {
    @State private var totalWeightedSeverity: Double = 0.0
    @State private var biosignalRisk: Double = 0.0
    @State private var environmentalRisk: Double = 0.0
    @State private var showHighThreatAlert: Bool = false
    @State private var showVeryHighThreatActionSheet: Bool = false
    @State private var navigateToBreathingExercises: Bool = false

    @State var asthmathreat: [AsthmaThreat] = [
        .init(title: "Biosignals", risks: 0.2),
        .init(title: "Environmental", risks: 0.25),
        .init(title: "Normal", risks: 0.55)
    ]

    private let asthmaThreatCalculatorUseCase = AsthmaThreatCalculatorUseCase()
    private let locationManager = LocationManager.shared

    func updateAsthmaThreat() {
        asthmaThreatCalculatorUseCase.fetchDataAndCalculateAsthmaSeverity()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.biosignalRisk = 0.2
            self.environmentalRisk = 0.25
            self.totalWeightedSeverity = 0.45

            if totalWeightedSeverity > 0.75 {
                showVeryHighThreatActionSheet = true
            } else if totalWeightedSeverity > 0.50 {
                showHighThreatAlert = true
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 5) {
                    Text("Dashboard")
                        .font(Font.custom("Poppins-Bold", size: 18))
                        .padding(.all)

                    let chartColors: [Color] = [
                        .pink.opacity(0.5), .pink, .blue
                    ]

                    Text("Asthma Threat: \(totalWeightedSeverity * 100, specifier: "%.1f")%")
                        .font(Font.custom("Poppins-Bold", size: 26))

                    Chart(asthmathreat) { asthmathreat in
                        SectorMark(
                            angle: .value(
                                Text(asthmathreat.title),
                                asthmathreat.risks
                            ),
                            innerRadius: .ratio(0.6),
                            angularInset: 0.8
                        )
                        .cornerRadius(4)
                        .foregroundStyle(by: .value("Threats", asthmathreat.title))
                    }.frame(width: 300, height: 250)
                    .chartForegroundStyleScale(domain: .automatic, range: chartColors)

                    Spacer()
                    VStack(spacing: 10) {
                        NavigationLink(destination: HistoricalDataView(bioSignal: "Respiratory Rate")) {
                            CustomBioData(bioSignal: "🫁 Respiratory Rate", time: "7:23 PM", data: "20 breaths/min")
                        }
                        NavigationLink(destination: HistoricalDataView(bioSignal: "Heart Rate")) {
                            CustomBioData(bioSignal: "🫀 Heart Rate", time: "7:25 PM", data: "90 BPM")
                        }
                        NavigationLink(destination: HistoricalDataView(bioSignal: "Blood Oxygen")) {
                            CustomBioData(bioSignal: "🩸 Blood Oxygen", time: "7:30 PM", data: "97.5%")
                        }
                    }
                    Spacer()
                }
                .onAppear {
                    // Request location access
                    locationManager.requestLocationAccess()
                    locationManager.startUpdatingLocation()
                    
                    // Request HealthKit access
                    BioSignalData.requestHealthDataAccessIfNeeded { success in
                        if success {
                            updateAsthmaThreat()
                        } else {
                            print("HealthKit authorization failed")
                        }
                    }
                }
                .alert(isPresented: $showVeryHighThreatActionSheet) {
                    Alert(
                        title: Text("High asthma threat detected"),
                        primaryButton: .default(Text("Contact emergency contact")) {
                            // Handle contact emergency action

                        },
                        secondaryButton: .cancel(Text("Dismiss"))
                    )
                }
                .actionSheet(isPresented: $showHighThreatAlert) {
                    ActionSheet(
                        title: Text("Very High Asthma threat detected!"),
                        message: Text("Would you like to start breathing exercises?"),
                        buttons: [
                            .default(Text("Start")) {
                                navigateToBreathingExercises = true
                            },
                            .default(Text("Contact emergency contact")) {
                                // Handle contact emergency action
                                
                            },
                            .cancel(Text("Dismiss"))
                        ]
                    )
                }
            }
            .background(
                NavigationLink(
                    destination: BreathingExerciseScreen(),
                    isActive: $navigateToBreathingExercises
                ) {
                    EmptyView()
                }
            )
        }
    }
}
