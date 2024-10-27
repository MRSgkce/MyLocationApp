//
//  ViewController.swift
//  MyLocationApp
//
//  Created by Mürşide Gökçe on 26.10.2024.
//
import UIKit
import CoreLocation
import MapKit


class Main: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var suankiEnlem: UILabel!
    @IBOutlet weak var suankiBoylam: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var cities: [City] = []
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        table.delegate = self
        table.dataSource = self
        
        fetchCities()  // Şehirleri masaüstünden çekiyoruz
        table.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Ekrana geri dönüldüğünde şehirleri yeniden çek
            fetchCities()
            table.reloadData()
        }
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func fetchCities() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("cities.txt")
        
        do {
            let data = try Data(contentsOf: fileURL)
            cities = try JSONDecoder().decode([City].self, from: data)
            print("Şehirler başarıyla okundu.")
        } catch {
            print("Hata: \(error)")
        }
    }

    
    // UITableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let city = cities[indexPath.row]
        
        cell.textLabel?.text = city.city
        
        // Hücrede mevcut olan eski butonları temizleyin
        if let oldButton = cell.contentView.viewWithTag(100) as? UIButton {
            oldButton.removeFromSuperview()
        }
        
        // Simgeli Silme Butonu Oluşturma
        let deleteButton = UIButton(type: .system)
        if let trashImage = UIImage(systemName: "trash") { // Çöp kutusu simgesini kullan
            deleteButton.setImage(trashImage, for: .normal)
        }
        deleteButton.tag = indexPath.row
        deleteButton.addTarget(self, action: #selector(sehriSil(_:)), for: .touchUpInside)
        deleteButton.tintColor = .red // İsteğe bağlı olarak buton rengi
        
        // Butonu hücreye ekleyin ve konumlandırın
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
            deleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        return cell
    }





    
    // Segue ile detay sayfasına geçiş
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let city = sender as? City {
                let destinationVC = segue.destination as! CityInfoViewController
                destinationVC.cityInfo = city
            }
        }
    }
    
    // Satır seçimi ile segue başlatma
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: city)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
   
    
    @IBAction func sehriSil(_ sender: UIButton) {
        let index = sender.tag // Butonun tag'inden şehir indeksini al
        
        if index < cities.count {
            deleteCity(at: index) // Şehri sil
        } else {
            print("Geçersiz indeks: \(index)")
        }
    }




    func deleteCity(at index: Int) {
        cities.remove(at: index)
        
        saveCitiesToJSON()  // Güncellenmiş diziyi JSON dosyasına kaydet
        table.reloadData()   // Tabloyu tamamen yeniden yükle
    }






    func saveCitiesToJSON() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("cities.txt")
        
        do {
            let jsonData = try JSONEncoder().encode(cities)
            try jsonData.write(to: fileURL)
            print("Şehirler başarıyla kaydedildi.")
        } catch {
            print("Hata: \(error)")
        }
    }

    
}

extension Main: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let sonKonum = locations.last else { return }
        
        suankiEnlem.text = String(sonKonum.coordinate.latitude)
        suankiBoylam.text = String(sonKonum.coordinate.longitude)
        
        let konum = CLLocation(latitude: sonKonum.coordinate.latitude, longitude: sonKonum.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: konum.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true

        print("Enlem: \(sonKonum.coordinate.latitude), Boylam: \(sonKonum.coordinate.longitude)")
    }
    
    
}
 
