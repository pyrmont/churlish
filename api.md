# churlish API

[exe](#exe), [http-delete](#http-delete), [http-get](#http-get), [http-head](#http-head), [http-options](#http-options), [http-patch](#http-patch), [http-post](#http-post), [http-put](#http-put)

## exe

**string**  | [source][1]

```janet
"curl"
```

The path to the curl executable

[1]: lib/churlish.janet#L3


## http-delete

**function**  | [source][2]

```janet
(http-delete url &named headers body)
```

Makes a DELETE request to the provided URL

Makes an HTTP DELETE request to `url`. To set specific headers in the
request, the user can provide a struct/table as `headers`. A `body` is
optional and is only sent if one is provided. The body and headers will be
sent securely to `curl` via stdin.

[2]: lib/churlish.janet#L74


## http-get

**function**  | [source][3]

```janet
(http-get url &named headers)
```

Makes a GET request to the provided URL

Makes an HTTP GET request to `url`. To set specific headers in the request,
the user can provide a struct/table as `headers`. The headers will be sent
securely to `curl` via stdin.

[3]: lib/churlish.janet#L87


## http-head

**function**  | [source][4]

```janet
(http-head url &named headers)
```

Makes a HEAD request to the provided URL

Makes an HTTP HEAD request to `url`. To set specific headers in the request,
the user can provide a struct/table as `headers`. The headers will be sent
securely to `curl` via stdin. Since a server sends no body in response to a
HEAD request, the `:body` of the response is an empty string.

[4]: lib/churlish.janet#L99


## http-options

**function**  | [source][5]

```janet
(http-options url &named headers)
```

Makes an OPTIONS request to the provided URL

Makes an HTTP OPTIONS request to `url`. To set specific headers in the
request, the user can provide a struct/table as `headers`. The headers will
be sent securely to `curl` via stdin.

[5]: lib/churlish.janet#L112


## http-patch

**function**  | [source][6]

```janet
(http-patch url &named headers body)
```

Makes a PATCH request to the provided URL

Makes an HTTP PATCH request to `url` with the given `body`. To set specific
headers in the request, the user can provide a struct/table as `headers`. The
body and headers will be sent securely to `curl` via stdin.

[6]: lib/churlish.janet#L124


## http-post

**function**  | [source][7]

```janet
(http-post url &named headers body)
```

Makes a POST request to the provided URL

Makes an HTTP POST request to `url` with the given `body`. To set specific
headers in the request, the user can provide a struct/table as `headers`. The
body and headers will be sent securely to `curl` via stdin.

[7]: lib/churlish.janet#L137


## http-put

**function**  | [source][8]

```janet
(http-put url &named headers body)
```

Makes a PUT request to the provided URL

Makes an HTTP PUT request to `url` with the given `body`. To set specific
headers in the request, the user can provide a struct/table as `headers`. The
body and headers will be sent securely to `curl` via stdin.

[8]: lib/churlish.janet#L150

