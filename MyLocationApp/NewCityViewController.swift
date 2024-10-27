//
//  NewCityViewController.swift
//  MyLocationApp
//
//  Created by Mürşide Gökçe on 26.10.2024.
//

import UIKit
import CoreLocation
import MapKit


class NewCityViewController: UIViewController {

    @IBOutlet weak var plaka: UITextField!
    @IBOutlet weak var longitudeDegeri: UITextField!
    @IBOutlet weak var latitudeDegeri: UITextField!
    @IBOutlet weak var sehirAdi: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func kaydetButonu(_ sender: Any) {
        // Kullanıcıdan alınan verileri oku
        guard let cityName = sehirAdi.text, !cityName.isEmpty,
              let plateString = plaka.text, let plate = Int(plateString),
              let latitudeString = latitudeDegeri.text, let latitude = Double(latitudeString),
              let longitudeString = longitudeDegeri.text, let longitude = Double(longitudeString) else {
            print("Lütfen tüm alanları doldurun.")
            return
        }
        
        // Yeni şehir nesnesi oluştur
        let newCity = City(city: cityName, plate: plate, latitude: latitude, longitude: longitude)

        // JSON dosyasına ekleme işlemini yap
        saveCityToJSON(newCity)
    }
    
    func saveCityToJSON(_ city: City) {
        // Belgeler dizinindeki cities.txt dosyasını oku
        let fileURL = getDocumentsDirectory().appendingPathComponent("cities.txt")
        
        // Dosyayı okuma işlemi
        var cities: [City] = []
        do {
            let data = try Data(contentsOf: fileURL)
            cities = try JSONDecoder().decode([City].self, from: data)
        } catch {
            print("Dosya okunurken hata: \(error)")
        }
        
        // Yeni şehri ekle
        cities.append(city)

        // Yeni JSON verisini yaz
        do {
            let jsonData = try JSONEncoder().encode(cities)
            try jsonData.write(to: fileURL)
            print("Şehir başarıyla kaydedildi.")
        } catch {
            print("Hata: \(error)")
        }
    }
    
    // Belgeler dizinini almak için yardımcı fonksiyon
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
