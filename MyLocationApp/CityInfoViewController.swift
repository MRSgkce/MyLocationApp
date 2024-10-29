
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
        if let info = cityInfo {
            cityName.text = info.city
            enlem.text = String(info.latitude ?? 0.0)
            boylam.text = String(info.longitude ?? 0.0)
        } else {
            cityName.text = "Şehir bilgisi yok"
            enlem.text = "N/A"
            boylam.text = "N/A"
        }
    }


    @IBAction func duzenleButonu(_ sender: Any) {
        performSegue(withIdentifier: "toDuzenleSayfa", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDuzenleSayfa" {
            if let updateVC = segue.destination as? UpdateViewController {
                updateVC.cityInfo = cityInfo
                updateVC.onUpdate = { [weak self] updatedCity in
                    self?.cityInfo = updatedCity
                    self?.updateUI()
                    self?.onUpdate?(updatedCity) // Main ekranına geri dönerken güncellenmiş bilgiyi gönderiyor
                }
            }
        }
    }

}
