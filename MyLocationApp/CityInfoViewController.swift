


import UIKit
import CoreLocation
import MapKit


    class CityInfoViewController: UIViewController {
        @IBOutlet weak var cityName: UILabel!
        @IBOutlet weak var enlem: UILabel!
        @IBOutlet weak var boylam: UILabel!
        @IBOutlet weak var aradakiMesafe: UILabel!
        var currentLocation: CLLocation?


        var cityInfo: City?
        var cities: [City]?
        var onUpdate: ((City) -> Void)?
        var onDelete: (() -> Void)?

        override func viewDidLoad() {
            super.viewDidLoad()
            updateUI()
            calculateDistance()
        }

        private func calculateDistance() {
            guard let cityInfo = cityInfo, let latitude = cityInfo.latitude, let longitude = cityInfo.longitude, let currentLocation = currentLocation else {
                aradakiMesafe.text = "Mesafe hesaplanamadı"
                return
            }

            let cityLocation = CLLocation(latitude: latitude, longitude: longitude)
            let distanceInKilometers = currentLocation.distance(from: cityLocation) / 1000
            aradakiMesafe.text = String(format: "%.2f km", distanceInKilometers)
        }


        private func updateUI() {
            // Şehir bilgileri varsa UI'yi güncelle
            if let info = cityInfo {
                cityName.text = info.city
                enlem.text = String(info.latitude ?? 0.0)
                boylam.text = String(info.longitude ?? 0.0)
            } else {
                print("Şehir bilgileri yok.")
            }
        }

        @IBAction func duzenleButonu(_ sender: Any) {
            // Geçiş yap
            performSegue(withIdentifier: "toDuzenle", sender: nil)
        }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDuzenle" {
            if let updateVC = segue.destination as? UpdateViewController {
                updateVC.cityInfo = cityInfo // Buraya dikkat edin
                updateVC.cities = cities

                // Güncellenecek şehrin indeksini geç
                if let index = cities?.firstIndex(where: { $0.city == cityInfo?.city }) {
                    updateVC.cityIndex = index
                }

                // Geri bildirim için closure
                updateVC.onUpdate = { [weak self] updatedCity in
                    self?.cityInfo = updatedCity
                    self?.updateUI()
                    // Eğer cities dizisini güncellemek gerekiyorsa:
                    if let index = self?.cities?.firstIndex(where: { $0.city == updatedCity.city }) {
                        self?.cities?[index] = updatedCity
                    }
                }
            } else {
                print("Hedef ViewController UpdateViewController değil.")
            }
        } else {
            print("Segue tanımlı değil veya yanlış bir tanımlama yapılmış.")
        }
    }
}

