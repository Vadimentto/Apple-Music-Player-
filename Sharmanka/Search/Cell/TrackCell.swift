//
//  TrackCell.swift
//  Sharmanka
//
//  Created by Vadym Potapov on 13.01.2023.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    
    var cell: SearchViewModel.Cell?
    
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    @IBOutlet weak var addTrackOutlet: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // для того что бы картинка не подгружалась второй раз после первой подгрузки она отправляется в кэш
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        
        self.cell = viewModel
        
        let savedTrack = UserDefaults.standard.savedTracks()
        let checkFavourite = savedTrack.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName }) != nil
        if checkFavourite {
            addTrackOutlet.isHidden = true
        } else {
            addTrackOutlet.isHidden = false
        }

        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func AddTrackAction(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        var  listOfTracks = UserDefaults.standard.savedTracks()
        addTrackOutlet.isHidden = true
        guard let cell = cell else { return }
        listOfTracks.append(cell)
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            defaults.set(saveData, forKey: UserDefaults.favouriteTrackKey)
            print("good")
        }
    }
}
