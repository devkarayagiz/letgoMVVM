//
//  ProductViewModel.swift
//  LetGoMVVM
//
//  Created by Yasin Halit Karayağız on 29.01.2024.
//

import UIKit
import FirebaseAuth

class ProductViewModel {

    private let auth : Auth = Auth.auth()
    var uniqueImageName: String = ""

    
    //İLAN YÜKLEMESİNİ YAPTIĞIMIZ FONKSİYON

    func uploadProductDetails(title: String, description: String, price: Double, imageName: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://www.gulsumaydemir.com/ekle.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "baslik=\(title)&resim=\(imageName)&icerik=\(description)&fiyat=\(price)&kullaniciid=\(auth.currentUser?.uid ?? "")"
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                completion(false)
            } else if let data = data {
                // Burada sunucu yanıtını işleyin
                let json = try? JSONSerialization.jsonObject(with: data)
                print(json)
                completion(true)
            }
        }.resume()
    }
    
    
    //RESİM YÜKLEME İŞLEMİNİ YAPTIĞIMIZ FONKSİYON
    
    func uploadImage(image: UIImage, completion: @escaping (Bool, String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(false, nil)
            return
        }
        var req = URLRequest(url: URL(string: "https://www.gulsumaydemir.com/resimyukle.php")!)
        req.httpMethod = "POST";
        let params = ["guvenlik":"1"]
        let boundary = "Boundary-\(NSUUID().uuidString)"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let data = imageData
        uniqueImageName = UUID().uuidString + ".jpg"
        req.httpBody = Parametre(parameters: params, filePathKey: "file", imageDataKey: data as NSData,boundary: boundary, resimname: uniqueImageName) as Data
        
        URLSession.shared.dataTask(with: req as URLRequest) {
            data, response, error in
            if error != nil {
                print("hata \(error?.localizedDescription)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                    print("jsonHata \(json)")
                    if let sonuc = json["success"] as? String {
                        if sonuc == String("OK") {
                            //self.verigonder()
                            completion(true, nil)
                        }else{
                            //print("Hata oluştu")
                            completion(false, "nil")
                        }
                    }
                }
                
            }catch
            {
                print(error)
            }
            
        }.resume()
        
    }
    
    func Parametre(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String,resimname:String) -> NSData {
        
        // Parametre adında bir fonksiyon tanımlıyoruz.
        //Bu fonksiyonun beş parametresi vardır: parameters, filePathKey, imageDataKey, boundary ve resimname. Fonksiyon NSData türünde bir değer döndürür.
        
        
        let body = NSMutableData();
        //NSMutableData türünde bir body değişkeni oluşturur. Bu değişken, oluşturulacak HTTP gövdesini tutmak için kullanılır.
        
        if parameters != nil {
            //Eğer parameters nil değilse, bu sözlükteki her anahtar-değer çifti için bir döngü başlatır.
            //Her çift için, boundary ile ayrılmış ve HTTP form verisi olarak formatlanmış bir string ekler.
            
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        
        let dosyaturu = "image/jpg"
        //Dosya türünü belirten bir değişken tanımlar. Burada, dosya türü "image/jpg" olarak belirlenmiştir.
        
        
        //-------------------------------------------------------------------------------------------------------------------
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(resimname)\"\r\n")
        body.appendString(string: "Content-Type: \(dosyaturu)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        
        /*
         Yukarıkda, resimle ilgili verileri body'ye ekleme işlemini yapıyoruz. İlk satırda, boundary kullanarak yeni bir bölüm başlatıyoruz.
         Content-Disposition ve Content-Type başlıklarını ayarlıyoruz. Bunlar, gönderilen verinin bir dosya olduğunu ve dosya türünün ne olduğunu belirtiyoruz.
         imageDataKey'i (ki bu aslında resmin kendisi) body'ye ekliyoruz.
         Son olarak, boundary ile bölümünü kapatıyoruz.
         */
        
        //-------------------------------------------------------------------------------------------------------------------
        
        return body
        // return body diyerek de hazırlanan NSData nesnesini döndürüyoruz.
        
    }
     
    
}

extension NSMutableData

