# Command string

(var exe
  ```
  The path to the curl executable
  ```
  (if (has-value? [:windows :mingw :cygwin] (os/which))
    "curl.exe"
    "curl"))

(defn- cmd [url]
  (if (has-value? [:windows :mingw :cygwin] (os/which))
    [exe url "-iSs" "--ipv4" "--config" "-"]
    [exe url "-iSs" "--config" "-"]))

# HTTP response parsing

(def- response-grammar
  ~{:main  (/ (* :start :hdrs :eol :body) ,table)
    :start (* :prot " " :code " " (? :rp) :eol)
    :prot  (* (constant :protocol) '(to :s))
    :code  (* (constant :status) (number :d+))
    :rp    (* (not :eol) (constant :reason) '(to :eol))
    :hdrs  (* (constant :headers) (/ (any :hdr) ,table))
    :hdr   (* (not :eol) '(to ":") ":" (? " ") '(to :eol) :eol)
    :body  (* (constant :body) '(thru -1))
    :eol   (* "\r\n")})

(defn- parse-response
  [s]
  (def matches (peg/match response-grammar s))
  (if (nil? matches)
    (error "failed to parse HTTP response")
    (first matches)))

# HTTP requests

(defn- request
  [method url headers body]
  # `curl` infers the method from whether a body is sent, so the method is only
  # set explicitly when it differs from what would be inferred. HEAD is set with
  # curl's own option because `request = HEAD` leaves curl waiting for a body
  # that the server will never send
  (def inferred (if (nil? body) "GET" "POST"))
  (def proc (os/spawn (cmd url) :p {:in :pipe :err :pipe :out :pipe}))
  (def [_ exit-code out err]
    (ev/gather
      (do
        (cond
          (= "HEAD" method)
          (ev/write (proc :in) "head\n")

          (not= method inferred)
          (ev/write (proc :in) (string "request = " method "\n")))
        (each [k v] (pairs headers)
          (ev/write (proc :in) (string "header = \"" k ": " v "\"\n")))
        (unless (nil? body)
          (ev/write (proc :in) "data-binary = @-\n")
          (ev/write (proc :in) body))
        (ev/close (proc :in)))
      (do
        (os/proc-wait proc))
      (do
        (ev/read (proc :out) :all))
      (do
        (ev/read (proc :err) :all))))
  (os/proc-close proc)
  (if (zero? exit-code)
    (parse-response out)
    (error (string "HTTP request failed: " (string/trim err)))))

# HTTP request functions

(defn http-delete
  ```
  Makes a DELETE request to the provided URL

  Makes an HTTP DELETE request to `url`. To set specific headers in the
  request, the user can provide a struct/table as `headers`. A `body` is
  optional and is only sent if one is provided. The body and headers will be
  sent securely to `curl` via stdin.
  ```
  [url &named headers body]
  (default headers {})
  (request "DELETE" url headers body))

(defn http-get
  ```
  Makes a GET request to the provided URL

  Makes an HTTP GET request to `url`. To set specific headers in the request,
  the user can provide a struct/table as `headers`. The headers will be sent
  securely to `curl` via stdin.
  ```
  [url &named headers]
  (default headers {})
  (request "GET" url headers nil))

(defn http-head
  ```
  Makes a HEAD request to the provided URL

  Makes an HTTP HEAD request to `url`. To set specific headers in the request,
  the user can provide a struct/table as `headers`. The headers will be sent
  securely to `curl` via stdin. Since a server sends no body in response to a
  HEAD request, the `:body` of the response is an empty string.
  ```
  [url &named headers]
  (default headers {})
  (request "HEAD" url headers nil))

(defn http-options
  ```
  Makes an OPTIONS request to the provided URL

  Makes an HTTP OPTIONS request to `url`. To set specific headers in the
  request, the user can provide a struct/table as `headers`. The headers will
  be sent securely to `curl` via stdin.
  ```
  [url &named headers]
  (default headers {})
  (request "OPTIONS" url headers nil))

(defn http-patch
  ```
  Makes a PATCH request to the provided URL

  Makes an HTTP PATCH request to `url` with the given `body`. To set specific
  headers in the request, the user can provide a struct/table as `headers`. The
  body and headers will be sent securely to `curl` via stdin.
  ```
  [url &named headers body]
  (default headers {})
  (default body "")
  (request "PATCH" url headers body))

(defn http-post
  ```
  Makes a POST request to the provided URL

  Makes an HTTP POST request to `url` with the given `body`. To set specific
  headers in the request, the user can provide a struct/table as `headers`. The
  body and headers will be sent securely to `curl` via stdin.
  ```
  [url &named headers body]
  (default headers {})
  (default body "")
  (request "POST" url headers body))

(defn http-put
  ```
  Makes a PUT request to the provided URL

  Makes an HTTP PUT request to `url` with the given `body`. To set specific
  headers in the request, the user can provide a struct/table as `headers`. The
  body and headers will be sent securely to `curl` via stdin.
  ```
  [url &named headers body]
  (default headers {})
  (default body "")
  (request "PUT" url headers body))
