import Quick
import Nimble

import RealmSwift
import GymLogger


class TestKeyValues: QuickSpec {
    var realm: Realm!
    override func spec() {

        describe("Test the KeyValue Settings Store") {
            beforeSuite {
            }

            afterSuite {
            }

            beforeEach {
                self.realm = Realm(inMemoryIdentifier: "test-key-value")
            }


            it("Should save different keys and values") {
                ROKKeyValue.put("teasdast", string: "demo", realm: self.realm)
                expect(self.realm.objects(ROKKeyValue).count).to(equal(1))
            }
        }
    }
}
