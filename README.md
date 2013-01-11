# simple-ui

A really simple UI helper, supporting 

- logging severities (:debug, :info, :warn, :error, :success)

    UI.warn "This is a warning"

- ...with different colors...

    UI.success "success is green"
    UI.error "error is red"

- ...with inspect'ing arguments after the first

    UI.warn "Some things", 1, "foo\nline", :bar
    # =>
    # Some things 1, "foo\nline", :bar

- ...with support for source names

    url = "http://radiospiel.org"
    url.warn "Found a new blog post"
    # =>
    # [http://radiospiel.org] Found a new blog post

Well, nothing too exciting; yet easy enough to throw into your projects:

    require "simple/ui"
