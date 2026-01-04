//
//  ContentView.swift
//  swiftUITryOut
//
//  Created by kunguma-14252 on 06/04/23.
//
import Foundation
import SwiftUI

struct ContentView: View {
    var array: [TabItem] = TabItem.allCases
    @State var selectedItem: TabItem? = TabItem(rawValue: Foundation.UserDefaults.getItem()) ?? .General
    
    var body: some View {
        
        NavigationSplitView {
            sidebarContent
                .accentColor(.cyan)
        } detail: {
            Text(selectedItem?.title ?? "Here.")
        }
        .accentColor(.accentColor)
    }
    
    var sidebarContent: some View {
        List(array, id: \.title, selection: $selectedItem) {item in
            link(to: item)
                .accentColor(.pink)
                .tint(.yellow)
        }
        .foregroundStyle(.secondary)
        .accentColor(.green)
        .tint(.orange)
        .listItemTint(.mint)
    }
    func link(to page: TabItem) -> some View {
        NavigationLink(value: page) {
            Image(systemName: page.icon)
                .foregroundColor(.red)
            Label(page.title, image: "")
        }
    }
//        NavigationLink(value: page) {
//
//        }.foregroundColor(.cyan)
//    }
//        NavigationView{
//            List(array, id: \.title) { item in
//                NavigationLink(destination: getView(item: item), tag: item, selection: $selectedItem, label: {
//                    Label(item.title, image: item.icon)
//                })
//
//                .frame(width: 300,alignment: .leading)
//
//            }
//            .onChange(of: selectedItem ?? .General, perform: { newValue in
//                UserDefaults.setItem(item: newValue)
//            })
//
//        }
//        .tint(.yellow)
//        .accentColor(.green)
//    }
}

struct getView: View {
    var item: TabItem
    @State private var isToggle1 : Bool = UserDefaults.getItem(key: "t1")
    @State private var isToggle2 : Bool = UserDefaults.getItem(key: "t2")
    @State private var isToggle3 : Bool = UserDefaults.getItem(key: "t3")
    
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            Text(item.title)
                .foregroundColor(.white)
                .font(Font(CTFont(CTFontUIFontType(rawValue: 0)!, size: 18)))
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 0, leading: -450, bottom: 0, trailing: 0))
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 900, height: 140, alignment: .center)
                    .foregroundColor(Color(red: 46/255, green: 46/255, blue: 46/255))
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Start mac app on system start")
                            .foregroundColor(.white)
                            .font(Font(CTFont(CTFontUIFontType(rawValue: 0)!, size: 15)))
                            .foregroundColor(.black)
                        Text("Show app will start running as soon as the system start")
                            .foregroundColor(Color(red: 228/255, green: 228/255, blue: 228/255))
                            .font(Font(CTFont(CTFontUIFontType(rawValue: 0)!, size: 13)))
                        Divider()
                            .frame(width: 800)
                        Text("Launch on system start")
                            .foregroundColor(.white)
                            .font(Font(CTFont(CTFontUIFontType(rawValue: 0)!, size: 15)))
                            .foregroundColor(.black)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    }
                    .padding(EdgeInsets(top: 0, leading: -75, bottom: 0, trailing: 0))
                }
                Toggle("", isOn: $isToggle1)
                    .toggleStyle(.switch)
                    .onChange(of: isToggle1, perform: { newValue in
                        UserDefaults.setItem(toggle: newValue, key: "t1")
                    })
                    .padding(EdgeInsets(top: -30, leading: 750, bottom: 0, trailing: 0))
                Toggle("", isOn: $isToggle2)
                    .toggleStyle(.switch)
                    .onChange(of: isToggle2, perform: { newValue in
                        UserDefaults.setItem(toggle: newValue, key: "t2")
                    })
                    .padding(EdgeInsets(top: 75, leading: 750, bottom: 0, trailing: 0))
            }
            Text("Security")
                .foregroundColor(.white)
                .font(Font(CTFont(CTFontUIFontType(rawValue: 0)!, size: 18)))
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 0, leading: -450, bottom: 0, trailing: 0))
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 900, height: 80, alignment: .center)
                    .foregroundColor(Color(red: 46/255, green: 46/255, blue: 46/255))
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Lock app using touch id")
                            .foregroundColor(.white)
                            .font(Font(CTFont(CTFontUIFontType(rawValue: 0)!, size: 15)))
                            .foregroundColor(.black)
                        Text("Protecting your files by enabling lock using touch id or passcode")
                            .foregroundColor(Color(red: 228/255, green: 228/255, blue: 228/255))
                            .font(Font(CTFont(CTFontUIFontType(rawValue: 0)!, size: 13)))
                    }
                    .padding(EdgeInsets(top: 0, leading: -435, bottom: 0, trailing: 0))
                }
                Toggle("", isOn: $isToggle3)
                    .toggleStyle(.switch)
                    .onChange(of: isToggle3, perform: { newValue in
                        UserDefaults.setItem(toggle: newValue, key: "t3")
                    })
                    .padding(EdgeInsets(top: 0, leading: 750, bottom: 0, trailing: 0))
            }
            Text("Update")
                .foregroundColor(.white)
                .font(Font(CTFont(CTFontUIFontType(rawValue: 0)!, size: 18)))
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 0, leading: -450, bottom: 0, trailing: 0))
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 900, height: 80, alignment: .center)
                    .foregroundColor(Color(red: 46/255, green: 46/255, blue: 46/255))
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Update Automatically")
                            .foregroundColor(.white)
                            .font(Font(CTFont(CTFontUIFontType(rawValue: 0)!, size: 15)))
                            .foregroundColor(.black)
                        Text("Current Version - 1.1.2")
                            .foregroundColor(Color(red: 228/255, green: 228/255, blue: 228/255))
                            .font(Font(CTFont(CTFontUIFontType(rawValue: 0)!, size: 13)))
                    }
                    .padding(EdgeInsets(top: 0, leading: -435, bottom: 0, trailing: 0))
                }
                Button("Check for updates") {
                    print("Kungu : Update button tapped")
                }
                .frame(height: 35)
                .padding(EdgeInsets(top: 0, leading: 750, bottom: 0, trailing: 0))
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                HStack {
                    Image(systemName: item.icon)
                    Text(item.title).font(.headline)
                }
            }
        }
        .toolbar(.hidden, for: .windowToolbar)
    }
}

enum TabItem: Int, CaseIterable {
    
    case General = 1
    case Appearance = 2
    case Accounts = 3
    case Notifications = 4
    case Shortcuts = 5
    case Privacy = 6
    case Downloads = 7
    case Integration = 8
    
    var title: String {
        switch self {
        case .General:
            return "General"
        case .Appearance:
            return "Appearance"
        case .Accounts:
            return "Accounts"
        case .Notifications:
            return "Notifications & Sounds"
        case .Shortcuts:
            return "Shortcuts"
        case .Privacy:
            return "Privacy & Feedback"
        case .Downloads:
            return "Downloads"
        case .Integration:
            return "Integration"
        }
    }
    
    var icon: String {
        switch self {
        case .General:
            return "gearshape"
        case .Appearance:
            return "display"
        case .Accounts:
            return "person.and.background.dotted"
        case .Downloads:
            return "arrow.down"
        case .Notifications:
            return "bell"
        case .Shortcuts:
            return "command"
        case .Privacy:
            return "shield"
        case .Integration:
            return "puzzlepiece.extension"
        }
    }
}
// MARK: - Preview Provider

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
