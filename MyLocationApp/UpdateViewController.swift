//
//  UpdateViewController.swift
//  MyLocationApp
//
//  Created by Mürşide Gökçe on 27.10.2024.
//import UIKit

import UIKit
import CoreLocation
import MapKit


class UpdateViewController: UIViewController {
    @IBOutlet weak var ad: UITextField!       // Şehir adı
    @IBOutlet weak var enlem: UITextField!    // Enlem
    @IBOutlet weak var boylam: UITextField!    // Boylam
    @IBOutlet weak var plaka: UITextField!     // Plaka

    var cityInfo: City?
    var onUpdate: ((City) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Eğer cityInfo varsa, bilgileri yükle
        if let city = cityInfo {
            ad.text = city.city
            enlem.text = String(city.latitude!)
            boylam.text = String(city.longitude!)
            plaka.text = String(city.plate!)
        }
    }

    @IBAction func guncelle(_ sender: Any) {
        // Güncellenmiş şehir bilgilerini al
        guard let updatedCityName = ad.text, !updatedCityName.isEmpty,
              let updatedLatitude = Double(enlem.text ?? ""),
              let updatedLongitude = Double(boylam.text ?? ""),
              let updatedPlate = Int(plaka.text ?? "") else {
            // Hata durumu: eksik veya geçersiz bilgiler
            return
        }
        
        // Güncellenmiş şehir bilgisini oluştur
        if var city = cityInfo {
            city.city = updatedCityName
            city.latitude = updatedLatitude
            city.longitude = updatedLongitude
            city.plate = updatedPlate
            
            // Güncellenmiş şehir bilgisini geri gönder
            onUpdate?(city)
            navigationController?.popViewController(animated: true) // Geri dön
        }
    }
}
