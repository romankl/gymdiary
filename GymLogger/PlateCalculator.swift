//
// Created by Roman Klauke on 09.04.16.
// Copyright (c) 2016 Roman Klauke. All rights reserved.
//

import Foundation


struct PlateCalculator {
    private var weightUnit: WeightUnit
    private var inputWeight: Float


    init(currentWeightUnit: WeightUnit, inputWeight: Float) {
        self.weightUnit = currentWeightUnit
        self.inputWeight = inputWeight
    }

    mutating func calculatePlates() -> [String] {
        var plates = weightUnit.availablePlates()
        plates.sortInPlace(>)

        let smallPlate = plates.last
        var calculatedPlates = [Float]()
        var loop = true
        while loop {
            for i in 0 ... plates.count {
                if inputWeight - plates[i] > 0 {
                    inputWeight = inputWeight - plates[i]
                    calculatedPlates.append(plates[i])

                    if (inputWeight - smallPlate! < 0) {
                        loop = false
                        break
                    }
                } else {
                    continue
                }
            }
        }


        var result = [""]
        for i in 0 ... calculatedPlates.count {
            let currentPlate = calculatedPlates[i]
            let requiredPlates = try! calculatedPlates.countElement(currentPlate)
            result.append("\(requiredPlates) x \(currentPlate)")
        }

        return result
    }
}
