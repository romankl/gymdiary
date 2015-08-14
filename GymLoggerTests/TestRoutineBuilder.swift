import Quick
import Nimble

import RealmSwift
import GymLogger

class TestRoutineBuilder: QuickSpec {
    override func spec() {
        var realm: Realm!
        beforeSuite {
            realm = Realm(inMemoryIdentifier: "test-exercise-handler")
        }

        context("Build basic routine") {
            it("should test the inits") {
                let builder = WorkoutRoutineBuilder(realm: realm)
                expect(builder).toNot(beNil())
                expect(realm.objects(WorkoutRoutine).count).to(equal(0))
            }

            it("should create a basic routine") {
                let builder = WorkoutRoutineBuilder(realm: realm)
                expect(builder.getRawRoutine()).to(beNil())
                builder.createEmptyRoutine()

                expect(builder.getRawRoutine()).toNot(beNil())
                expect(realm.objects(WorkoutRoutine).count).to(equal(0))
                expect(builder.exercisesInWorkout()).to(equal(0))

                expect(builder.getWorkoutRoutineName()?.isEmpty).to(beTrue())
                builder.setWorkoutRoutineName("testWorkout")
                expect(builder.getWorkoutRoutineName()?.isEmpty).to(beFalse())
                expect(builder.getWorkoutRoutineName()).to(equal("testWorkout"))
                expect(builder.getRawExercises()!.count).to(equal(0))

                builder.createNewObject()

                expect(realm.objects(WorkoutRoutine).count).to(equal(1))
            }
        }
    }
}
