import Quick
import Nimble

import RealmSwift
import GymLogger

class TestSummaryStatisticsBuilder: QuickSpec {
    override func spec() {
        var realm: Realm!

        describe("") {
            beforeEach {
                realm = Realm(inMemoryIdentifier: "test-summary")
            }

            it("should not run the rebuild ") {
                let builder = SummaryStatisticsBuilder(realm: realm)
                expect(builder.hasEmptySummary()).to(beTrue())
                builder.buildInitialSummary()
                expect(realm.objects(Summary).count).toEventually(equal(1))
            }
        }
    }
}
