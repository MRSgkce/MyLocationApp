import UIKit
import CoreLocation
import MapKit
/*
class Main: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var suankiEnlem: UILabel!
    @IBOutlet weak var suankiBoylam: UILabel!
    @IBOutlet weak var table: UITableView!
    var currentLocation: CLLocation?

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
        fetchCities()  // Ekrana geri dönüldüğünde şehirleri yeniden çek
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

    func saveCitiesToJSON() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("cities.txt")
        
        do {
            let jsonData = try JSONEncoder().encode(cities)
            try jsonData.write(to: fileURL)
            print("Şehirler başarıyla kaydedildi.")
            print("Dosya yolu: \(fileURL.path)")
        } catch {
            print("Hata: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let city = cities[indexPath.row]
        
        cell.textLabel?.text = city.city
        
        if let oldButton = cell.contentView.viewWithTag(100) as? UIButton {
            oldButton.removeFromSuperview()
        }
        
        let deleteButton = UIButton(type: .system)
        if let trashImage = UIImage(systemName: "trash") {
            deleteButton.setImage(trashImage, for: .normal)
        }
        deleteButton.tag = indexPath.row
        deleteButton.addTarget(self, action: #selector(sehriSil(_:)), for: .touchUpInside)
        deleteButton.tintColor = .red
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
            deleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        return cell
    }
    
    @IBAction func sehriSil(_ sender: UIButton) {
        let index = sender.tag
        
        if index < cities.count {
            cities.remove(at: index)
            saveCitiesToJSON()
            table.reloadData()
        } else {
            print("Geçersiz indeks: \(index)")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: (city, currentLocation))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let (city, location) = sender as? (City, CLLocation),
               let destinationVC = segue.destination as? CityInfoViewController {
                destinationVC.cityInfo = city
                destinationVC.currentLocation = location
                
                destinationVC.onUpdate = { [weak self] updatedCity in
                    guard let self = self else { return }
                    if let index = self.cities.firstIndex(where: { $0.city == updatedCity.city }) {
                        self.cities[index] = updatedCity
                        self.saveCitiesToJSON()
                        self.table.reloadData()
                    }
                }
            }
        }
    }
    
    
    @IBAction func guncelleye(_ sender: Any) {
    }
}

extension Main: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let sonKonum = locations.last else { return }
        currentLocation = sonKonum
        
        suankiEnlem.text = String(sonKonum.coordinate.latitude)
        suankiBoylam.text = String(sonKonum.coordinate.longitude)
        
        let konum = CLLocation(latitude: sonKonum.coordinate.latitude, longitude: sonKonum.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: konum.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}
*/


class Main: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var suankiEnlem: UILabel!
    @IBOutlet weak var suankiBoylam: UILabel!
    @IBOutlet weak var table: UITableView!
    var currentLocation: CLLocation?

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
        fetchCities()  // Ekrana geri dönüldüğünde şehirleri yeniden çek
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

    func saveCitiesToJSON() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("cities.txt")
        
        do {
            let jsonData = try JSONEncoder().encode(cities)
            try jsonData.write(to: fileURL)
            print("Şehirler başarıyla kaydedildi.")
            print("Dosya yolu: \(fileURL.path)")
        } catch {
            print("Hata: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let city = cities[indexPath.row]
        
        cell.textLabel?.text = city.city
        
        // Silme butonu
        let deleteButton = UIButton(type: .system)
        if let trashImage = UIImage(systemName: "trash") {
            deleteButton.setImage(trashImage, for: .normal)
        }
        deleteButton.tag = indexPath.row
        deleteButton.addTarget(self, action: #selector(sehriSil(_:)), for: .touchUpInside)
        deleteButton.tintColor = .red
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
            deleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])

        // Güncelleme butonu (şimdi bir resim)
        let updateButton = UIButton(type: .system)
        if let updateImage = UIImage(systemName: "pencil") { // Güncelleme için kalem resmi
            updateButton.setImage(updateImage, for: .normal)
        }
        updateButton.tag = indexPath.row // Tag'i şehir indexi ile ayarla
        updateButton.addTarget(self, action: #selector(guncelleye(_:)), for: .touchUpInside) // Aksiyonunu bağla
        updateButton.tintColor = .blue // Resmin rengi
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(updateButton)
        NSLayoutConstraint.activate([
            updateButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -15), // Silme butonunun soluna yerleştir
            updateButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        return cell
    }

    
    @objc func sehriSil(_ sender: UIButton) {
        let index = sender.tag
        
        if index < cities.count {
            cities.remove(at: index)
            saveCitiesToJSON()
            table.reloadData()
        } else {
            print("Geçersiz indeks: \(index)")
        }
    }

    @IBAction func guncelleye(_ sender: UIButton) {
       
            let index = sender.tag // Butondan tag'i al
            let city = cities[index] // İlgili şehri al
            performSegue(withIdentifier: "toDuzenleSayfa", sender: city) // Segue'e geçiş yap
        }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: (city, currentLocation))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let (city, location) = sender as? (City, CLLocation),
               let destinationVC = segue.destination as? CityInfoViewController {
                destinationVC.cityInfo = city
                destinationVC.currentLocation = location
                
                destinationVC.onUpdate = { [weak self] updatedCity in
                    guard let self = self else { return }
                    if let index = self.cities.firstIndex(where: { $0.city == updatedCity.city }) {
                        self.cities[index] = updatedCity
                        self.saveCitiesToJSON()
                        self.table.reloadData()
                    }
                }
            }
        } else if segue.identifier == "toDuzenleSayfa" {
            if let city = sender as? City,
               let destinationVC = segue.destination as? UpdateViewController {
                destinationVC.cityInfo = city // Şehir bilgisini güncelleme sayfasına gönder
                destinationVC.onUpdate = { [weak self] updatedCity in
                    guard let self = self else { return }
                    if let index = self.cities.firstIndex(where: { $0.city == updatedCity.city }) {
                        self.cities[index] = updatedCity
                        self.saveCitiesToJSON()
                        self.table.reloadData()
                    }
                }
            }
        }
    }*/
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let (city, location) = sender as? (City, CLLocation),
               let destinationVC = segue.destination as? CityInfoViewController {
                destinationVC.cityInfo = city
                destinationVC.currentLocation = location
                
                // Güncellenmiş şehir bilgisini alma
                destinationVC.onUpdate = { [weak self] updatedCity in
                    guard let self = self else { return }
                    if let index = self.cities.firstIndex(where: { $0.city == updatedCity.city }) {
                        self.cities[index] = updatedCity
                        self.saveCitiesToJSON()
                        self.table.reloadData()
                    }
                }
            }
        } else if segue.identifier == "toDuzenleSayfa" {
            if let city = sender as? City,
               let destinationVC = segue.destination as? UpdateViewController {
                destinationVC.cityInfo = city // Şehir bilgisini güncelleme sayfasına gönder
                
                // Güncellenmiş şehir bilgisini alma
                destinationVC.onUpdate = { [weak self] updatedCity in
                    guard let self = self else { return }
                    if let index = self.cities.firstIndex(where: { $0.city == updatedCity.city }) {
                        self.cities[index] = updatedCity
                        self.saveCitiesToJSON()
                        self.table.reloadData()
                    }
                }
            }
        }
    }

    
    
}

extension Main: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let sonKonum = locations.last else { return }
        currentLocation = sonKonum
        
        suankiEnlem.text = String(sonKonum.coordinate.latitude)
        suankiBoylam.text = String(sonKonum.coordinate.longitude)
        
        let konum = CLLocation(latitude: sonKonum.coordinate.latitude, longitude: sonKonum.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: konum.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}

