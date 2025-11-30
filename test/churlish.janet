(use ../deps/testament)
(import ../deps/medea :as json)
(import ../lib/churlish)

# Response success tests

(deftest get-success
  (def resp (churlish/get "https://example.org"))
  (is (== [:body :headers :protocol :status] (sort (keys resp))))
  (is (== 200 (resp :status)))
  (is (not (empty? (resp :body)))))

(deftest post-success
  (def hdrs {"Content-Type" "application/json"})
  (def body "{\"test\": \"data\", \"message\": \"hello world\"}")
  (def resp (churlish/post "https://httpbin.org/post" :body body :headers hdrs))
  (is (== 200 (resp :status)))
  (def data (-> (resp :body) (json/decode) (get "json")))
  (is (== {"test" "data" "message" "hello world"} data)))

# Response failure tests

(deftest invalid-domain
  (assert-thrown-message
    "HTTP request failed: curl: (6) Could not resolve host: example"
    (churlish/get "https://example")))

(run-tests!)
