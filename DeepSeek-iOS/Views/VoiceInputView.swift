import SwiftUI
import Speech
import AVFoundation

/// 语音输入视图
struct VoiceInputView: View {
    @State private var isListening = false
    @State private var transcript = ""
    @State private var recognitionError: Error?
    @State private var confidence: Double = 0
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognizer: SFSpeechRecognizer? {
        return speechRecognizer
    }
    
    private var audioSession: AVAudioSession {
        return AVAudioSession.sharedInstance()
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // 波形动画
            WaveAnimation(isAnimating: isListening)
                .frame(width: 200, height: 100)
            
            // 状态文本
            Text(statusText)
                .font(.headline)
                .foregroundColor(isListening ? .blue : .primary)
            
            // 识别文本
            if !transcript.isEmpty {
                ScrollView {
                    Text(transcript)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .frame(height: 150)
            }
            
            Divider()
            
            // 麦克风按钮
            Button(action: toggleListening) {
                ZStack {
                    Circle()
                        .fill(isListening ? Color.red : Color.blue)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: isListening ? "stop.fill" : "mic.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .disabled(recognizer == nil)
            
            if let error = recognitionError {
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            if isListening {
                Text("置信度: \(String(format: "%.1f%%", confidence * 100))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .onAppear {
            requestPermission()
        }
        .onDisappear {
            stopRecording()
        }
    }
    
    private var statusText: String {
        if isListening {
            return "正在聆听..."
        } else if transcript.isEmpty {
            return "点击麦克风开始语音输入"
        } else {
            return "语音识别完成"
        }
    }
    
    private func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    break
                case .denied:
                    recognitionError = NSError(
                        domain: "VoiceInput",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "语音权限被拒绝"]
                    )
                case .restricted:
                    recognitionError = NSError(
                        domain: "VoiceInput",
                        code: -2,
                        userInfo: [NSLocalizedDescriptionKey: "语音功能在此设备上受限"]
                    )
                case .notDetermined:
                    recognitionError = NSError(
                        domain: "VoiceInput",
                        code: -3,
                        userInfo: [NSLocalizedDescriptionKey: "需要语音权限才能使用此功能"]
                    )
                @unknown default:
                    break
                }
            }
        }
        
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            recognitionError = error
        }
    }
    
    private func toggleListening() {
        if isListening {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        guard let recognizer = recognizer, recognizer.isAvailable else {
            recognitionError = NSError(
                domain: "VoiceInput",
                code: -4,
                userInfo: [NSLocalizedDescriptionKey: "语音识别器不可用"]
            )
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        Task {
            do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                
                let recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                    guard let self = self else { return }
                    
                    if let result = result {
                        DispatchQueue.main.async {
                            self.transcript = result.bestTranscription.formattedString
                            self.confidence = result.confidence
                        }
                    }
                    
                    if error != nil || result?.isFinal == true {
                        DispatchQueue.main.async {
                            self.stopRecording()
                        }
                    }
                }
                
                self.recognitionTask = recognitionTask
                isListening = true
                
            } catch {
                recognitionError = error
                isListening = false
            }
        }
    }
    
    private func stopRecording() {
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isListening = false
        transcript = ""
        confidence = 0
    }
}

/// 波形动画视图
struct WaveAnimation: View {
    let isAnimating: Bool
    @State private var phase = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<5) { index in
                    let radius = CGFloat(20 + sin(phase + Double(index) * 0.5) * 10)
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: radius, height: radius)
                        .position(
                            x: geometry.size.width / 2 + CGFloat(index - 2) * 30,
                            y: geometry.size.height / 2
                        )
                }
            }
            .onChange(of: isAnimating) { _ in
                if isAnimating {
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                        phase = .pi * 2
                    }
                }
            }
        }
    }
}
