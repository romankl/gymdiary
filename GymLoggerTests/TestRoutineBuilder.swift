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
                builder.deleteObject()
                expect(realm.objects(WorkoutRoutine).count).to(equal(0))
            }

            it("should update the routine") {
                let routineName = "dummy"

                let builder = WorkoutRoutineBuilder(realm: realm)
                builder.createNewRoutine(routineName: routineName)
                builder.createNewObject()

                expect(realm.objects(WorkoutRoutine).count).to(equal(1))

                let update = WorkoutRoutineBuilder(routineName: routineName, realm: realm)
                expect(update).toNot(beNil())
                expect(update.getRawExercises()).toNot(beNil())
                expect(update.getRawExercises()!.count).to(equal(0))

                let eh = ExerciseHandler(realmToUse: realm)
                eh.createNewExercise("exe", bodyPart: .Legs, type: .Weight)

                update.addExercise(eh.getRawExercise()!)
                expect(update.getRawExercises()!.count).to(equal(1))

                update.deleteObject()
            }

            it("should simulate a dummy run") {
                let builder = WorkoutRoutineBuilder(realm: realm)
                builder.createEmptyRoutine()

                expect(builder).toNot(beNil())
                expect(builder.getRawRoutine()).toNot(beNil())

                let eh = ExerciseHandler(realmToUse: realm)
                eh.createNewExercise("exe1", bodyPart: .Legs, type: .Weight)

                builder.addExercise(eh.getRawExercise()!)
                builder.createNewObject()
                expect(builder.getRawExercises()?.count).to(equal(1))

                expect(builder.getExerciseAtIndex(0)).toNot(beNil())
                expect(builder.getExerciseAtIndex(99)).to(beNil())

                builder.removeExerciseAtIndex(0, withTransaction: true)
                expect(builder.getRawExercises()?.count).to(equal(0))
            }
        }
    }
}
