//
//  UpdateViewController.swift
//  MyLocationApp
//
//  Created by Mürşide Gökçe on 27.10.2024.
//
import UIKit


import UIKit

class UpdateViewController: UIViewController {
    @IBOutlet weak var ad: UITextField!
    @IBOutlet weak var enlem: UITextField!
    @IBOutlet weak var boylam: UITextField!
    @IBOutlet weak var plaka: UITextField!

    var cityInfo: City?
    var cities: [City]?
    var cityIndex: Int?
    var onUpdate: ((City) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cityInfo'nun dolu olup olmadığını kontrol et
        guard let city = cityInfo else {
            print("cityInfo boş, güncelleme yapılamaz!")
            showAlert(message: "Şehir bilgisi eksik, güncelleme yapılamaz.")
            return
        }

        // UI'yi doldur
        ad.text = city.city // sehirAdi yerine ad kullandık
        plaka.text = String(city.plate ?? 0) // sehirPlaka yerine plaka kullandık
        enlem.text = String(city.latitude ?? 0.0) // sehirEnlem yerine enlem kullandık
        boylam.text = String(city.longitude ?? 0.0) // sehirBoylam yerine boylam kullandık
    }

    @IBAction func guncelleButonu(_ sender: Any) {
        guard let cityName = ad.text, !cityName.isEmpty,
              let plakaText = plaka.text, let plaka = Int(plakaText),
              let enlemText = enlem.text, let enlem = Double(enlemText),
              let boylamText = boylam.text, let boylam = Double(boylamText) else {
            print("Geçersiz girdi")
            showAlert(message: "Lütfen tüm alanları doğru şekilde doldurun.")
            return
        }

        // Güncellenmiş şehir nesnesini oluştur
        let updatedCity = City(
            city: cityName,
            plate: plaka,
            latitude: enlem,
            longitude: boylam
        )

        // Güncelleme tamamlandığında closure'ı çağır
        onUpdate?(updatedCity)

        // Geri dön
        navigationController?.popViewController(animated: true)
    }

    // Hata mesajı göstermek için yardımcı bir fonksiyon
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
