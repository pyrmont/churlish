(use ../deps/testament)
(import ../deps/medea :as json)
(import ../lib/churlish)

# Utility function

(defn- header
  ```
  Returns the value of the header called `name`, ignoring case

  Header names are lowercased by HTTP/2 but are sent in whatever case the
  server chooses under HTTP/1.1.
  ```
  [resp name]
  (var res nil)
  (each [k v] (pairs (resp :headers))
    (when (= (string/ascii-lower k) (string/ascii-lower name))
      (set res v)))
  res)

# Response success tests

(deftest get-success
  (def resp (churlish/http-get "https://postman-echo.com/get"))
  (def expect (if (= "HTTP/2" (resp :protocol))
                [:body :headers :protocol :status]
                [:body :headers :protocol :reason :status]))
  (is (== expect (sort (keys resp))))
  (is (== 200 (resp :status)))
  (is (not (empty? (resp :body)))))

(deftest post-success
  (def hdrs {"Content-Type" "application/json"})
  (def body "{\"test\": \"data\", \"message\": \"hello world\"}")
  (def resp (churlish/http-post "https://postman-echo.com/post" :body body :headers hdrs))
  (is (== 200 (resp :status)))
  (def data (-> (resp :body) (json/decode) (get "json")))
  (is (== {"test" "data" "message" "hello world"} data)))

(deftest put-success
  (def hdrs {"Content-Type" "application/json"})
  (def body "{\"test\": \"data\", \"message\": \"hello world\"}")
  (def resp (churlish/http-put "https://postman-echo.com/put" :body body :headers hdrs))
  (is (== 200 (resp :status)))
  (def data (-> (resp :body) (json/decode) (get "json")))
  (is (== {"test" "data" "message" "hello world"} data)))

(deftest patch-success
  (def hdrs {"Content-Type" "application/json"})
  (def body "{\"test\": \"data\", \"message\": \"hello world\"}")
  (def resp (churlish/http-patch "https://postman-echo.com/patch" :body body :headers hdrs))
  (is (== 200 (resp :status)))
  (def data (-> (resp :body) (json/decode) (get "json")))
  (is (== {"test" "data" "message" "hello world"} data)))

(deftest delete-success
  (def resp (churlish/http-delete "https://postman-echo.com/delete"))
  (is (== 200 (resp :status)))
  (is (not (empty? (resp :body)))))

(deftest delete-with-body-success
  (def hdrs {"Content-Type" "application/json"})
  (def body "{\"test\": \"data\", \"message\": \"hello world\"}")
  (def resp (churlish/http-delete "https://postman-echo.com/delete" :body body :headers hdrs))
  (is (== 200 (resp :status)))
  (def data (-> (resp :body) (json/decode) (get "json")))
  (is (== {"test" "data" "message" "hello world"} data)))

(deftest head-success
  (def resp (churlish/http-head "https://postman-echo.com/get"))
  (is (== 200 (resp :status)))
  (is (not (nil? (header resp "Content-Type"))))
  (is (empty? (resp :body))))

(deftest options-success
  (def resp (churlish/http-options "https://postman-echo.com/get"))
  (is (== 200 (resp :status)))
  (is (not (nil? (header resp "Allow")))))

# Response failure tests

(deftest invalid-domain
  (assert-thrown-message
    "HTTP request failed: curl: (6) Could not resolve host: example"
    (churlish/http-get "https://example")))

(run-tests!)
