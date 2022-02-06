//
//  ColorSetVC.swift
//  ColorPickerApp
//
//  Created by Valya on 6.02.22.
//

import UIKit

struct ColorSettings {
    let r: Float
    let g: Float
    let b: Float
    let a: Float
}

protocol ColorTransfer: AnyObject {
    func changeColor(_ color: ColorSettings)
}

extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

class ColorSetVC: UIViewController{
       
    // Lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        setMainView()
        setColors()
        setPreview()
    }
    
    // Delegates
    weak var delegate: ColorTransfer?
    
    // Varibales
    var currentColors: ColorSettings?

    // Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var redColorField: UITextField!
    @IBOutlet weak var greenColorField: UITextField!
    @IBOutlet weak var blueColorField: UITextField!
    @IBOutlet weak var hexColorField: UITextField!
    @IBOutlet weak var opacityFiled: UITextField!
    @IBOutlet weak var previewColor: UIView!
    @IBOutlet weak var redColorSlider: UISlider!
    @IBOutlet weak var greenColorSlider: UISlider!
    @IBOutlet weak var blueColorSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    
    // Actions
    @IBAction func redColorFieldSet(_ sender: UITextField) {
        redColorSlider.value = Services.rgbConvert(sender.text)
        setPreview()
        setHexField()
    }
    @IBAction func greenColorFieldSet(_ sender: UITextField) {
        greenColorSlider.value = Services.rgbConvert(sender.text)
        setPreview()
        setHexField()
    }
    @IBAction func blueColorFieldSet(_ sender: UITextField) {
        blueColorSlider.value = Services.rgbConvert(sender.text)
        setPreview()
        setHexField()
    }
    @IBAction func hexColorFiledSet(_ sender: UITextField) {
        setAllSlidersForHex()
    }
    @IBAction func opacityFiledSet(_ sender: UITextField) {
        opacitySlider.value = Services.rgbConvert(sender.text)
        setPreview()
        setHexField()
    }
    @IBAction func opacitySliderSet(_ sender: UISlider) {
        opacityFiled.text = String((sender.value * 100).rounded() / 100)
        setPreview()
        setHexField()
    }
    @IBAction func selectColorBtn(_ sender: UIButton) {
        let color = ColorSettings(r: redColorSlider.value, g: greenColorSlider.value, b: blueColorSlider.value, a: opacitySlider.value)
        delegate?.changeColor(color)
    }
    @IBAction func redSliderChange(_ sender: UISlider) {
        redColorField.text = String((sender.value * 100).rounded() / 100)
        setPreview()
        setHexField()
    }
    @IBAction func greenSliderChange(_ sender: UISlider) {
        greenColorField.text = String((sender.value * 100).rounded() / 100)
        setPreview()
        setHexField()
    }
    @IBAction func blueSliderChange(_ sender: UISlider) {
        blueColorField.text = String((sender.value * 100).rounded() / 100)
        setPreview()
        setHexField()
    }

    // Functions
    private func setMainView() {
        mainView.layer.cornerRadius = 15
    }
    
    private func setColors(){
        if let red = currentColors?.r,
            let green = currentColors?.g,
            let blue = currentColors?.b,
            let alpha = currentColors?.a {
            redColorSlider.value = red
            greenColorSlider.value = green
            blueColorSlider.value = blue
            opacitySlider.value = alpha
            redColorField.text = String((red * 100).rounded() / 100)
            greenColorField.text = String((green * 100).rounded() / 100)
            blueColorField.text = String((blue * 100).rounded() / 100)
            opacityFiled.text = String((alpha * 100).rounded() / 100)
        }
    }
    
    private func setPreview() {
        let red = redColorSlider.value
        let green = greenColorSlider.value
        let blue = blueColorSlider.value
        let alpha = opacitySlider.value
        previewColor.layer.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)).cgColor
    }
    
    private func setHexField() {
        let red = redColorSlider.value
        let green = greenColorSlider.value
        let blue = blueColorSlider.value
        let alpha = opacitySlider.value
        let hexColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)).toHexString()
        hexColorField.text = hexColor
    }
    
    private func setAllSlidersForHex() {
        if let stringColor = hexColorField.text {
            let color = UIColor(hex: stringColor)
            if let color = color {
            let ciColor = CIColor(color: color)
                let red = ciColor.red
                let green = ciColor.green
                let blue = ciColor.blue
                let alpha = ciColor.alpha
                redColorSlider.value = Float(red)
                greenColorSlider.value = Float(green)
                blueColorSlider.value = Float(blue)
                opacitySlider.value = Float(alpha)
            }
        }
    }
}
