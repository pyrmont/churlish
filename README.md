# Churlish

[![Test Status][icon]][status]

[icon]: https://github.com/pyrmont/churlish/workflows/test/badge.svg
[status]: https://github.com/pyrmont/churlish/actions?query=workflow%3Atest

Churlish is a pure Janet library for calling out to `curl`, the CLI tool.

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

Add the dependency to your `info.jdn` file:

```janet
  :dependencies ["https://github.com/pyrmont/churlish"]
```

### Usage

Churlish can be used like this:

```janet
(import churlish)

(churlish/http-get "https://example.org")
# => @{:body "..." :headers @{ ... } :protocol "HTTP/2" :reason "" :status 200}}
```

There's a function for each of the seven HTTP verbs that Churlish supports:

  | Verb    | Function       |
  | ------- | -------------- |
  | DELETE  | `http-delete`  |
  | GET     | `http-get`     |
  | HEAD    | `http-head`    |
  | OPTIONS | `http-options` |
  | PATCH   | `http-patch`   |
  | POST    | `http-post`    |
  | PUT     | `http-put`     |

Each function takes a URL and, optionally, a struct/table of `headers`:

```janet
(churlish/http-head "https://example.org" :headers {"Accept" "text/plain"})
```

The verbs that carry a body (`http-patch`, `http-post` and `http-put`) take
a `body` as well:

```janet
(churlish/http-post "https://example.org/widgets"
                    :headers {"Content-Type" "application/json"}
                    :body `{"name": "gadget"}`)
```

`http-delete` can take a `body` but sends one only if you provide it. Since a
server responds to a HEAD request without a body, the `:body` returned by
`http-head` is an empty string.

Check out the [API document](api.md) for more information.

## Bugs

Found a bug? I'd love to know about it. The best way is to report your bug in
the [Issues][] section on GitHub.

[Issues]: https://github.com/pyrmont/churlish/issues

## Licence

Churlish is licensed under the MIT Licence. See [LICENSE][] for more details.

[LICENSE]: https://github.com/pyrmont/churlish/blob/master/LICENSE
