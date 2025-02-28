(def- is-win? (has-value? [:windows :mingw :cygwin] (os/which)))

(var exe
  ```
  The path to the curl executable
  ```
  (if is-win?
    "curl.exe"
    "curl"))


(def- cmd [exe "-iSs"])


(defn- parse-string
  [s]
  (def g ~{:main  (/ (* :start :hdrs :eol :body) ,table)
           :start (* :prot " " :code " " :rp :eol)
           :prot  (* (constant :protocol) '(to :s))
           :code  (* (constant :status) (number :d+))
           :rp    (* (constant :reason) '(to :eol))
           :hdrs  (* (constant :headers) (/ (any :hdr) ,table))
           :hdr   (* (not :eol) '(to ":") ":" (? " ") '(to :eol) :eol)
           :body  (* (constant :body) '(thru -1))
           :eol   (* "\r\n")})
  (def matches (peg/match g s))
  (if (nil? matches)
    (error "failed to parse HTTP response")
    (first matches)))


(defn get
  ```
  Make a GET request to the provided URL
  ```
  [url]
  (def [out-r out-w] (os/pipe))
  (def [err-r err-w] (os/pipe))
  (def exit-code (os/execute [;cmd url] :ep {:out out-w :err err-w}))
  (ev/close out-w)
  (ev/close err-w)
  (if (zero? exit-code)
    (parse-string (ev/read out-r :all))
    (error (string "HTTP request failed: " (string/trim (ev/read err-r :all))))))
