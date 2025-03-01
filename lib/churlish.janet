# Command string

(var exe
  ```
  The path to the curl executable
  ```
  (if (has-value? [:windows :mingw :cygwin] (os/which))
    "curl.exe"
    "curl"))

(defn- cmd [url]
  [exe url "-iSs" "--config" "-"])


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


# HTTP request functions

(defn get
  ```
  Makes a GET request to the provided URL

  Makes an HTTP GET request to `url`. To set specific headers in the request,
  the user can provide a struct/table as `hdrs`. The keys and values in `hdrs`
  will be sent securely to `curl` via stdin.
  ```
  [url &opt hdrs]
  (default hdrs {})
  (def [out-r out-w] (os/pipe))
  (def [err-r err-w] (os/pipe))
  (def [in-r in-w] (os/pipe))
  (each [k v] (pairs hdrs)
    (ev/write in-w (string "header = \"" k ": " v "\"\n")))
  (ev/close in-w)
  (def exit-code (os/execute (cmd url) :ep {:in in-r :err err-w :out out-w}))
  (ev/close out-w)
  (ev/close err-w)
  (if (zero? exit-code)
    (parse-response (ev/read out-r :all))
    (error (string "HTTP request failed: " (string/trim (ev/read err-r :all))))))
