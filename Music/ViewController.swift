//
//  ViewController.swift
//  Music
//
//  Created by gohpeijin on 06/09/2021.
//  Copyright © 2021 pj. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    struct music{
        var name : String
        var author : String
    }
    
    var musicList: [music] = []
    var audioPlayer = AVAudioPlayer()
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var musicTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        someUIchores()
        musicList = createMusicList()
        
        musicTableView.register(MusicTableViewCell.nib(), forCellReuseIdentifier: MusicTableViewCell.identifier)
        
        musicTableView.dataSource = self
        musicTableView.delegate = self
    }
    
    func createMusicList() -> [music]{
        var tempMusicList: [music] = []
        
        tempMusicList.append(music(name: "Beautiful Mistake", author: "Maroon 5, Megan Thee Stallion"))
        tempMusicList.append(music(name: "Circles", author: "Post Malone"))
        tempMusicList.append(music(name: "Imagination", author: "Shawn Mendes"))
        tempMusicList.append(music(name: "Love Yourself", author: "Justin Bieber"))
        tempMusicList.append(music(name: "Psycho", author: "Post Malone, Ty Dolla $ign"))
        tempMusicList.append(music(name: "Save Your Tears", author: "The Weeknd, Ariana Grande"))
        tempMusicList.append(music(name: "Shape of You", author: "Ed Sheeran"))
        
        return tempMusicList
    }
    
    
    func someUIchores(){
        backgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: -3)
        backgroundView.layer.shadowOpacity = 0.8
    }
    
    func getAudioUrl(_ music: music) -> URL{
        let audioName = music.name.lowercased()
        let url = Bundle.main.path(forResource: audioName, ofType: "mp3")
        
        return URL(fileURLWithPath: url!)
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let audioUrl = getAudioUrl(musicList[indexPath.row])
    
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            audioPlayer.play()
        }
        catch{
            print(error)
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.identifier, for: indexPath) as! MusicTableViewCell
        
        let music = musicList[indexPath.row]
        let audioUrl = getAudioUrl(music)
        let asset = AVURLAsset(url: audioUrl)
        let duration = Int(CMTimeGetSeconds(asset.duration))
        cell.displayCell(music.name,music.author, duration)

        return cell
    }
    
    
}
