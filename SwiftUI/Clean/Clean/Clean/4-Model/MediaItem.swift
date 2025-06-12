import SwiftUI
import PhotosUI

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
