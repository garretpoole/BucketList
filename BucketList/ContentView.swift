//
//  ContentView.swift
//  BucketList
//
//  Created by Garret Poole on 4/20/22.
//

import SwiftUI

struct User: Identifiable, Comparable {
    let id = UUID()
    let firstname: String
    let lastname: String
    //built in comparable method (< operator) for .sorted()
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastname < rhs.lastname
    }
}

struct ContentView: View {
    let values = [1, 5, 3, 6, 2, 9].sorted()
    let users = [
        User(firstname: "Arnold", lastname: "Rimmer"),
        User(firstname: "Krisitine", lastname: "Kochanski"),
        User(firstname: "David", lastname: "Lister")
    ].sorted()
//  can sort with closure but not efficient or clean when having to sort multiple data times
//        .sorted {
//        $0.lastname < $1.lastname
//    }
    
    var body: some View {
        List(users) { user in
            Text("\(user.firstname) \(user.lastname)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
