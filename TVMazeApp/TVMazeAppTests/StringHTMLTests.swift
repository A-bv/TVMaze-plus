//
//  StringHTMLTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Testing
@testable import TVMazeApp

@MainActor
struct StringHTMLTests {
    @Test func strippingHTML_removesTheTags() {
        #expect("<p>Text <b>test.</b></p>".strippingHTML() == "Text test.")
    }

    @Test func strippingHTML_decodesTheEntities() {
        let html = "<p>Ben Affleck &amp; Matt Damon in &quot;The Rip&quot;, it&#39;s&nbsp;&lt;new&gt;</p>"

        #expect(html.strippingHTML() == "Ben Affleck & Matt Damon in \"The Rip\", it's <new>")
    }

    @Test func strippingHTML_decodesAnEscapedEntityOnlyOnce() {
        #expect("&amp;lt;".strippingHTML() == "&lt;")
    }
}
