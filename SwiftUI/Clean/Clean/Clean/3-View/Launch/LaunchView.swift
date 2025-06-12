import SwiftUI
import Alamofire
import PhotosUI

// MARK: State
struct LaunchView {
    @EnvironmentObject var router: RouteManager
    @State var isLatestVersion: Bool = true
}

// MARK: View
extension LaunchView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color.BLUE_02.ignoresSafeArea(.all)
            Image("launch_icon")
                .resizable()
                .scaledToFit()
                .frame(width: ScreenSize.width*0.7, alignment: .center)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            Task { await requestAPI() }
        }
    }
}

// MARK: API
extension LaunchView {
    private func requestAPI() async {
        let model = GetIosVersionCheckModel(
            parameters: .init()
        )
        
        let result = await APIClient.request( model )
        switch result {
        case .success(let res):
            successGetAppVersion(res.data?.version ?? "")
            return
        case .failure(let err):
            print("@LOG \(#function) - failure \(err.statusCode) - \(err.message)")
            break
        }
        return// shutdownApp()
    }
    
    @MainActor
    private func successGetAppVersion(_ version: String) {
//        print("@LOG \(#function) - DispatchQueue.currentLabel : \(DispatchQueue.currentLabel)")
        isLatestVersion = compareAppVersion(version)
        router.routeTo(.login)
    }
}

#Preview {
    LaunchView()
}



// 서버에서 받아온 이미지와 사용자가 사진첩에서 선택한 이미지을 통합하여 처리하는 타입
struct MediaItem: MediaAttachable {
    
    var id: UUID?
    var remoteId: Int?
    var localImage: PhotosPickerItem?
    var imageData: Data?
    var imageURL: URL?
    var withName: RequestBodyKey
    var conversionType: MediaConversionType?
    var thumbnail: PostThumbnail
    
    init(id: UUID? = nil,
         remoteId: Int? = nil,
         localImage: PhotosPickerItem? = nil,
         imageData: Data? = nil,
         withName: RequestBodyKey,
         conversionType: MediaConversionType? = nil,
         thumbnail: PostThumbnail
    ) {
        self.id = UUID()
        self.remoteId = remoteId
        self.localImage = localImage
        self.imageData = imageData
        self.withName = withName
        self.conversionType = conversionType
        self.thumbnail = thumbnail
    }
    
    enum CodingKeys: String, CodingKey {
        case remoteId
        case imageData
        case withName
        case conversionType
    }
}

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
