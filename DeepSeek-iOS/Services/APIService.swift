import Foundation

/// API 服务 - 处理与 Agnes AI 的通信
class APIService {
    static let shared = APIService()
    
    private let session: URLSession
    private var baseURL: String = "https://api.agnes-ai.cn/v1"
    private var apiKey: String = ""
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 300
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
    }
    
    /// 配置 API 设置
    func configure(baseURL: String, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    /// 发送聊天请求
    func chat(messages: [ChatMessage], model: String) async throws -> String {
        let url = URL(string: "\(baseURL)/chat/completions")!
        
        let body: [String: Any] = [
            "model": model,
            "messages": messages.map { msg -> [String: Any] in
                var dict: [String: Any] = [
                    "role": msg.role.rawValue,
                    "content": msg.content
                ]
                if !msg.attachments.isEmpty {
                    dict["attachments"] = msg.attachments
                }
                return dict
            },
            "stream": false,
            "max_tokens": 4096,
            "temperature": 0.7
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401, 403:
            throw APIError.authorizationFailed
        case 429:
            throw APIError.rateLimited
        default:
            throw APIError.unknown("HTTP \(httpResponse.statusCode)")
        }
        
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        
        if let error = apiResponse.error {
            throw APIError.unknown(error.message ?? "Unknown error")
        }
        
        guard let message = apiResponse.choices?.first?.message,
              let content = message.content else {
            throw APIError.invalidResponse
        }
        
        return content
    }
    
    /// 测试 API 连接
    func testConnection() async throws {
        let url = URL(string: "\(baseURL)/models")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
            throw APIError.authorizationFailed
        }
    }
    
    /// 发送多模态请求（图片+文本）
    func chatWithImage(messages: [ChatMessage], imageURL: URL) async throws -> String {
        // 实现多模态 API 调用
        // 这里简化处理，实际应该调用支持图片的 API
        return try await chat(messages: messages, model: "agnes-2.5-flash")
    }
}
