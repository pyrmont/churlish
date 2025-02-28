# Churlish

[![Build Status](https://github.com/pyrmont/churlish/workflows/build/badge.svg)](https://github.com/pyrmont/churlish/actions?query=workflow%3Abuild)

Churlish is a pure Janet library for calling out to `curl`, the CLI tool.

## Rationale

Janet rocks and I want to use it for processing the results of web requests.
The problem is it's 2025 and every request I want to make needs HTTPS. Janet
doesn't support secure network requests out of the box and I want a
zero-dependency solution.

Just use `curl`, right? Janet has excellent facilities for spawning processes
and piping output and since it is 2025 everyone has `curl`. But there's a
problem: I can never remember whether `(os/pipe)` returns the write end first
or the read end first.

OK, so that's not the real problem (although I can never remember that). The
real problem is that if I call out to `curl`, all I get back is a giant string
of text. I'm using a Lisp: I want structured data!

Enter Churlish. It takes care of remembering how to use `(os/execute)`, how to
use `(os/pipe)` and how to parse an HTTP response. You get a simple API that
works like you'd expect. Or at least you will. At present, Churlish only
supports simple GET requests but more features are on their way!

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
