import Quick
import Nimble

import RealmSwift
import GymLogger

class TestSummaryStatisticsBuilder: QuickSpec {
    override func spec() {
        var realm: Realm!
        context("This test should handle the statisticsbuilder") {

            beforeSuite {
                realm = Realm(inMemoryIdentifier: "test-summary-statistics")

            }

            it("should not run the rebuild ") {
                let builder = SummaryStatisticsBuilder(realm: realm)
                expect(builder.hasEmptySummary()).to(beTrue())
                builder.buildInitialSummary()
                expect(builder.hasEmptySummary()).to(beFalse())
            }
        }
    }
}
