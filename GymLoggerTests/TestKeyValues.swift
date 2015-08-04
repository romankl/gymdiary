import Quick
import Nimble

import RealmSwift
import GymLogger


class TestKeyValues: QuickSpec {
    var realm: Realm = Realm(inMemoryIdentifier: "test-realm-key-values")
    override func spec() {
        describe("Test the KeyValue Settings Store") {
            context("Test realm setup", { () -> Void in
                expect(self.realm).toNot(beNil())
            })

            it("Should save different keys and values") {

            }
        }
    }
}
