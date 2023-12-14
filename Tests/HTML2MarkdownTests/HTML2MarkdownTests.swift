import XCTest
@testable import HTML2Markdown

final class HTML2MarkdownTests: XCTestCase {
    
    func testHeaders() {
        let h = "<h1>Header 1</h1><h3>Header 3</h3><h6>Header 6</h6>"
        XCTAssertEqual(try HTML2Markdown.markdown(html: h), "# Header 1\n\n### Header 3\n\n###### Header 6")
    }
    
    func testParagraphs() {
        let f = "<p>First</p>"
        let s = "<p>First</p><p>Second</p>"
        let t = "<p>First</p>Text<p>Second</p>"
//        XCTAssertEqual(try HTML2Markdown.markdown(html: f), "First")
        XCTAssertEqual(try HTML2Markdown.markdown(html: s), "First\n\nSecond")
//        XCTAssertEqual(try HTML2Markdown.markdown(html: t), "First\n\nText\n\nSecond")
    }
    
    func testLineBreak() {
        let br = "Line<br/>Break"
        let pb = "<p>Line<br/></p><p>Break</p>"
        XCTAssertEqual(try HTML2Markdown.markdown(html: br), "Line\nBreak")
        XCTAssertEqual(try HTML2Markdown.markdown(html: pb), "Line\n\nBreak")
    }
    
    func testBold() throws {
        let b = "<b>Bold</b>"
        let s = "<strong>Strong</strong>"
        XCTAssertEqual(try HTML2Markdown.markdown(html: b), "**Bold**")
        XCTAssertEqual(try HTML2Markdown.markdown(html: s), "**Strong**")
    }
    
    func testItalic() {
        let i = "<i>Italic</i>"
        let e = "<em>Emphasis</em>"
        XCTAssertEqual(try HTML2Markdown.markdown(html: i), "*Italic*")
        XCTAssertEqual(try HTML2Markdown.markdown(html: e), "*Emphasis*")
    }
    
    func testAnchor() {
        let a = #"<a href="htpps://apple.com">link</a>"#
        let l = #"<a ref="htpps://apple.com">link</a>"#
        XCTAssertEqual(try HTML2Markdown.markdown(html: a), "[link](htpps://apple.com)")
        XCTAssertEqual(try HTML2Markdown.markdown(html: l), "link")
    }
    
    func testUnorderedList() {
        let ul1 = "<ul><li>one</li><li>two</li><li>three</li></ul>"
        let ul2 = "first<ul><li>one</li><li>two</li><li>three</li></ul>"
        let ul3 = "<ul><li>one</li><li>two</li><li>three</li></ul>last"
        XCTAssertEqual(try HTML2Markdown.markdown(html: ul1), "• one\n• two\n• three")
        XCTAssertEqual(try HTML2Markdown.markdown(html: ul2), "first\n\n• one\n• two\n• three")
        XCTAssertEqual(try HTML2Markdown.markdown(html: ul3), "• one\n• two\n• three\n\nlast")
    }
    
    func testOrderedList() {
        let ol1 = "<ol><li>one</li><li>two</li><li>three</li></ol>"
        let ol2 = "first<ol><li>one</li><li>two</li><li>three</li></ol>"
        let ol3 = "<ol><li>one</li><li>two</li><li>three</li></ol>last"
        XCTAssertEqual(try HTML2Markdown.markdown(html: ol1), "1. one\n2. two\n3. three")
        XCTAssertEqual(try HTML2Markdown.markdown(html: ol2), "first\n\n1. one\n2. two\n3. three")
        XCTAssertEqual(try HTML2Markdown.markdown(html: ol3), "1. one\n2. two\n3. three\n\nlast")
    }
    
    func testTable() {
        let table = "<table><tr><td>R1C1</td><td>R1C2</td><td>R1C3</td></tr><tr><td>R2C1</td><td>R2C2</td><td>R3C2</td></tr><tr><td>R3C1</td><td>R3C2</td><td>R3C3</td></tr></table>"
        let tb = """
        |   |   |   |
        |---|---|---|
        | R1C1 | R1C2 | R1C3 |
        | R2C1 | R2C2 | R3C2 |
        | R3C1 | R3C2 | R3C3 |
        """
        XCTAssertEqual(try HTML2Markdown.markdown(html: table), tb)
    }
}
