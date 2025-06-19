import UIKit
import AVFoundation
import SafariServices

extension URL {
  func generateThumbnail() -> UIImage {
    let asset = AVAsset(url: self)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    var time = asset.duration
    time.value = 0
    let imageRef = try? generator.copyCGImage(at: time, actualTime: nil)
    let thumbnail = UIImage(cgImage: imageRef!)
    return thumbnail
  }
}

extension URL {
  func appendingParameters(_ parameters: [String: String]?) -> URL {
    var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
    var queryItems = components.percentEncodedQueryItems ?? []
    if let parameters = parameters {
      for key in parameters.keys {
        queryItems.append(URLQueryItem(name: key, value: parameters[key]?.percentEncoded()))
      }
    }

    let query = queryItems.compactMap { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
    components.percentEncodedQuery = query

    if let url = components.url {
      print("URL: \(url)")
    }
    return components.url!
  }

  func open() {
    guard UIApplication.shared.canOpenURL(self) else { return }
    guard let topViewController = UIApplication.topViewController() else { return }
    //UIApplication.shared.open(self, options: [:], completionHandler: nil)
    let vc = SFSafariViewController(url: self)
    topViewController.present(vc, animated: true, completion: nil)
  }

  var canOpen: Bool {
    UIApplication.shared.canOpenURL(self)
  }
}

