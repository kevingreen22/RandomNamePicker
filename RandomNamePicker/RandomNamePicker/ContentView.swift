//
//  ContentView.swift
//  RandomNamePicker
//
//  Created by Kevin Green on 4/2/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("nameArray") var nameArray: [String] = [String]()
    @State private var alertItem: AlertItem?
    @State private var newName = ""
    @State private var winner = ""
    @State private var confirm = "Name Added"
    @State private var showConfirm = false
    @State private var remaining = 2.0
    @State private var showDuplicateNameAlert = false
    @State private var showClearNamesAlert = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        TextField("Enter Name", text: $newName)
                            .frame(width: 300, height: 100, alignment: .center)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing)
                        
                        Button(action: {
                            if nameArray.contains(newName) {
                                alertItem = AlertItem(title: Text("Duplicate Name"), message: Text("That name already exists in the list."), dismissButton: .default(Text("Ok")))
                            } else if newName == "" {
                                alertItem = AlertItem(title: Text("Name Empty"), message: Text("Please enter a name."), dismissButton: .default(Text("Ok")))
                            } else {
                                // add name to array
                                nameArray.append(newName)
                                newName = ""
                                withAnimation {
                                    showConfirm = true
                                }
                            }
                        }, label: {
                            Image(systemName: "plus").scaleEffect(2)
                        })
                    }
                    
                    
                    
                    Spacer()
                    
                    Button(action: {
                        // shuffle nameArray
                        nameArray.shuffle()
                        
                        // get name from array with number as index
                        if let random = nameArray.randomElement() {
                            winner = random
                        }
                    }, label: {
                        Text("Pick Random Name")
                    })
                    .font(.title2)
                    
                    Spacer()
                    
                    Group{
                        Divider()
                        Text("Winner!").font(.title)
                        Text(winner)
                            .foregroundColor(.green)
                            .font(.title)
                        Divider()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        alertItem = AlertItem(title: Text("Clear All Names?"), message: nil, dismissButton: .default(Text("No"), action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }), secondaryButton: .destructive(Text("Yes"), action: {
                            nameArray = []
                            winner = ""
                        }))
                    }, label: {
                        Text("Clear all saved names")
                    })
                    Spacer()
                }
                
                if showConfirm {
                    VStack {
                        Text(confirm)
                            .padding(5)
                            .background(Color.gray)
                            .clipShape(Capsule())
                            .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                                self.remaining -= 0.1
                                if self.remaining <= 0 {
                                    withAnimation {
                                        showConfirm = false
                                    }
                                    self.remaining = 2.0
                                }
                            }
                        Spacer()
                    }
                }
            }
            
            .padding(.top)
            
            .alert(item: $alertItem, content: { alertItem in
                if let secondaryButton = alertItem.secondaryButton {
                    return Alert(title: alertItem.title, message: alertItem.message, primaryButton: alertItem.dismissButton, secondaryButton: secondaryButton)
                } else {
                    return Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                }
            }) // end alert
            
            .navigationBarTitle("Random Name Picker", displayMode: .inline)
            .navigationBarItems(trailing:
                NavigationLink(
                    destination: NamesList(nameArray: nameArray),
                    label: {
                        Image(systemName: "list.bullet")
                    })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var dismissButton: Alert.Button
    var secondaryButton: Alert.Button?
}


extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
