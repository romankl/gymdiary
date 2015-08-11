import Quick
import Nimble

import GymLogger
import RealmSwift

class TestExerciseHandler: QuickSpec {
    override func spec() {
        var realm: Realm!
        beforeSuite {
            realm = Realm(inMemoryIdentifier: "test-exercise-handler")
        }

        describe("create exercises") {
            it("should create a new exercise") {
                let handler = ExerciseHandler(realmToUse: realm)
                handler.createNewExercise("test", bodyPart: .Abs, type: .Weight)

                expect(handler.getExerciseType()).to(equal(ExerciseType.Weight))
                expect(handler.getBodyPart()).toNot(equal(BodyParts.Chest))
                expect(handler.getBodyPart()).toNot(equal(BodyParts.Legs))
                expect(handler.getBodyPart()).to(equal(BodyParts.Abs))

                handler.setBodyPart(BodyParts.Legs)
                expect(handler.getBodyPart()).to(equal(BodyParts.Legs))

                handler.setExerciseType(.Distance)
                expect(handler.getExerciseType()).toNot(equal(ExerciseType.Weight))
                expect(handler.getExerciseType()).to(equal(ExerciseType.Distance))

                handler.createNewObject()

                expect(realm.objects(Exercise).count).to(equal(1))

                expect(handler.isExerciseNameUnique("Test")).to(beFalse())
                expect(handler.isExerciseNameUnique("test")).to(beFalse())
                expect(handler.isExerciseNameUnique("TEST")).to(beFalse())
                expect(handler.isExerciseNameUnique("asdf")).to(beTrue())
            }

            it("should update an existing obj") {
                let handler = ExerciseHandler(realmToUse: realm, exerciseName: "test")

                expect(handler).toNot(beNil())
                expect(handler.getExerciseType()).to(equal(ExerciseType.Distance))
                expect(handler.getBodyPart()).to(equal(BodyParts.Legs))
                expect(handler.getExerciseType()).toNot(equal(ExerciseType.Weight))

                handler.setExerciseType(.Weight)
                expect(handler.getExerciseType()).to(equal(ExerciseType.Weight))
                handler.updateObject()

                let anotherHandler = ExerciseHandler(realmToUse: realm, exerciseName: "test")
                expect(handler.getExerciseType()).to(equal(ExerciseType.Weight))
                expect(handler.getWorkoutName()).to(equal("test"))
            }

            it("should try to find a non-existing exercise") {
                let handler = ExerciseHandler(realmToUse: realm, exerciseName: "demo")
                expect(handler.getExerciseType()).to(beNil())
                expect(handler.getBodyPart()).to(beNil())
                expect(handler.getWorkoutName()).to(beNil())
            }
        }
    }
}
