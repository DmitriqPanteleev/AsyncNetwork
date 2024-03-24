
import Foundation

/// Тип данных, позволяющий жестко задать тип отправляемого поля
public enum MimeType: String {
    // MARK: Audio
    case audioMP4 = "audio/mp4"
    case audioAAC = "audio/aac"
    case audioMP3 = "audio/mpeg"
    
    // MARK: Image
    case imageGIF = "image/gif"
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    
    // MARK: Text
    case textMD = "text/markdown"
    case textXML = "text/xml"
    case textHTML = "text/html"
    case textPlain = "text/plain"
    
    // MARK: Video
    case videoMPEG = "video/mpeg"
    case videoMP4 = "video/mp4"
}
