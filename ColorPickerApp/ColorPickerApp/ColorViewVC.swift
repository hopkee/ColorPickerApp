//
//  ColorViewVC.swift
//  ColorPickerApp
//
//  Created by Valya on 6.02.22.
//

import UIKit

class ColorViewVC: UIViewController, ColorTransfer {

    override func viewDidLoad() {
        super.viewDidLoad()
        noColorSet()
    }
    
    var currentColor: ColorSettings?
    
    @IBOutlet weak var selectColorLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    @IBAction func selectColorBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToColorSet", sender: nil)
    }
    
    private func noColorSet() {
        colorView.layer.borderColor = UIColor.red.cgColor
        colorView.layer.borderWidth = 1
    }
    
    func changeColor(_ color: ColorSettings) {
        selectColorLabel.text = "You've selected this color"
        colorView.layer.backgroundColor = UIColor(red: CGFloat(color.r), green: CGFloat(color.g), blue: CGFloat(color.b), alpha: CGFloat(color.a)).cgColor
        colorView.layer.borderWidth = 0
        currentColor = ColorSettings(r: color.r, g: color.g, b: color.b, a: color.a)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segue = segue.destination as? ColorSetVC else { return }
        segue.delegate = self
        segue.currentColors = currentColor
    }
    
}
