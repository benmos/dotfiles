(defun add-to-hooks (fun hooks)
  "Add function to hooks"
  (dolist (hook hooks)
    (add-hook hook fun)))
(defun add-all-to-hook (hook &rest funs)
  "Add functions to hook."
  (add-to-hook hook funs))
(defun add-to-hook (hook funs)
  "Add list of functions to hook."
  (dolist (fun funs)
    (add-hook hook fun)))
