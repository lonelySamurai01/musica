//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    override func loadView() {
        let view = UIView()
        
        answerImageView = UIImageView()
        answerImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answerImageView)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answerLabel)
        
        shuffleButton = UIButton()
        shuffleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shuffleButton)

        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        // 背景色設定
        view.backgroundColor = UIColor(red: 29.0/255.0, green: 233.0/255.0, blue: 149.0/255.0, alpha: 1.0)
        
        // ImageViewの左端は、親ビューの左端から0ptの位置
        answerImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        // ImageViewの右端は、親ビューの右端から0ptの位置
        answerImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        // ImageViewの上端は、親ビューの上端から0ptの位置
        answerImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        // ImageViewの下端は、Labelの上端から0ptの位置
        answerImageView.bottomAnchor.constraint(equalTo: answerLabel.topAnchor, constant: 0.0).isActive = true
        // ImageViewの縦横比設定
        answerImageView.contentMode = .scaleAspectFit
        
        // Labelの左端は、親ビューの左端から0ptの位置
        answerLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        // Labelの右端は、親ビューの右端から0ptの位置
        answerLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        // Labelの下端は、Buttonの上端から0ptの位置
        answerLabel.bottomAnchor.constraint(equalTo: shuffleButton.topAnchor, constant: 0.0).isActive = true
        // Labelの高さを40に設定
        answerLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        // Labelの文字色設定
        answerLabel.textColor = .white
        // Label内の文字列をセンタリング
        answerLabel.textAlignment = .center

        // Buttonの左端は、親ビューの左端から0ptの位置
        shuffleButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        // Buttonの右端は、親ビューの右端から0ptの位置
        shuffleButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        // Buttonの下端は、親ビューの上端から0ptの位置
        shuffleButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        // Buttonの高さを100ptに設定
        shuffleButton.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        // Buttonの背景色設定
        shuffleButton.backgroundColor = UIColor(red: 102.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        // Buttonの文字色設定
        shuffleButton.setTitleColor(.white, for: .normal)
        
        answerLabel.text = "これからじゃんけんします"
        shuffleButton.setTitle("じゃんけんをする", for: .normal)
        shuffleButton.addTarget(self, action: #selector(shuffleAction(_:)), for: .touchUpInside)
    }

    var answerImageView: UIImageView!
    
    var answerLabel: UILabel!
    
    var shuffleButton:UIButton!
    
    // じゃんけん（数字）
    var answerNumber = 0
    
    @objc func shuffleAction(_ sender: AnyObject) {
        
        // 新しいじゃんけんの結果を一時的に格納する変数を設ける
        // arc4random_uniform()の戻り値がUInt32なので明示的に型を指定
        var newAnswerNumber = 0
        
        // ランダムに結果を出すが、前回の結果と異なる場合のみ採用
        // repeat は繰り返しを意味する
        repeat {
            
            // 0,1,2の数値をランダムに算出（乱数）
            newAnswerNumber = Int(arc4random_uniform(3))
            
            // 前回と同じ結果のときは、再度、ランダムに数値をだす
            // 異なる結果のときは、repeat を抜ける
        } while answerNumber == newAnswerNumber
        
        // 新しいじゃんけんの結果を格納
        answerNumber = newAnswerNumber
        
        if answerNumber == 0 {
            // グー
            answerLabel.text = "グー"
            answerImageView.image = UIImage(named: "gu")
            
        } else if answerNumber == 1 {
            // チョキ
            answerLabel.text = "チョキ"
            answerImageView.image = UIImage(named: "choki")
            
        } else if answerNumber == 2 {
            // パー
            answerLabel.text = "パー"
            answerImageView.image = UIImage(named: "pa")
            
        }
    }

}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

