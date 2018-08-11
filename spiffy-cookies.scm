(module spiffy-cookies
  (set-cookie! delete-cookie! read-cookie)

(import scheme)
(cond-expand
  (chicken-4
   (import chicken data-structures)
   (use intarweb spiffy))
  (chicken-5
   (import (chicken base)
           (chicken string))
   (import intarweb spiffy))
  (else (error "Unsupported CHICKEN version.")))


(define (set-cookie! name value #!key comment max-age domain path secure expires http-only)
  (update-header-contents!
   'set-cookie
   (list
    (vector
     (cons name value)
     `((comment . ,comment)
       (max-age . ,max-age)
       (domain  . ,domain)
       (path    . ,path)
       (secure  . ,secure)
       (expires . ,expires)
       (HttpOnly . ,http-only)
       (version . 1))))
   (response-headers (current-response))))

(define (delete-cookie! name #!key domain path)
  (set-cookie! name "" max-age: 0 domain: domain path: path))

(define (read-cookie name)
  (alist-ref (->string name)
             (header-values 'cookie
                            (request-headers (current-request)))
             equal?))

) ;; end module
