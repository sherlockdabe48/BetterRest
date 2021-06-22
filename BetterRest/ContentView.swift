//
//  ContentView.swift
//  BetterRest
//
//  Created by Antarcticaman on 22/6/2564 BE.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    var hoursLabel: String {
        return "\(Int(sleepAmount))"
    }
    
    var minutesLabel: String {
        let intSleepAmount = Int(sleepAmount)
        let doubleSleepAmount = Double(intSleepAmount)
        let remainMinutes = sleepAmount.truncatingRemainder(dividingBy: doubleSleepAmount)
        
        switch remainMinutes {
        case 0.0:
            return ""
        case 0.25:
            return "15 minutes"
        case 0.5:
            return "30 minutes"
        case 0.75:
            return "45 minutes"
        default: return ""
        }
    }
    
    var body: some View {
        NavigationView {
                Form {
                    VStack(alignment: .leading) {
                        Text("Reccomended Bedtime:")
                            .font(.subheadline)
                        Text("\(calculatedBedTime)")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Section {
                        Text("When you want to wake up?")
                            .font(.headline)
                    
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                        
                    Section(header: Text("Desired amount of sleep")) {
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(hoursLabel) hours \(minutesLabel)")
                        }
                    }
                    
                    Section(header: Text("Daily coffee intake")) {
                        Picker("Number of coffee", selection: $coffeeAmount) {
                            ForEach(0..<20) { numberOfCoffee in
                                if numberOfCoffee == 0 {
                                    Text("No coffee💧")
                                } else {
                                    Text("☕️ x \(numberOfCoffee)")
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("BetterRest ☕️", displayMode: .inline)
            }
        }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 6
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    
    
var calculatedBedTime: String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
            }
        catch {
            return "Sorry, calculating sleep time error."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
