//
//  Library.swift
//  Sharmanka
//
//  Created by Vadym Potapov on 16.01.2023.
//

import SwiftUI
import URLImage

struct Library: View {
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25){
                GeometryReader {geometry in
                    HStack(spacing: 20){
                        Button {
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximizedTrackDetaailController(viewModel: self.track)
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color("deep-purple")).background(Color("deep-white")).cornerRadius(10)
                        }
                        Button {
                            self.tracks = UserDefaults.standard.savedTracks()
                        } label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color("deep-purple"))
                                .background(Color("deep-white")).cornerRadius(10)
                        }
                        
                    }
                }
                .padding()
                .frame(height: 50)
                //                Divider().padding(.trailing).padding(.leading)
                
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track).gesture(LongPressGesture()
                            .onEnded{ _ in
                                self.showingAlert = true
                                self.track = track
                            }.simultaneously(with: TapGesture()
                                .onEnded{ _ in
                                    let keyWindow = UIApplication.shared.connectedScenes
                                        .filter({$0.activationState == .foregroundActive})
                                        .map({$0 as? UIWindowScene})
                                        .compactMap({$0})
                                        .first?.windows
                                        .filter({$0.isKeyWindow}).first
                                    let tabBarVC = keyWindow?.rootViewController as?
                                    MainTabBarController
                                    tabBarVC?.trackDetailView.delegate = self
                                    
                                    
                                    self.track = track
                                    self.tabBarDelegate?.maximizedTrackDetaailController(viewModel: self.track)
                                }))
                    }.onDelete(perform: delete)
                }
                
            }.actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(title: Text("Are your sure that you want delete this track?"), buttons: [.destructive(Text("Delete"), action: {
                    self.deleteIn(at: self.track)
                }), .cancel()
                                                                                                    ])
            })
            
            .navigationTitle("Library")
        }
    }
    
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
    func deleteIn(at track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
}

struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    var body: some View {
        HStack{
            URLImage(URL(string: cell.iconUrlString ?? "")!,
                     content: {image in
                image
                    .resizable()
            }
            )
            .frame(width: 60, height: 60)
            .cornerRadius(2)
            VStack(alignment: .leading){
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}


struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

extension Library: TrackMovingDelegate {
    
    func movingBackForPreviusTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let newIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if newIndex - 1 == -1 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack = tracks[newIndex - 1]
            self.track = nextTrack
        }
        return nextTrack
    }
    
    func movingForwardForNextTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let newIndex = index else { return nil}
        var nextTrack: SearchViewModel.Cell
        if newIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[newIndex + 1]
            self.track = nextTrack
        }
        return nextTrack
    }
}
