//
//  UrunSatVC.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 1.09.2023.
//

import UIKit

class UrunSatVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var viewModel = ProductViewModel()
    
    @IBOutlet weak var urunAdiTF: UITextField!
    @IBOutlet weak var urunAciklamaTF: UITextField!
    @IBOutlet weak var urunFiyatTF: UITextField!
    @IBOutlet weak var urunIV: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urunIV.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        urunIV.addGestureRecognizer(tapGesture)
    }
    
    
    
    @objc func selectImage() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            urunIV.image = selectedImage
            
            DispatchQueue.global().async {
                self.viewModel.uploadImage(image: selectedImage) { success, imageName in
                    if success {
                        // Resim başarıyla yüklendi
                        print("Resim başarıyla yüklendi: \(imageName ?? "")")
                    } else {
                        // Resim yükleme hatası
                        print("Resim yükleme hatası")
                    }
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func urunYukleButton(_ sender: Any) {
        
        guard let title = urunAdiTF.text, let description = urunAciklamaTF.text, let priceText = urunFiyatTF.text, let price = Double(priceText) else {
             showAlert(title: "HATA", message: "Lütfen tüm alanları doldurun!", ButtonTitle: "Tamam")
             return
         }

         viewModel.uploadProductDetails(title: title, description: description, price: price, imageName: viewModel.uniqueImageName) { [weak self] success in
             if success {
                 // Ürün başarıyla yüklendi
                 DispatchQueue.main.async {
                     self?.showSuccessAndClearFields()
                 }
             } else {
                 // Ürün yükleme hatası
                 print("Ürün yükleme hatası")
             }
         }
        
    }
    
    private func showSuccessAndClearFields() {
        showAlert(title: "Başarılı", message: "Ürün başarıyla yüklendi", ButtonTitle: "Tamam")
        urunAdiTF.text = ""
        urunAciklamaTF.text = ""
        urunFiyatTF.text = ""
        urunIV.image = UIImage(named: "photo") // Varsayılan bir resim
    }
    
}
