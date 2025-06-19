import CoreLocation

extension CLPlacemark {
  var formattedAddress: String {
    print("objPlacemark : \(self.description)")
    var addressString = ""

    if self.name != nil {
        addressString = addressString + self.name! + ", "
    }
    if self.subLocality != nil {
        addressString = addressString + self.subLocality! + ", "
    }
    if self.subAdministrativeArea != nil {
        addressString = addressString + self.subAdministrativeArea! + ", "
    }
    if self.administrativeArea != nil {
        addressString = addressString + self.administrativeArea! + ", "
    }
    if self.country != nil {
        addressString = addressString + self.country!
    }

    print("completeAddress : \(addressString)")
    return addressString
  }
}
