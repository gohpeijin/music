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
    var musicIndex = 0 // initial the user didnt download the app before it will display the first song first
    var firstTimeLogin = true // to make sure the user close app background then when they first back the app,and they click play button it will register the music url first because when back the audio url is not declare yet, so first play a function call that register the url will be called
    var timer: Timer! // to display the running audio current time
    
    @IBOutlet weak var musicTableView: UITableView!  // display the music list
    @IBOutlet weak var backgroundView: UIView! // display the current song background
    @IBOutlet weak var currentSongAuthor: UILabel!
    @IBOutlet weak var currentSongName: UILabel!
    @IBOutlet weak var currentSongImage: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var songTimer: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        someUIchores()
        musicList = createMusicList()
        
        musicTableView.register(MusicTableViewCell.nib(), forCellReuseIdentifier: MusicTableViewCell.identifier)
        
        musicTableView.dataSource = self
        musicTableView.delegate = self
        
        let defaults = UserDefaults.standard
        if let savedMusicIndex: Int = defaults.integer(forKey: "musicIndex"){
            musicIndex = savedMusicIndex
        }
        setCurrentSong() // set the current playing song image,name and authors
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
    
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        if playPauseButton.currentImage!.isEqual(UIImage(named: "play")){
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            if firstTimeLogin { // first register the url and play else just direct play
                playSong()
            }
            else{
                audioPlayer.play() // to continue the previous pasued part instead start from beginning
            }
        }
        else{
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            audioPlayer.pause()
        }
    }
    
    @IBAction func nextSongButtonPressed(_ sender: UIButton) {
        playNextSong()
    }
    
    @IBAction func previousSongPressed(_ sender: UIButton) {
        playPreviousSong()
    }
    
    func getAudioUrl(_ music: music) -> URL{
        let audioName = music.name.lowercased()
        let url = Bundle.main.path(forResource: audioName, ofType: "mp3")
        
        return URL(fileURLWithPath: url!)
    }
    
    func playSong(){
        firstTimeLogin = false
        let audioUrl = getAudioUrl(musicList[musicIndex])
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        }
        catch{
            print(error)
        }
        
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        setCurrentSong() // set the current playing song image,name and authors
        audioPlayer.play()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getTime), userInfo: nil, repeats: true) // to update the current audio time every second
    }
    
    @objc func getTime() {
        let currentTime = Int(audioPlayer.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime%60
        
        songTimer.text = String(format: "%02d:%02d", minutes, seconds)
        
        if !audioPlayer.isPlaying{
            playNextSong()
        }
    }
    
    func setCurrentSong(){
        let music = musicList[musicIndex]
        currentSongName.text = music.name
        currentSongAuthor.text = music.author
        currentSongImage.image = UIImage(named: music.name.lowercased())
    }
    
    func playNextSong(){
        musicIndex = musicIndex == musicList.count-1  ? 0 : musicIndex + 1
        setTableIndexAndPlaySong()
    }
    func playPreviousSong(){
        musicIndex = musicIndex == 0 ? musicList.count-1 : musicIndex - 1
        setTableIndexAndPlaySong()
    }
    
    func setTableIndexAndPlaySong(){
        let indexPath = IndexPath(row: musicIndex, section: 0)
        musicTableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
        playSong()
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if musicIndex != indexPath.row {
            musicIndex = indexPath.row
            playSong()
        }
        let defaults = UserDefaults.standard // save the index key
        defaults.setValue(musicIndex, forKey: "musicIndex")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // let the previous selected to be shown as selected in tableview
        if(musicIndex == indexPath.row){
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
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
        // to get the audio duration
        let audioUrl = getAudioUrl(music)
        let asset = AVURLAsset(url: audioUrl)
        let duration = Int(CMTimeGetSeconds(asset.duration))
        cell.displayCell(music.name,music.author, duration)

        return cell
    }
}
