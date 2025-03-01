(use ../deps/testament)
(import ../lib/churlish)


# Response success tests

(deftest get-success
  (def resp (churlish/get "https://example.org"))
  (is (== [:body :headers :protocol :status] (sort (keys resp))))
  (is (== 200 (resp :status)))
  (is (not (empty? (resp :body)))))


# Response failure tests

(deftest invalid-domain
  (assert-thrown-message
    "HTTP request failed: curl: (6) Could not resolve host: example"
    (churlish/get "https://example")))


(run-tests!)
