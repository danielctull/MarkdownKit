
import Foundation
import MarkdownKit

extension Markdown {

    var html: String {
        content.map { $0.html(tight: false) }.joined()
    }
}

extension Inline {

    var html: String {
        switch self {
        case let .code(code): return code.html
        case let .custom(custom): return custom.html
        case let .emphasis(emphasis): return emphasis.html
        case let .html(html): return html.html
        case let .image(image): return image.html
        case     .lineBreak: return "<br />\n"
        case let .link(link): return link.html
        case     .softBreak: return "\n"
        case let .strong(strong): return strong.html
        case let .text(text): return text.html
        }
    }
}

extension Inline.Code {
    var html: String { "<code>\(literal)</code>" }
}

extension Inline.Custom {
    var html: String { literal }
}

extension Inline.Emphasis {
    var html: String { "<em>\(content.html)</em>" }
}

extension Inline.HTML {
    var html: String { literal }
}

extension Inline.Image {

    private var titleHTML: String {
        guard let title = title, !title.isEmpty else { return "" }
        return #" title="\#(title)""#
    }

    private var altHTML: String { #" alt="\#(content.literal)""# }

    private var urlHTML: String {
        guard let url = url else { return "" }
        return #" src="\#(url)""#
    }

    var html: String { "<img\(urlHTML)\(altHTML)\(titleHTML) />" }
}

extension Inline.Link {

    private var titleHTML: String {
        guard let title = title, !title.isEmpty else { return "" }
        return #" title="\#(title)""#
    }

    private var urlHTML: String {
        guard var url = url?.removingPercentEncoding else { return "" }
        if url.contains("@"), !url.lowercased().hasPrefix("mailto:") { url = "mailto:" + url }
        let allowed = CharacterSet.urlPathAllowed.union(CharacterSet(charactersIn: ":@?#"))
        guard let percentEncoded = url.addingPercentEncoding(withAllowedCharacters: allowed) else { return "" }
        return #" href="\#(percentEncoded)""#
    }

    var html: String { "<a\(urlHTML)\(titleHTML)>\(content.html)</a>" }
}

extension Inline.Strong {
    var html: String { "<strong>\(content.html)</strong>" }
}

extension Inline.Text {
    var html: String { literal }
}

extension Array where Element == Block {

    func html(tight: Bool) -> String {
        map { $0.html(tight: tight) }.joined()
    }
}

extension Array where Element == Inline {
    var html: String { map { $0.html }.joined() }
}

extension Block {

    func html(tight: Bool) -> String {
        switch self {
        case let .code(code): return code.html
        case let .custom(custom): return custom.html
        case let .heading(heading): return heading.html
        case let .html(html): return html.html
        case let .list(list): return list.html
        case let .paragraph(paragraph): return paragraph.html(tight: tight)
        case let .quote(quote): return quote.html
        case .thematicBreak: return "<hr />\n"
        }
    }
}

extension Block.Code {

    var html: String {
        switch language {
        case let .some(language): return #"<pre><code class="language-\#(language.rawValue)">\#(literal)</code></pre>\#n"#
        case .none: return "<pre><code>\(literal)</code></pre>\n"
        }
    }
}

extension Block.Custom {
    var html: String { literal }
}

extension Block.Heading {
    var html: String { "<h\(Int(level))>\(content.html)</h\(Int(level))>\n" }
}

extension Int {

    init(_ level: Block.Heading.Level) {
        switch level {
        case .h1: self = 1
        case .h2: self = 2
        case .h3: self = 3
        case .h4: self = 4
        case .h5: self = 5
        case .h6: self = 6
        }
    }
}

extension Block.HTML {
    var html: String { literal }
}

extension Block.List {

    var html: String {
        switch kind {
        case .unordered:
            return "<ul>\n\(items.html(tight: tight))</ul>\n"
        case .ordered(1):
            return "<ol>\n\(items.html(tight: tight))</ol>\n"
        case .ordered(let start):
            return "<ol start=\"\(start)\">\n\(items.html(tight: tight))</ol>\n"
        }
    }
}

extension Array where Element == Block.List.Item {
    func html(tight: Bool) -> String { map { $0.html(tight: tight) }.joined() }
}

extension Block.List.Item {

    func html(tight: Bool) -> String {

        var result = ""
        for (index, item) in content.enumerated() {

            var shouldAddNewline: Bool

            switch (tight, index, content.count, item) {
            case   (false, 0, _, .paragraph): shouldAddNewline = true
            case   (_,     _, _, .paragraph): shouldAddNewline = false
            case   (_,     0, _, .code): shouldAddNewline = true
            case   (_,     _, _, .code): shouldAddNewline = false
            case   (_,     _, 1, .list): shouldAddNewline = true
            case   (false, 0, _, .list): shouldAddNewline = true
            case   (true,  0, _, .list): shouldAddNewline = false
            case   (false, _, _, .list): shouldAddNewline = false
            case   (false, _, _, .quote): shouldAddNewline = false
            default: shouldAddNewline = true
            }

            if shouldAddNewline { result.append("\n") }
            result.append(item.html(tight: tight))
        }

        return "<li>\(result)</li>\n"
    }
}

extension Block.Paragraph {
    func html(tight: Bool) -> String {
        switch tight {
        case true: return content.html
        case false: return "<p>\(content.html)</p>\n"
        }
    }
}

extension Block.Quote {
    var html: String {
        "<blockquote>\n\(content.html(tight: false))</blockquote>\n"
    }
}

// MARK: - Literal Strings

extension Array where Element == Inline {
    var literal: String { map { $0.literal }.joined() }
}

extension Inline {

    var literal: String {
        switch self {
        case let .code(code): return code.literal
        case let .custom(custom): return custom.literal
        case let .emphasis(emphasis): return emphasis.literal
        case let .html(html): return html.literal
        case let .image(image): return image.literal
        case     .lineBreak: return ""
        case let .link(link): return link.literal
        case     .softBreak: return ""
        case let .strong(strong): return strong.literal
        case let .text(text): return text.literal
        }
    }
}

extension Inline.Emphasis {
    var literal: String { content.literal }
}

extension Inline.Strong {
    var literal: String { content.literal }
}

extension Inline.Link {
    var literal: String { content.literal }
}

extension Inline.Image {
    var literal: String { content.literal }
}
