import UIKit

extension UIViewController {
    
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
    
    func showLoader(animation: Bool = false) {
        let loaderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
        loaderVC.modalPresentationStyle = .overFullScreen
        present(loaderVC, animated: animation)
    }
    
    func hideLoader(animation: Bool = false) {
        dismiss(animated: animation)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func calculateProportion(total: Int, value: Double) -> String {
        // Check if `total` or `value` is nil or if they cannot be converted to Double
        guard total != 0 else {
            return "0%"
        }
        
        // Calculate proportion
        let proportion = (Double(value) / Double(total)) * 100
        
        // Format to 2 decimal places
        let formattedProportion = String(format: "%.2f", proportion)
        return "\(formattedProportion)%"
    }
    
    func calculateProportionToDouble(total: Int, value: Double) -> Double {
        // Check if `total` or `value` is nil or if they cannot be converted to Double
        guard total != 0 else {
            return 0.0
        }
        
        // Calculate proportion
        let proportion = (Double(value) / Double(total)) * 100
        
        // Format to 2 decimal places
        return proportion
    }
}