/*
 
 NSMutableData Swift ve Objective-C programlama dillerinde kullanılan bir sınıftır ve Foundation framework'ün bir parçasıdır. Bu sınıf, düzenlenebilir (modifiye edilebilir) veri depolama alanını temsil eder. Esasen, bayt dizilerini (bytes) depolamak ve yönetmek için kullanılır. NSMutableData sınıfı, NSData sınıfından türemiştir ve NSData'nın tüm özelliklerini içerir, ancak ek olarak depolanan verileri değiştirme yeteneğine sahiptir.

 NSMutableData'nın temel özellikleri ve kullanım alanları şunlardır:

 Dinamik Boyut: NSMutableData nesnesinin boyutu, veri eklendiğinde veya çıkarıldığında dinamik olarak değişebilir. Bu, veri kümelerinin boyutlarının önceden bilinmediği durumlarda faydalıdır.

 Veri Değişikliği: Mevcut veriye yeni veri eklenebilir, veriden bazı parçalar çıkarılabilir veya mevcut veri üzerinde değişiklik yapılabilmektedir.

 Dosya ve Ağ İşlemleri: NSMutableData genellikle dosya okuma-yazma işlemleri ve ağ üzerinden veri alışverişi sırasında kullanılır. Örneğin, bir ağ isteğinin gövdesi oluşturulurken veya bir dosyadan okunan veriler işlenirken kullanılabilir.

 Performans: Büyük veri blokları üzerinde çalışırken, NSMutableData veri eklemesi veya değişikliği yapılırken yüksek performans sağlar. Veri bloğunun tamamının her değişiklikte kopyalanmasını önleyerek, işlemlerin daha hızlı yapılmasına olanak tanır.

 Uyumluluk ve Geniş Kullanım: NSMutableData iOS ve macOS uygulamalarında yaygın olarak kullanılır ve Apple'ın Cocoa API'sinin bir parçasıdır, bu da onu Apple platformlarında uygulama geliştirenler için standart bir seçenek haline getirir.

 Özetle, NSMutableData veri depolamak ve bu veriler üzerinde değişiklik yapmak için kullanılan, esnek ve güçlü bir sınıftır. Uygulamalarınızda dinamik veri yönetimi gerektiğinde bu sınıfı kullanabilirsiniz.
 
 
 */

{
    
    func appendString(string: String) {
        
        /*
         NSMutableData'ya bir extension (uzantı) yazılmasının ana nedeni, NSMutableData sınıfına özel bir işlevsellik eklemektir. Bu özel işlevsellik, String tipindeki veriyi NSMutableData nesnesine eklemeyi kolaylaştırır. Swift'te, extensionlar bir sınıfa yeni metodlar veya hesaplanmış özellikler eklemek için sıkça kullanılır.

         Özellikle bu durumda, NSMutableData sınıfına appendString adında bir metod eklenmiştir:
         
         Bu metodun amacı şunlardır:

         String Kolaylığı: NSMutableData aslen bayt dizileri ile çalışır. Ancak, birçok durumda, geliştiricilerin veriyi String formatında eklemek istedikleri durumlar olabilir. Örneğin, bir HTTP isteğinin gövdesini oluştururken, çeşitli string parçalarını eklemek gerekebilir. Bu extension, String tipindeki verileri doğrudan NSMutableData'ya eklemeye olanak tanır.

         UTF-8 Kodlaması: Extension, stringleri UTF-8 formatında kodlar. Bu, ağ üzerinden veri gönderirken genellikle tercih edilen bir format olduğundan bu işlem oldukça yararlıdır.

         Kolaylık ve Okunabilirlik: Bu metod, NSMutableData nesnesine string eklemeyi tek satırlık bir işlem haline getirir ve kodun okunabilirliğini artırır. Böylece, NSMutableData nesnesine string eklemek için her seferinde ayrı ayrı dönüşüm yapmak yerine, bu işlevi tek bir metod çağrısıyla halledebilirsiniz.

         Genel Kullanım: Bu tür bir extension, HTTP istekleri, veri işleme ve benzeri birçok durumda kullanışlı olabilir, bu nedenle genel bir çözüm olarak kabul edilir.

         Kısacası, bu extension, NSMutableData ile çalışmayı daha esnek ve kolay hale getirmek için tasarlanmıştır. Bu, Swift'in sağladığı güçlü bir özellik olan extension mekanizmasının tipik bir kullanım örneğidir.
         
         */
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
