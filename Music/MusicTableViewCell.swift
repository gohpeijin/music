//
//  MusicTableViewCell.swift
//  Music
//
//  Created by gohpeijin on 06/09/2021.
//  Copyright © 2021 pj. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var musicDuration: UILabel!
    @IBOutlet weak var musicAuthor: UILabel!
    @IBOutlet weak var musicName: UILabel!
    @IBOutlet weak var musicImage: UIImageView!
    static let identifier = "MusicTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func displayCell(_ music : String, _ author : String, _ duration: Int ){
        musicName.text = music
        musicAuthor.text = author
        musicImage.image = UIImage(named: music.lowercased())
        let second = duration % 60 < 10 ? "0" + String(duration % 60) : String(duration % 60)
        musicDuration.text = "\(duration/60):\(second)"
    }
    
    // for register the cell
    static func nib() -> UINib {
        return UINib(nibName: "MusicTableViewCell", bundle: nil)
    }
}
