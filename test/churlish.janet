(use ../deps/testament)
(import ../deps/medea :as json)
(import ../lib/churlish)

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

# Response failure tests

(deftest invalid-domain
  (assert-thrown-message
    "HTTP request failed: curl: (6) Could not resolve host: example"
    (churlish/http-get "https://example")))

(run-tests!)
