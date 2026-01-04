import CreateML
import Foundation

// 1. Create a data table from your data
let hours: [Double] = [2, 3, 4, 5, 6, 7, 8, 9, 10]
let scoresOG: [Double] = [34, 40, 48, 55, 61, 68, 75, 80, 85]
let scores: [Double] = scoresOG.reversed()

let data = try MLDataTable(dictionary: [
    "Hours_Studied": hours,
    "Test_Score": scores
])

// 2. Train the linear regression model
let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 0)
let regressor = try MLLinearRegressor(trainingData: trainingData, targetColumn: "Test_Score")

// 3. Make predictions on new data
let newHours = try MLDataTable(dictionary: ["Hours_Studied": [10]])
let predictions = try regressor.predictions(from: newHours)

// 4. Print the prediction for 12 hours
if let predictedScore = predictions[0].doubleValue {
    if predictedScore > 100 {
        print("Predicted score for 12 hours of study: 100")
    } else if predictedScore < 0 {
        print("Predicted score for 12 hours of study: 0")
    } else {
        print("Predicted score for 12 hours of study: \(predictedScore)")
    }
}

// Optional: Inverse calculation
// To solve for the required hours for a target score, you can access the model's coefficients

//let modelParams = regressor.modelParameters
//
//if let coef = modelParams["Hours_Studied"]?.doubleValue,
//   let intercept = modelParams["(Intercept)"]?.doubleValue {
//    let targetScore: Double = 98.0
//    let requiredHours = (targetScore - intercept) / coef
//    print("\nTo get \(Int(targetScore)) marks, you would need to study approximately \(String(format: "%.2f", requiredHours)) hours.")
//}
