/*import Quick
import Nimble

import RealmSwift
import GymLogger


class TestKeyValues: QuickSpec {
    var realm: Realm!
    override func spec() {
        beforeSuite {
            self.realm = try! Realm(inMemoryIdentifier: "test-key-value")
        }

        describe("Test the KeyValue Settings Store") {
            it("Should save different keys and values") {
                ROKKeyValue.put("teasdast", string: "demo", realm: self.realm)
                expect(self.realm.objects(ROKKeyValue).count).to(equal(1))
                expect(ROKKeyValue.getString("teasdast", defaultValue: "", realm: self.realm)).to(equal("demo"))
                ROKKeyValue.remove("teasdast", realm: self.realm)
                expect(self.realm.objects(ROKKeyValue).count).to(equal(0))
            }

            it("should try to delete non-existing keys") {
                expect(ROKKeyValue.getString("demo", defaultValue: "not-there", realm: self.realm)).to(equal("not-there"))

                ROKKeyValue.put("not-deleted", bool: false, realm: self.realm)
                ROKKeyValue.put("another-one", int: 12, realm: self.realm)
                expect(self.realm.objects(ROKKeyValue).count).to(equal(2))
                expect(self.realm.objects(ROKKeyValue).count).to(equal(ROKKeyValue.entryCount(inRealm: self.realm)))
                ROKKeyValue.remove("teasdast", realm: self.realm)
                expect(self.realm.objects(ROKKeyValue).count).to(equal(2))
            }
        }
    }
}*/
