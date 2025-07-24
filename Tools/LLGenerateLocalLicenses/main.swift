//
//  main.swift
//  LicenseList
//
//  Created by lynnswap on 2025/07/24.
//

import Foundation

struct Item: Codable {
    let name: String
    let licenseBody: String
}

/// --- 引数パース -----------------------------------------------------------
enum Arg { static let root = "--workspace"; static let out = "--output" }
let args = CommandLine.arguments
guard let rootIdx = args.firstIndex(of: Arg.root),
      let outIdx  = args.firstIndex(of: Arg.out),
      args.indices.contains(rootIdx+1), args.indices.contains(outIdx+1) else {
    fputs("Usage: LLGenerateLocalLicenses --workspace <dir> --output <file>\n", stderr)
    exit(1)
}
let workspace = URL(fileURLWithPath: args[rootIdx+1])
let outputURL = URL(fileURLWithPath: args[outIdx+1])

/// --- 1) workspace 以下を走査し Package.swift を探す ----------------------
let fm = FileManager.default
let enumerator = fm.enumerator(at: workspace,
                               includingPropertiesForKeys: [.isDirectoryKey],
                               options: [.skipsHiddenFiles])!

var items: [Item] = []

for case let url as URL in enumerator where url.lastPathComponent == "Package.swift" {
    let pkgDir = url.deletingLastPathComponent()
    enumerator.skipDescendants()              // 深追い防止

    // 2) LICENSE / COPYING などを検索
    let cand = try fm.contentsOfDirectory(at: pkgDir,
                                          includingPropertiesForKeys: nil)
        .first(where: { ["license","licence","copying","notice"]
            .contains($0.deletingPathExtension().lastPathComponent.lowercased()) })

    if let licURL = cand,
       let text = try? String(contentsOf: licURL, encoding: .utf8) {
        items.append(.init(name: pkgDir.lastPathComponent, licenseBody: text))
    }
}

/// --- 3) JSON 出力 ---------------------------------------------------------
let data = try JSONEncoder().encode(items)
try fm.createDirectory(at: outputURL.deletingLastPathComponent(),
                       withIntermediateDirectories: true)
try data.write(to: outputURL)
print("✅  Local package licenses written to \(outputURL.path)")
