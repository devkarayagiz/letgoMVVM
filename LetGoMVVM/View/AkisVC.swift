//
//  AkisVC.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 31.08.2023.
//

import UIKit
import SDWebImage

class AkisVC: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let akisViewModel = AkisViewModel()
    
    let searchController = UISearchController()
    
    private var refreshControl = UIRefreshControl()
    

    override func viewWillAppear(_ animated: Bool) {
        
        akisViewModel.verileriCek(aramaMetni: "") { [weak self] in
            DispatchQueue.main.async {
                
                self!.collectionView.reloadData()
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        collectionView.register(AkisCell.self, forCellWithReuseIdentifier: "AkisCell")
        
        akisViewModel.verileriCek(aramaMetni: "") { [weak self] in
            DispatchQueue.main.async {
                
                self!.collectionView.reloadData()
                
            }
        }
        
        }
    
    @objc private func refreshData() {
        
        akisViewModel.verileriCek(aramaMetni: "") { [weak self] in
            DispatchQueue.main.async {
                
                self!.collectionView.reloadData()
                
            }
        }
        
        // Verileri yeniden yükledikten sonra, UIRefreshControl'ı durdurun
        refreshControl.endRefreshing()
    }
}


extension AkisVC : UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        akisViewModel.verileriCek(aramaMetni: text) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return akisViewModel.veriSayisi()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AkisCell
        let veri = akisViewModel.veri(index: indexPath.item)
        cell.productTitle.text = veri.baslik
        cell.productIV.sd_setImage(with: URL(string: "https://gulsumaydemir.com/resimler/\(veri.resim)"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secilenItem = akisViewModel.veri(index: indexPath.item)
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Storyboard adınızı ve bundle'ı uygun şekilde ayarlayın
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            detailVC.selectedData = secilenItem
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailSegue" {
            if let destinationVC = segue.destination as? DetailVC {
                if let selectedData = sender as? AkisModel {
                    destinationVC.selectedData = selectedData
                }
            }
        }
    }
    
    
}
