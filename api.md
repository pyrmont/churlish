# churlish API

[exe](#exe), [http-get](#http-get), [http-post](#http-post), [http-put](#http-put)

## exe

**string**  | [source][1]

```janet
"curl"
```

The path to the curl executable

[1]: lib/churlish.janet#L3


## http-get

**function**  | [source][2]

```janet
(http-get url &named headers)
```

Makes a GET request to the provided URL

Makes an HTTP GET request to `url`. To set specific headers in the request,
the user can provide a struct/table as `headers`. The headers will be sent
securely to `curl` via stdin.

[2]: lib/churlish.janet#L36


## http-post

**function**  | [source][3]

```janet
(http-post url &named headers body)
```

Makes a POST request to the provided URL

Makes an HTTP POST request to `url` with the given `body`. To set specific
headers in the request, the user can provide a struct/table as `headers`. The
body and headers will be sent securely to `curl` via stdin.

[3]: lib/churlish.janet#L64


## http-put

**function**  | [source][4]

```janet
(http-put url &named headers body)
```

Makes a PUT request to the provided URL

Makes an HTTP PUT request to `url` with the given `body`. To set specific
headers in the request, the user can provide a struct/table as `headers`. The
body and headers will be sent securely to `curl` via stdin.

[4]: lib/churlish.janet#L95

