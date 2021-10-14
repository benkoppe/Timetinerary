//
//  TableTemplates.swift
//  Timetinerary
//
//  Created by Ben K on 10/13/21.
//

import Foundation

let presetTemplates: [PresetTemplate] = [atech]

struct Template: Codable {
    static func exportToURL(tables: [TableTemplate]) -> URL? {
        guard let encoded = try? JSONEncoder().encode(tables) else { return nil }
        
        let name = UUID().uuidString
        let fileExtension = "timetinerary"

        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        guard let path = documents?.appendingPathComponent(name).appendingPathExtension(fileExtension) else { return nil }

        do {
            try encoded.write(to: path, options: .atomic)
            return path
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func importURL(from url: URL) {
        guard let data = try? Data(contentsOf: url), let templates = try? JSONDecoder().decode([TableTemplate].self, from: data) else { return }
        
        for template in templates {
            print(template.key)
        }
    }

//    static func importURL(from url: URL) {
//        guard let data = try? Data(contentsOf: url), let template = try? JSONDecoder().decode(Template.self, from: data) else { return }
//
//
//    }
}

struct PresetTemplate: Hashable, Codable {
    let name: String
    let timelines: [TableTemplate]
}

struct TableTemplate: Hashable, Codable {
    let key: String
    let data: Data
}

let atech = PresetTemplate(name: "atech", timelines: [atechA1st, atechA2nd, atechB1st, atechB2nd, atechC1st, atechC2nd])

let atechA1st = TableTemplate(key: "A Day (1st)", data: Data("[{\"isConflicted\":false,\"id\":\"14BAFCA8-18D7-4D43-BE51-142B7671F43F\",\"name\":\"Period 1\",\"minute\":25,\"hour\":7},{\"isConflicted\":false,\"id\":\"13EE1941-DEC8-4FE1-A187-A45A7385CB37\",\"name\":\"Period 3\",\"minute\":45,\"hour\":8},{\"isConflicted\":false,\"id\":\"A612E678-C8E4-43ED-B7DC-2CBCCAA6E4A2\",\"name\":\"Atech Time\",\"minute\":9,\"hour\":10},{\"isConflicted\":false,\"id\":\"19292217-9B77-40E5-B1A5-EF709DE8800F\",\"name\":\"Lunch\",\"minute\":52,\"hour\":10},{\"isConflicted\":false,\"id\":\"C1CE607C-88EE-4102-9897-75F7D6436FD0\",\"name\":\"Period 5\",\"minute\":22,\"hour\":11},{\"isConflicted\":false,\"id\":\"E244C1AC-270C-4937-97AA-0BCC65766D1C\",\"name\":\"Period 7\",\"minute\":46,\"hour\":12},{\"isConflicted\":false,\"id\":\"3F58B669-7E35-4168-8915-D44DBD1FDD6F\",\"name\":\"\",\"minute\":10,\"hour\":14}]".utf8))
let atechA2nd = TableTemplate(key: "A Day (2nd)", data: Data("[{\"isConflicted\":false,\"id\":\"6F5C9268-B7FA-4FC8-8A89-757D5D6DCAE0\",\"name\":\"Period 1\",\"minute\":25,\"hour\":7},{\"isConflicted\":false,\"id\":\"963BE812-0955-4389-970C-16433C8BAFAE\",\"name\":\"Period 3\",\"minute\":45,\"hour\":8},{\"isConflicted\":false,\"id\":\"2EC56584-96F1-4D25-B62A-0A91B805A82E\",\"name\":\"Atech Time\",\"minute\":9,\"hour\":10},{\"isConflicted\":false,\"id\":\"863B5750-E8A9-4CBA-88E3-FA393A51BA25\",\"name\":\"Period 5\",\"minute\":52,\"hour\":10},{\"isConflicted\":false,\"id\":\"92531521-0B27-49F8-802B-7EAD89D5F4BD\",\"name\":\"Lunch\",\"minute\":16,\"hour\":12},{\"isConflicted\":false,\"id\":\"9C79D80E-A830-4413-B55F-5605501ED6D0\",\"name\":\"Period 7\",\"minute\":46,\"hour\":12},{\"isConflicted\":false,\"id\":\"1542236C-91BD-4AA4-BAFD-FCF41141EC32\",\"name\":\"\",\"minute\":10,\"hour\":14}]".utf8))

let atechB1st = TableTemplate(key: "B Day (1st)", data: Data("[{\"isConflicted\":false,\"id\":\"F1CA5E07-2901-4802-A491-6189AF52FDE3\",\"name\":\"Period 2\",\"minute\":25,\"hour\":7},{\"isConflicted\":false,\"id\":\"D2537A79-D1DC-4E64-B67E-C3068977F895\",\"name\":\"Period 4\",\"minute\":45,\"hour\":8},{\"isConflicted\":false,\"id\":\"5042B8B0-6025-476F-AA9A-B343F26E3B79\",\"name\":\"Atech Time\",\"minute\":9,\"hour\":10},{\"isConflicted\":false,\"id\":\"0A0D9300-7D0A-45CB-8DE9-74E6003503B8\",\"name\":\"Lunch\",\"minute\":52,\"hour\":10},{\"isConflicted\":false,\"id\":\"E0B64096-57A8-4372-AD70-A50E0B32292B\",\"name\":\"Period 6\",\"minute\":22,\"hour\":11},{\"isConflicted\":false,\"id\":\"CDBC2E50-F39C-456B-8BFC-9049B1E51825\",\"name\":\"Period 8\",\"minute\":46,\"hour\":12},{\"isConflicted\":false,\"id\":\"B9B984A9-BE20-4DFE-A6CD-2BBF187D55EB\",\"name\":\"\",\"minute\":10,\"hour\":14}]".utf8))
let atechB2nd = TableTemplate(key: "B Day (2nd)", data: Data("[{\"isConflicted\":false,\"id\":\"4E795E7E-F9C2-438B-BEDE-54301BDCC8BB\",\"name\":\"Period 2\",\"minute\":25,\"hour\":7},{\"isConflicted\":false,\"id\":\"A74B07D0-CA75-480A-B63B-EB04A7384BBF\",\"name\":\"Period 4\",\"minute\":45,\"hour\":8},{\"isConflicted\":false,\"id\":\"6BD07FF3-42FA-47BF-8607-996111B430A8\",\"name\":\"Atech Time\",\"minute\":9,\"hour\":10},{\"isConflicted\":false,\"id\":\"10ACE16E-1EBF-4AF4-9DCE-C8FBB9ECDDD8\",\"name\":\"Period 6\",\"minute\":52,\"hour\":10},{\"isConflicted\":false,\"id\":\"FA2F605F-E788-441C-A358-AA7624794085\",\"name\":\"Lunch\",\"minute\":16,\"hour\":12},{\"isConflicted\":false,\"id\":\"89A6889E-DAD7-422C-BCE3-246D7DF2C854\",\"name\":\"Period 8\",\"minute\":46,\"hour\":12},{\"isConflicted\":false,\"id\":\"3E877915-5507-4C39-B1E1-F147F14AE4E7\",\"name\":\"\",\"minute\":10,\"hour\":14}]".utf8))

let atechC1st = TableTemplate(key: "C Day (1st)", data: Data("[{\"isConflicted\":false,\"id\":\"D0646029-0BDA-47BA-B5AB-2CEDF0B9BCA9\",\"name\":\"Period 1\",\"minute\":25,\"hour\":7},{\"isConflicted\":false,\"id\":\"5C1056C0-5816-4E78-B98F-6C0A0C372177\",\"name\":\"Period 2\",\"minute\":6,\"hour\":8},{\"isConflicted\":false,\"id\":\"7669CBFF-47D0-4EFF-801E-5799D4A5B808\",\"name\":\"Period 3\",\"minute\":55,\"hour\":8},{\"isConflicted\":false,\"id\":\"CAA67527-B0D7-4DB4-A459-898B52621FD6\",\"name\":\"Period 4\",\"minute\":40,\"hour\":9},{\"isConflicted\":false,\"id\":\"D5A4CA4E-3A1E-4BF0-BA81-C6311401C98B\",\"name\":\"Lunch\",\"minute\":25,\"hour\":10},{\"isConflicted\":false,\"id\":\"F71E4968-8B44-4650-8F18-75009A4D67FC\",\"name\":\"Period 5\",\"minute\":10,\"hour\":11},{\"isConflicted\":false,\"id\":\"30F376F8-49A7-404C-AE56-860158FD7CEC\",\"name\":\"Period 6\",\"minute\":55,\"hour\":11},{\"isConflicted\":false,\"id\":\"164C1A17-EFF6-415C-8120-4D63E73CD1DD\",\"name\":\"Period 7\",\"minute\":40,\"hour\":12},{\"isConflicted\":false,\"id\":\"48B713EA-F401-40CD-8435-BE4EBC3CB6C6\",\"name\":\"Period 8\",\"minute\":25,\"hour\":13},{\"isConflicted\":false,\"id\":\"79FAD5AE-892A-4B36-BFD9-B0CE1B38D3EB\",\"name\":\"\",\"minute\":10,\"hour\":14}]".utf8))
let atechC2nd = TableTemplate(key: "C Day (2nd)", data: Data("[{\"isConflicted\":false,\"id\":\"62EA5FC8-66BE-4470-895E-537DC219373F\",\"name\":\"Period 1\",\"minute\":25,\"hour\":7},{\"isConflicted\":false,\"id\":\"C2975BF5-BB46-492D-BC6C-E4DAFB5A3EDD\",\"name\":\"Period 2\",\"minute\":6,\"hour\":8},{\"isConflicted\":false,\"id\":\"6B91BD19-C2E8-443B-B1B0-7D71355521F8\",\"name\":\"Period 3\",\"minute\":55,\"hour\":8},{\"isConflicted\":false,\"id\":\"9C69C0B5-DEEE-498F-8D1D-F919CD86EE9E\",\"name\":\"Period 4\",\"minute\":40,\"hour\":9},{\"isConflicted\":false,\"id\":\"7D63A097-5D12-4898-8B8D-907AFFA27CCE\",\"name\":\"Period 5\",\"minute\":25,\"hour\":10},{\"isConflicted\":false,\"id\":\"A8A2DF30-9A27-4A51-857F-C8FBB1A0725C\",\"name\":\"Lunch\",\"minute\":10,\"hour\":11},{\"isConflicted\":false,\"id\":\"1F8FCF3C-DDA8-4083-9F58-4FBD71183D89\",\"name\":\"Period 6\",\"minute\":55,\"hour\":11},{\"isConflicted\":false,\"id\":\"CB5B9842-C56F-4221-84E1-BA7AD9476836\",\"name\":\"Period 7\",\"minute\":40,\"hour\":12},{\"isConflicted\":false,\"id\":\"EE7BB95F-A909-4FBD-8626-986CAC970C7B\",\"name\":\"Period 8\",\"minute\":25,\"hour\":13},{\"isConflicted\":false,\"id\":\"051BE649-9E6D-45E0-89B3-EC7B81ABF537\",\"name\":\"\",\"minute\":10,\"hour\":14}]".utf8))
