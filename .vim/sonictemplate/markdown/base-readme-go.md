{{_expr_:expand("%:p:h:t")}}
{{_expr_:repeat("=", len(expand("%:p:h:t")))}}
[![Go Reference](https://pkg.go.dev/badge/golang.org/x/pkgsite.svg)][goRef]

Usage:
------
{{_cursor_}}

See [GoDoc][goRef]

Requirements:
-------------
+ go

Install:
--------
+ go1.6 or higher
```
go install github.com/0Delta/{{_expr_:expand("%:p:h:t")}}@latest
```

+ go1.5 or lower
```
go get -u github.com/0Delta/{{_expr_:expand("%:p:h:t")}}
```

license:
--------
MIT

Author:
-------
0Δ(0deltast@gmail.com)


[goRef]:https://pkg.go.dev/github.com/0Delta/{{_expr_:expand("%:p:h:t")}}
