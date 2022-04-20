//
//  ContentView.swift
//  BucketList
//
//  Created by Garret Poole on 4/20/22.
//
//CHALLENGE
//Proj 8 (astronaut) made generic Bundle extension to find, load, decode any kind of Codable data from our app bundle
//Can you write something similar for document directory
//extension on FileManager using getDocDirectory, load the file, decode it into right type all automatically
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .onTapGesture {
                let str = "Test Message"
                //what were writing to
                let url = getDocumentsDirectory().appendingPathComponent("message.txt")
                
                do {
                    //Swift native encoding is utf8
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    //find the private documents directory for the user for our app
    //gets backed up to iCloud and no "limit" but takes up iPhone storage
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
