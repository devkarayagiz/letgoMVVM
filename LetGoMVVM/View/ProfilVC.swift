//
//  ProfilVC.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 31.08.2023.
//

import UIKit
import SDWebImage

class ProfilVC: UIViewController {
    
    @IBOutlet weak var mesajDetayBtn: UIButton!
    
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var adsoyadLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = ProfilViewModel()
    
    var viewModelRSS = ProfileRssViewModel()
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        //MARK: - PROFİL BİLGİERİNİ GETİR

            viewModel.updateUI = { [weak self] in
                DispatchQueue.main.async {
                    if let profil = self?.viewModel.profil?.first {
                        self?.adsoyadLabel.text = profil.adsoyad

                        // URL oluştur ve SDWebImage ile resmi yükle
                        if let url = URL(string: "https://www.gulsumaydemir.com/resimler/\(profil.resim)") {
                            self?.profilImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"))
                                            }
                    }
                }
            }

            if let kullaniciID = UserDefaults.standard.string(forKey: "kullaniciid") {
                viewModel.fetchProfilData(forUserID: kullaniciID)
            } else {
                print("Kullanıcı ID bulunamadı")
            }
        
        getDataRss()
        }
    private var list : [ProfileRSSArrayModel]?
    private func getDataRss() {
        viewModelRSS.getData { model in
            self.list = model.liste
            print("data : \(model.liste)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    //MARK: - ÇIKIŞ YAP BUTTON
    
    @IBAction func cikisButton(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let dc  = sb.instantiateViewController(withIdentifier: "girisyap") as? GirisYapVC {
            dc.modalPresentationStyle = .fullScreen
            userPref().loginStatusLogOut()
            self.present(dc, animated: true)
        }

        
        
    }
    
    @IBAction func mesajDetayButon(_ sender: Any) {
    }
}

//MARK: - COLLECTIONVIEW

extension ProfilVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilcell", for: indexPath) as! ProfilCell
        let item = list?[indexPath.row]
        
        cell.profilUrunAdi.text = item?.baslik
        cell.profilUrunResmi.sd_setImage(with: URL(string: "https://gulsumaydemir.com/resimler/" + (item?.resim ?? "")), completed: nil)
        return cell
    }
}
