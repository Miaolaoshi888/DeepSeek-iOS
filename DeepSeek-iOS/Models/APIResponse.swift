import Foundation

/// API 错误类型
enum APIError: Error, LocalizedError {
    case invalidResponse
    case authorizationFailed
    case rateLimited
    case modelNotFound(String)
    case networkError(Error)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "无效的响应"
        case .authorizationFailed:
            return "认证失败，请检查 API Key"
        case .rateLimited:
            return "请求过于频繁，请稍后重试"
        case .modelNotFound(let model):
            return "模型不存在: \(model)"
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .unknown(let message):
            return message
        }
    }
}

/// API 响应类型
struct APIResponse: Codable {
    let id: String?
    let object: String?
    let created: Int64?
    let model: String?
    let choices: [Choice]?
    let usage: Usage?
    let error: ErrorItem?
    
    struct Choice: Codable {
        let index: Int?
        let message: Message?
        let finish_reason: String?
    }
    
    struct Message: Codable {
        let role: String?
        let content: String?
    }
    
    struct Usage: Codable {
        let prompt_tokens: Int?
        let completion_tokens: Int?
        let total_tokens: Int?
    }
    
    struct ErrorItem: Codable {
        let message: String?
        let type: String?
        let code: String?
    }
}
