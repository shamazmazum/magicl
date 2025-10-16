(in-package #:magicl.foreign-libraries)

(cffi:define-foreign-library liblapack
  #+:magicl.use-accelerate
  (:darwin "libLAPACK.dylib" :search-path #P"/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/Versions/A/")
  ;; If the user has done so, it is likely this is the location where
  ;; Homebrew installed LAPACK. Prefer it over the system LAPACK
  ;; because it's more complete. (macOS-provided LAPACK doesn't have a
  ;; lot of the more obscure subroutines.)
  #-:magicl.use-accelerate
  (:darwin (:or
            "/opt/homebrew/opt/lapack/lib/liblapack.dylib"
            "/usr/local/opt/lapack/lib/liblapack.dylib"
            "liblapack.dylib"))
  #+:magicl.use-mkl
  (:unix  "libmkl_rt.so")
  #-:magicl.use-mkl
  (:unix  (:or "libopenblas.so"
               "libopenblas.so.0"))
  (t (:default "libopenblas")))

(pushnew 'liblapack *foreign-libraries*)
(export 'liblapack)

(defvar *blapack-libs-loaded* nil)

(unless *blapack-libs-loaded*
  (cffi:load-foreign-library 'liblapack)
  (setf *blapack-libs-loaded* t))

(magicl:define-backend :lapack
  :documentation "Backend for LAPACK functionality written in Fortran."
  :default t)
