//
//  NamesList.swift
//  RandomNamePicker
//
//  Created by Kevin Green on 4/2/21.
//

import SwiftUI

struct NamesList: View {
    @AppStorage("nameArray") var nameArray = [String]()
    
    var body: some View {
        List {
            ForEach(nameArray, id: \.self) { name in
                Text(name)
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
            nameArray.remove(atOffsets: offsets)
        }
}

struct NamesList_Previews: PreviewProvider {
    static var previews: some View {
        NamesList(nameArray: ["kevin", "nell", "steve", "Annabear", ])
    }
}
