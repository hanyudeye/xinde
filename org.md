
# Table of Contents

1.  [org](#org0449e51)
    1.  [安装](#orgcc2cdc2)
    2.  [调试错误](#org9b9076d)
    3.  [设计大纲页面](#orgf30e409)
        1.  [](#orgcd9d7c7)
2.  [org mode](#org5315679)
    1.  [输出github 的markdown 文件](#orgc3b94f8)


<a id="org0449e51"></a>

# org

官网 <http://orgmode.org>


<a id="orgcc2cdc2"></a>

## 安装

(add-to-list 'load-path "~/path/to/orgdir/lisp")
github 仓库
文档用 make doc
显示帮助 make help
提交错误 M-x org-submit-bug-report RET


<a id="org9b9076d"></a>

## 调试错误

$ emacs -Q -l /path/to/minimal-org.el

    ;;; Minimal setup to load latest 'org-mode'
    ;; activate debugging
    (setq debug-on-error t
          debug-on-signal nil
          debug-on-quit nil)
    ;; add latest org-mode to load path
    (add-to-list 'load-path "/path/to/org-mode/lisp")
    (add-to-list 'load-path "/path/to/org-mode/contrib/lisp" t)


<a id="orgf30e409"></a>

## 设计大纲页面


<a id="orgcd9d7c7"></a>

### 


<a id="org5315679"></a>

# org mode


<a id="orgc3b94f8"></a>

## 输出github 的markdown 文件

