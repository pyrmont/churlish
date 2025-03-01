# Churlish

[![Build Status](https://github.com/pyrmont/churlish/workflows/build/badge.svg)](https://github.com/pyrmont/churlish/actions?query=workflow%3Abuild)

Churlish is a pure Janet library for calling out to `curl`, the CLI tool.

> :warning: **Warning:** Churlish only supports simple GET requests at present.

## Rationale

You want to make an HTTP request with Janet. The problem is that every URL you
want to reach requires the call to go over HTTPS and Janet doesn't support
secure network requests out of the box. What to do?

You could use a wrapper around `libcurl` but now you need to compile your code
and make sure you have the appropriate `libcurl` development package for your
system. But wait, your system almost certainly has `curl` already. Janet has
excellent support for calling out to external executables. Can't we just do
that?

Enter Churlish. Churlish presents a simple API that works the way you'd expect.
You give it a URL, it gives you back the HTTP request as structured data!

## Library

### Installation

Add the dependency to your `project.janet` file:

```janet
(declare-project
  :dependencies ["https://github.com/pyrmont/churlish"])
```

### Usage

Churlish can be used like this:

```janet
(import churlish)

(churlish/get "https://example.org")
# => @{:body "..." :headers @{ ... } :protocol "HTTP/2" :reason "" :status 200}}
```

## Bugs

Found a bug? I'd love to know about it. The best way is to report your bug in
the [Issues][] section on GitHub.

[Issues]: https://github.com/pyrmont/churlish/issues

## Licence

Churlish is licensed under the MIT Licence. See [LICENSE][] for more details.

[LICENSE]: https://github.com/pyrmont/churlish/blob/master/LICENSE
