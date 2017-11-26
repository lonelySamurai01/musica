//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        
        backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        countDownLabel = UILabel()
        countDownLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countDownLabel)
        
        startButton = UIButton()
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)

        stopButton = UIButton()
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stopButton)
        
        self.view = view
    }
    
    // タイマーの変数を作成
    var timer : Timer?
    // カウント(経過時間)の変数を作成
    var count = 0
    // 設定値を扱うキーを設定
    let settingKey = "timer_value"
    
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
        backgroundImageView.image = UIImage(named: "bg")
        
        // Labelは、中央から(0,-100)に設定
        countDownLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        countDownLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
        
        // Startボタンの中央から(-80,100)に設定
        startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -80).isActive = true
        startButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 100).isActive = true
        // Startボタンに画像を設定
        startButton.setImage(UIImage(named: "btn_start"), for: .normal)
        // Startボタンをタップしたときにメソッド実行するように設定
        startButton.addTarget(self, action: #selector(startButtonAction(_:)), for: .touchUpInside)

        // Stopボタンの中央から(80,100)に設定
        stopButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 80).isActive = true
        stopButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 100).isActive = true
        // Stopボタンに画像を設定
        stopButton.setImage(UIImage(named: "btn_stop"), for: .normal)
        // Stopボタンをタップしたときにメソッド実行するように設定
        stopButton.addTarget(self, action: #selector(stopButtonAction(_:)), for: .touchUpInside)
        
        // 設定ボタンをナビゲーションバーに追加する
        settingButton = UIBarButtonItem(title: "設定", style: .plain, target: self, action: #selector(settingButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = settingButton

        // UserDefaultsのインスタンスを生成
        let settings = UserDefaults.standard
        // UserDefaultsに初期値を登録
        settings.register(defaults: [settingKey:10])
    }

    var countDownLabel: UILabel!
    var backgroundImageView:UIImageView!
    var settingButton: UIBarButtonItem!
    var startButton: UIButton!
    var stopButton: UIButton!

    @objc func settingButtonAction(_ sender: Any) {
        // timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            // もしタイマーが、実行中だったら停止
            if nowTimer.isValid == true {
                // タイマー停止
                nowTimer.invalidate()
            }
        }
        // 画面遷移を行う(SegueがPlaygroundでは使えないので別の方法で遷移しています)
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    @objc func startButtonAction(_ sender: Any) {
        // timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            // もしタイマーが、実行中だったらスタートしない
            if nowTimer.isValid == true {
                // 何も処理しない
                return
            }
        }
        
        // タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(self.timerInterrupt(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func stopButtonAction(_ sender: Any) {
        // timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            // もしタイマーが、実行中だったら停止
            if nowTimer.isValid == true {
                // タイマー停止
                nowTimer.invalidate()
            }
        }
    }
    
    // 画面の更新をする(戻り値：remainCount:残り時間)
    func displayUpdate() -> Int {
        
        // UserDefaultsのインスタンスを生成
        let settings = UserDefaults.standard
        // 取得した秒数をtimerValueに渡す
        let timerValue = settings.integer(forKey: settingKey)
        // 残り時間(remainCount)を生成
        let remainCount = timerValue - count
        // remainCount(残りの時間)をラベルに表示
        countDownLabel.text = "残り\(remainCount)秒"
        // 残り時間を戻り値に設定
        return remainCount
        
    }
    
    // 経過時間の処理
    @objc func timerInterrupt(_ timer:Timer) {
        
        // count(経過時間)に+1していく
        count += 1
        // remainCount(残り時間)が0以下のとき、タイマーを止める
        if displayUpdate() <= 0 {
            // 初期化処理
            count = 0
            // タイマー停止
            timer.invalidate()
        }
    }

    // 画面切り替えのタイミングで処理を行なう
    override func viewDidAppear(_ animated: Bool) {
        // カウント(経過時間)をゼロにする
        count = 0
        // タイマーの表示を更新する
        _ = displayUpdate()
    }
}

// 設定画面
class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    override func loadView() {
        let view = UIView()
        
        backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        timerSettingPicker = UIPickerView()
        timerSettingPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerSettingPicker)
        
        decisionButton = UIButton()
        decisionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(decisionButton)
        
        self.view = view
    }

    var backgroundImageView:UIImageView!
    var decisionButton: UIButton!
    // 秒数表示パーツの宣言
    var timerSettingPicker: UIPickerView!

    // UIPickerViewに表示するデータをArrayで作成
    let settingArray : [Int] = [10,20,30,40,50,60]
    
    // 設定値を覚えるキーを設定
    let settingKey = "timer_value"
    
    // SettingViewControllerの起動時に一度だけ実行される
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        // ImageViewの背景色を設定（Mercury相当)
        backgroundImageView.backgroundColor = UIColor(red: (230.0/255.0), green: (230.0/255.0), blue: (230.0/255.0), alpha: 1.0)
        
        // timerSettingPickerの左端は、親ビューの左端から0ptの位置
        timerSettingPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        // timerSettingPickerの右端は、親ビューの右端から0ptの位置
        timerSettingPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        // timerSettingPickerの上端は、親ビューの上端から0ptの位置
        timerSettingPicker.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true

        // Startボタンの中央から(0,100)に設定
        decisionButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        decisionButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 100).isActive = true
        // Startボタンに画像を設定
        decisionButton.setImage(UIImage(named: "btn_ decision"), for: .normal)
        // Startボタンをタップしたときにメソッド実行するように設定
        decisionButton.addTarget(self, action: #selector(decisionButtonAction(_:)), for: .touchUpInside)

        // timerSettingPickerのデリゲートとデータソースの通知先を指定
        timerSettingPicker.delegate = self
        timerSettingPicker.dataSource = self
        
        // UserDefaultsの取得
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        
        // Pickerの選択を合わせる
        for row in 0..<settingArray.count {
            if settingArray[row] == timerValue {
                timerSettingPicker.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }
    
    // 決定ボタンがタップされた時に実行される
    @IBAction func decisionButtonAction(_ sender: Any) {
        // 前画面に戻る
        _ = navigationController?.popViewController(animated: true)
    }
    
    // UIPickerViewの列数を設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数を取得
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return settingArray.count
    }
    
    // UIPickerViewの表示する内容を設定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return String(settingArray[row])
    }
    
    // picker選択時に実行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // UserDefaultsの設定
        let settings = UserDefaults.standard
        settings.setValue(settingArray[row], forKey: settingKey)
        settings.synchronize()
    }
}

// Present the view controller in the Live View window
//PlaygroundPage.current.liveView = MyViewController()
PlaygroundPage.current.liveView = UINavigationController(rootViewController: MyViewController())
