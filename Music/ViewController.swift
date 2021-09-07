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
    var musicIndex = 0
    var firstTimeLogin = true // to make sure the first song only start from beginning of the song, then after that user will pause and play
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var musicTableView: UITableView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        someUIchores()
        musicList = createMusicList()
        
        musicTableView.register(MusicTableViewCell.nib(), forCellReuseIdentifier: MusicTableViewCell.identifier)
        
        setCurrentSong()
        musicTableView.dataSource = self
        musicTableView.delegate = self
        
        let defaults = UserDefaults.standard
        if let savedMusicIndex: Int = defaults.integer(forKey: "musicIndex"){
            musicIndex = savedMusicIndex
            setCurrentSong()
            let audioUrl = getAudioUrl(musicList[musicIndex])

            do{
                audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            } catch{
                print(error)
            }
        }
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
    
    
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        if playPauseButton.currentImage!.isEqual(UIImage(named: "play")){
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            if firstTimeLogin {
                playSong()
                
            }
            else{
                audioPlayer.play()
            }
            
        }
        else{
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            audioPlayer.pause()
        }
    }
    
    @IBAction func nextSongButtonPressed(_ sender: UIButton) {
        musicIndex = musicIndex == musicList.count-1  ? 0 : musicIndex + 1
        playSong()
    }
    
    
    @IBAction func previousSongPressed(_ sender: UIButton) {
        musicIndex = musicIndex == 0 ? musicList.count-1 : musicIndex - 1
        playSong()
    }
    
    func playSong(){
        firstTimeLogin = false
        let audioUrl = getAudioUrl(musicList[musicIndex])
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            setCurrentSong()
            audioPlayer.play()
        }
        catch{
            print(error)
        }
    }
    
    @IBOutlet weak var currentSongAuthor: UILabel!
    @IBOutlet weak var currentSongName: UILabel!
    @IBOutlet weak var currentSongImage: UIImageView!
    
    func setCurrentSong(){
        let music = musicList[musicIndex]
        
        currentSongName.text = music.name
        currentSongAuthor.text = music.author
        currentSongImage.image = UIImage(named: music.name.lowercased())
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if musicIndex != indexPath.row {
            musicIndex = indexPath.row
            playSong()
        }
        let defaults = UserDefaults.standard
        defaults.setValue(musicIndex, forKey: "musicIndex")
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
