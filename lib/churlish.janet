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
  (def proc (os/spawn (cmd url) :ep {:in :pipe :err :pipe :out :pipe}))
  (defer (os/proc-close proc)
    (def [_ exit-code]
      (ev/gather
        (do
          (each [k v] (pairs hdrs)
            (ev/write (proc :in) (string "header = \"" k ": " v "\"\n")))
          (ev/close (proc :in)))
        (do
          (os/proc-wait proc))))
    (if (zero? exit-code)
      (parse-response (ev/read (proc :out) :all))
      (error (string "HTTP request failed: " (string/trim (ev/read (proc :err) :all)))))))
