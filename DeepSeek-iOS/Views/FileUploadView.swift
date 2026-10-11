import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

/// 文件上传视图
struct FileUploadView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var files: [FileData] = []
    @State private var showingImporter = false
    @State private var analysisResult = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if files.isEmpty {
                    emptyState
                } else {
                    fileList
                }
                
                Divider()
                    .padding(.vertical)
                
                // 操作按钮
                HStack {
                    PhotosPicker(
                        selection: $selectedItems,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label("添加图片", systemImage: "photo.fill")
                    }
                    
                    Button {
                        showingImporter = true
                    } label: {
                        Label("添加文件", systemImage: "folder.fill")
                    }
                    
                    Button("分析文件") {
                        analyzeFiles()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(files.isEmpty)
                }
                .padding()
                .fileImporter(
                    isPresented: $showingImporter,
                    allowedContentTypes: [.pdf, .jpeg, .png, .plainText, .xml],
                    allowsMultipleSelection: true
                ) { result in
                    handleSelection(result)
                }
                
                // 分析结果
                if !analysisResult.isEmpty {
                    ScrollView {
                        Text(analysisResult)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
            .navigationTitle("文件分析")
        }
        .onChange(of: selectedItems) { newItems in
            for item in newItems {
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        files.append(FileData(
                            id: UUID(),
                            name: "图片_\(files.count + 1).jpg",
                            type: "JPEG Image",
                            data: data
                        ))
                    }
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.on.clipboard")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("上传文件进行 AI 分析")
                .font(.headline)
            
            Text("支持图片、PDF、文本文件")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private var fileList: some View {
        List {
            ForEach(files) { file in
                HStack {
                    Image(systemName: file.icon)
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text(file.name)
                            .font(.headline)
                        Text(file.type)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        files.removeAll { $0.id == file.id }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 8)
            }
            .onDelete(perform: deleteFiles)
        }
        .listStyle(.plain)
    }
    
    private func handleSelection(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            for url in urls {
                let name = url.lastPathComponent
                let type = mimeType(from: url)
                files.append(FileData(id: UUID(), name: name, type: type, data: nil))
            }
        case .failure(let error):
            print("文件选择失败: \(error.localizedDescription)")
        }
    }
    
    private func analyzeFiles() {
        // 调用 AI 分析文件
        Task {
            analysisResult = "正在分析 \(files.count) 个文件..."
            // 实际实现需要调用 AI API
        }
    }
    
    private func deleteFiles(at offsets: IndexSet) {
        files.remove(atOffsets: offsets)
    }
    
    private func mimeType(from url: URL) -> String {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "pdf": return "PDF Document"
        case "png": return "PNG Image"
        case "jpg", "jpeg": return "JPEG Image"
        case "txt": return "Text Document"
        case "swift", "py", "js": return "Source Code"
        default: return "File"
        }
    }
}

struct FileData: Identifiable {
    let id: UUID
    let name: String
    let type: String
    var data: Data?
    
    var icon: String {
        switch type {
        case "PDF Document": return "pdf.fill"
        case "PNG Image", "JPEG Image": return "photo.fill"
        case "Text Document": return "doc.text.fill"
        case "Source Code": return "curlybraces"
        default: return "doc.fill"
        }
    }
}
