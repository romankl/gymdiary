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

        var result = [Float]()

        for i in 0 ... plates.count {
            if inputWeight - plates[i] > 0 {
                inputWeight = inputWeight - plates[i]
                result.append(plates[i])
            } else {
                break
            }
        }

        return [""]
    }
}
