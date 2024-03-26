//
//  DetailVC.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 2.09.2023.
//

import UIKit
import SDWebImage

class DetailVC: UIViewController {
    
    var selectedData: AkisModel?
    
    @IBOutlet weak var messageBtn: UIImageView!
    @IBOutlet weak var productIV: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let data = selectedData {
            
            productTitle.text = data.baslik
            productIV.sd_setImage(with: URL(string: "https://gulsumaydemir.com/resimler/\(data.resim)"))
            productDescription.text = data.icerik
            productPrice.text = "\(data.fiyat) TL"
            
        }
        messageBtn.isUserInteractionEnabled = true
        messageBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(messageFunc)))
        
    }
    @objc func messageFunc(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let dc = sb.instantiateViewController(identifier: "MessageVC") as? MessageVC {
            dc.modalPresentationStyle = .fullScreen
            dc.selectedData = selectedData
            self.present(dc, animated: true)
        }
    }
}
