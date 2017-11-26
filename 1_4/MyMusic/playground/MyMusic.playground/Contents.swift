//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import AVFoundation

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        
        backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        cymbalButton = UIButton()
        cymbalButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cymbalButton)

        guitarButton = UIButton()
        guitarButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guitarButton)

        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playButton)
        
        stopButton = UIButton()
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stopButton)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //オートレイアウト設定
        // ImageViewの左端は、親ビューの左端から0ptの位置
        backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        // ImageViewの右端は、親ビューの右端から0ptの位置
        backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        // ImageViewの上端は、親ビューの上端から0ptの位置
        backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        // ImageViewの下端は、親ビューの上端から0ptの位置
        backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        // ImageViewの縦横比設定
        backgroundImageView.contentMode = .scaleAspectFill
        // ImageViewの画像を設定
        backgroundImageView.image = UIImage(named: "bg_pattern")
        
        // Cymbalボタンの中央から(-80,-80)に設定
        cymbalButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -80).isActive = true
        cymbalButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -80).isActive = true
        // Cymbalボタンに画像を設定
        cymbalButton.setImage(UIImage(named: "cymbal"), for: .normal)
        // Cymbalボタンをタップしたときにメソッド実行するように設定
        cymbalButton.addTarget(self, action: #selector(cymbal(_:)), for: .touchUpInside)

        // Guitarボタンの中央から(80,-80)に設定
        guitarButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 80).isActive = true
        guitarButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -80).isActive = true
        // Guitarボタンに画像を設定
        guitarButton.setImage(UIImage(named: "guitar"), for: .normal)
        // Guitarボタンをタップしたときにメソッド実行するように設定
        guitarButton.addTarget(self, action: #selector(guitar(_:)), for: .touchUpInside)

        // Playボタンの中央から(-80,80)に設定
        playButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -80).isActive = true
        playButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 80).isActive = true
        // Playボタンにタイトルを設定
        playButton.setTitle("START", for: .normal)
        // Playボタンをタップしたときにメソッド実行するように設定
        playButton.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        
        // Stopボタンの中央から(80,80)に設定
        stopButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 80).isActive = true
        stopButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 80).isActive = true
        // Stopボタンにタイトルを設定
        stopButton.setTitle("STOP", for: .normal)
        // Stopボタンをタップしたときにメソッド実行するように設定
        stopButton.addTarget(self, action: #selector(stop(_:)), for: .touchUpInside)
    }

    var backgroundImageView:UIImageView!
    var cymbalButton:UIButton!
    var guitarButton:UIButton!
    var playButton:UIButton!
    var stopButton:UIButton!

    // シンバルの音源ファイルを指定(書籍のサンプルコードと変更しています)
    let cymbalPath = URL(fileURLWithPath: Bundle.main.path(forResource: "cymbal", ofType: "mp3")!)
    
    // シンバル用のプレイヤーインスタンスを作成
    var cymbalPlayer = AVAudioPlayer()
    
    @objc func cymbal(_ sender: Any) {
        do {
            // シンバル用のプレイヤーに、音源ファイル名を指定
            cymbalPlayer = try AVAudioPlayer(contentsOf: cymbalPath, fileTypeHint: nil)
            
            // シンバルの音源再生
            cymbalPlayer.play()
        } catch {
            print("シンバルで、エラーが発生しました！")
        }
    }
    
    // ギターの音源ファイルを指定(書籍のサンプルコードと変更しています)
    let guitarPath = URL(fileURLWithPath: Bundle.main.path(forResource: "guitar", ofType: "mp3")!)

    // ギター用のプレイヤーインスタンスを作成
    var guitarPlayer = AVAudioPlayer()
    
    // ギターがタップされた時の処理
    @objc func guitar(_ sender: Any) {
        do {
            // ギター用のプレイヤーに、音源ファイル名を指定
            guitarPlayer = try AVAudioPlayer(contentsOf: guitarPath, fileTypeHint: nil)
            guitarPlayer.play()
        } catch {
            print("ギターで、エラーが発生しました！")
        }
    }
    
    // バックミュージックの音源ファイルを指定(書籍のサンプルコードと変更しています)
    let backmusicPath = URL(fileURLWithPath: Bundle.main.path(forResource: "backmusic", ofType: "mp3")!)
    
    // バックミュージック用のプレイヤーインスタンスを作成
    var backmusicPlayer = AVAudioPlayer()
    
    // Playボタンがタップされた時の処理
    @objc func play(_ sender: Any) {
        do {
            // バックミュージック用のプレイヤーに、音源ファイル名を指定
            backmusicPlayer = try AVAudioPlayer(contentsOf: backmusicPath, fileTypeHint: nil)
            // リピート設定
            backmusicPlayer.numberOfLoops = -1
            backmusicPlayer.play()
        } catch {
            print("エラーが発生しました！")
        }
    }
    
    // Stopボタンがタップされた時の処理
    @objc func stop(_ sender: Any) {
        // バックミュージック停止
        backmusicPlayer.stop()
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
