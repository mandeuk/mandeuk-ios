import SwiftUI
import PhotosUI

struct PostThumbnail: Equatable, Hashable, Transferable {
    let image: UIImage?
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                return PostThumbnail(image: nil)
            }
            return PostThumbnail(image: uiImage)
        }
        
        DataRepresentation(importedContentType: .movie) { data in
            let url = getUrlFromVideo(data: data)
            return generateVideoThumbnail(from: url)
        }
    }
    
    private static func getUrlFromVideo(data: Data) -> URL? {
        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        let tempFile = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
        do {
            try data.write(to: tempFile)
            return tempFile
        } catch {
            print("Failed to save video to temporary directory: \(error)")
            return nil
        }
    }
    
    private static func generateVideoThumbnail(from url: URL?) -> PostThumbnail {
        guard let url else { return PostThumbnail(image: nil) }
        
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return PostThumbnail(image: UIImage(cgImage: cgImage))
            
        } catch {
            print("Failed to generate video thumbnail: \(error)")
            return PostThumbnail(image: nil)
        }
    }
    
    static func convertManifestURLToThumbnailURL(_ url: URL) -> URL? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        components.path = components.path.replacingOccurrences(
            of: "/manifest/video",
            with: "/thumbnails/thumbnail.jpg"
        )
        return components.url
    }
}
