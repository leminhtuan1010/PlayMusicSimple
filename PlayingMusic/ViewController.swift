//
//  ViewController.swift
//  PlayingMusic
//
//  Created by Minh Tuan on 6/7/17.
//  Copyright © 2017 Minh Tuan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var lbl_TimeLeft: UILabel!
    
    @IBOutlet weak var lbl_TimeTotal: UILabel!

    @IBOutlet weak var sld_Duration: UISlider!
    
    @IBOutlet weak var Sw_ViTri: UISwitch!
    @IBOutlet weak var btn_Play: UIButton!
    
    @IBOutlet weak var sld_volume: UISlider!
    var audio = AVAudioPlayer()
    var count = 0
    var time = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        audio = try!AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "music",ofType: ".mp3")!) as URL)
        audio.prepareToPlay()
        addThumbImgForSlider()
        audio.delegate = self
    }
    func updateTimeLeft(){ // tính thời gian chạy và tổng thời gian
        let timeleft = Int(audio.currentTime)
        
        let min = timeleft / 60
        
        let sec = timeleft - min * 60
        
        lbl_TimeLeft.text = String(format: "%2d:%02d", min, sec)
        
        self.sld_Duration.value = Float(audio.currentTime/audio.duration)
        
        let totaltime = Int(audio.duration)
        
        let minTotal = totaltime / 60
        
        let secTotal = totaltime - minTotal * 60
        
        lbl_TimeTotal.text = String(format: "%2d:%02d", minTotal, secTotal)
    }
    func addThumbImgForSlider(){
        sld_volume.setThumbImage(UIImage(named: "thumb.png"), for: .normal)
        sld_volume.setThumbImage(UIImage(named: "thumbHightLight.png"), for: .normal)
    }

    @IBAction func acc_Play(_ sender: Any) {
        if (count == 0){
            audio.play()
            btn_Play.setImage(UIImage(named: "pause"), for: .normal)
            count = 1
            check()
            time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLeft), userInfo: nil, repeats: true)
        }else if (count == 1){
            audio.stop()
            btn_Play.setImage(UIImage(named: "play"), for: .normal)
            count = 0
            time.invalidate() // Trả lại thời gian ban đầu
        }
    
    }
    @IBAction func sld_volume(_ sender: UISlider) {
        audio.volume = sender.value
    }

    @IBAction func Sw_Chaylai(_ sender: UISwitch) {
       check()
    }
    @IBAction func sld_Timer(_ sender: UISlider) {
        // Chỉnh thời gian bài nhạc tương đương với thanh kéo
        audio.currentTime = TimeInterval(Float(sender.value) * Float(audio.duration))
    }
    // Sau khi bài nhạc chạy xong sẽ gọi đến audioPlayerDidFinishPlaying trong AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        btn_Play.setImage(UIImage(named: "play"), for: .normal)
        }
    func check(){
        if(Sw_ViTri.isOn == true){
            // numberOfLoops: cho bài nhạc chạy lại khi có giá trị là -1
            audio.numberOfLoops = -1
        }else{
            audio.numberOfLoops = 0
        }

    }
}

