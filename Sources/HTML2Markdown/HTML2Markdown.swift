import Foundation
import SwiftSoup

public class HTML2Markdown {
    
    let unorderedListSymbol: String
    
    public init(unorderedListSymbol: String = "-") {
        self.unorderedListSymbol = unorderedListSymbol
    }
        
    public func markdown(html: String) throws -> String {
        let document = try SwiftSoup.parse(html)
        if let body = document.body() {
            return convert(node: body).replace(pattern: "[\n]{3,}", with: "\n\n")
        } else {
            return ""
        }
    }
    
    enum List {
        case ordered
        case unordered
    }
    
    func convert(node: Node, list: List? = nil) -> String {
        var markdown = ""
        
        typealias Before = ([String]) -> Void
        func children(childList: List? = nil, separator: String = "", before: Before? = nil) {
            let nodes = node.getChildNodes().map { convert(node: $0, list: childList) }
            before?(nodes)
            markdown += nodes.joined(separator: separator)
        }
        
        let isFirst = node.siblingIndex == 0
        let isLast = node.siblingIndex + 1 == node.parent()?.childNodeSize()

        switch node.nodeName() {
        case "#text":
            markdown += node.description.trimmingCharacters(in: .whitespacesAndNewlines)
        case "br":
            markdown += "\n"
            children()
        case "p":
            if !isFirst { markdown += "\n\n" }
            children()
            if !isLast { markdown += "\n\n" }
        case "blockquote":
            if !isFirst { markdown += "\n\n" }
            markdown += "> "
            children()
            if !isLast { markdown += "\n\n" }
        case "b", "strong":
            markdown += "**"
            children()
            markdown += "**"
        case "i", "em":
            markdown += "*"
            children()
            markdown += "*"
        case "code":
            markdown += "`"
            children()
            markdown += "`"
        case "a":
            if let href = try? node.attr("href"), !href.isEmpty {
                markdown += "["
                children()
                markdown += "]"
                markdown += "(\(href))"
            } else {
                children()
            }
        // MARK: - List
        case "ol":
            if !isFirst { markdown += "\n\n" }
            children(childList: .ordered)
            if !isLast { markdown += "\n\n" }
        case "ul":
            if !isFirst { markdown += "\n\n" }
            children(childList: .unordered)
            if !isLast { markdown += "\n\n" }
        case "li":
            switch list {
            case .ordered:
                markdown += "\(node.siblingIndex + 1). "
                children()
            case .unordered:
                markdown += "\(unorderedListSymbol) "
                children()
            default: break
            }
            if !isLast { markdown += "\n" }
        // MARK: - Table
        case "tr":
            children(separator: " | ") { columns in
                if isFirst {
                    let headers = Array(repeating: "   ", count: columns.count).joined(separator: "|")
                    let alignments = Array(repeating: "---", count: columns.count).joined(separator: "|")
                    markdown += "|\(headers)|\n"
                    markdown += "|\(alignments)|\n"
                }
                markdown += "| "
            }
            markdown += " |"
            if !isLast { markdown += "\n" }
        default:
            // header
            if let h = node.nodeName().regex(pattern: #"(?<=h)\d+"#).first, let header = Int(h) {
                if !isFirst { markdown += "\n\n" }
                markdown += String(repeating: "#", count: header) + " "
            }
            children()
        }
        
        return markdown
    }
}

extension String {
    func regex(pattern: String, options: NSRegularExpression.Options = [.dotMatchesLineSeparators]) -> [String] {
        do {
            let string = self as NSString
            let regex = try NSRegularExpression(pattern: pattern, options: options)
            let range = NSRange(location: 0, length: string.length)
            let matches = regex.matches(in: self, range: range)
            return matches.map { string.substring(with: $0.range) }
        } catch {
            return []
        }
    }
    
    func replace(pattern: String, with template: String, options: NSRegularExpression.Options = [.dotMatchesLineSeparators]) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: options)
            let range = NSRange(location: 0, length: utf16.count)
            return regex.stringByReplacingMatches(in: self, range: range, withTemplate: template)
        } catch {
            return self
        }
        
    }
}
