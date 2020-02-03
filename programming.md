# COMPARISON OF PROGRAMMING LANGUAGES

---
## C

use: systems, applications, general-purpose
released:
examples: Linux kernel

---
## C++

use: systems, applications, games
released:
examples:

- most 3D games are written in C++

---
## C\#

use: applications, web
released:
examples:

---
## COBOL

---
## Fortran

use: numerical, scientific, high-performance computing
released: 1957
examples:

- oldest high-level language

sample:
```fortran
C     AREA OF A TRIANGLE
      READ*,A,B,C
      S=(A+B+C)/2
      A=SQRT(S*(S-A)*(S-B)*(S-C))
      PRINT*,"AREA=",A
      STOP
      END
```

---
## Go

use: applications, web, server-side, cloud
released: 2009
examples: Docker, Ethereum, OpenShift, Kubernetes, Terraform

- Design heavily influenced by C

sample:
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, world!")
}
```

---
## Haskell

use: applications
released: 1990
examples: Xmonad window manager, Git-annex

sample:
```haskell
factorial n = if n < 2
              then 1
              else n * factorial (n - 1)
```

---
## Java

use: application, web, general-purpose
released: 1995
examples:

- "write once, run anywhere"
- known for verbose syntax

sample:
```java
public class HelloWorldApp {
    public static void main(String[] args) {
        System.out.println("Hello World!"); // Prints the string to the console.
    }
}
```

---
## Lua

use: scripting
released: 1993
examples:

- designed for embedded use within applications
- lightweight and portable

sample:
```lua
function factorial(n)
  local x = 1
  for i = 2, n do
    x = x * i
  end
  return x
end
```

---
## Lisp and Clojure

use:
released: 1958
examples:

- known for heavy use of parenthesis
- second-oldest high-level language (behind Fortran by 1 year)

sample:
```lisp
 (defun factorial (n)
   (if (= n 0) 1
       (* n (factorial (- n 1)))))
```

---
## Perl and Raku (aka Perl 6)

use: general-purpose, scripting, text parsing
released: 1987 (Perl), 2019 (Raku)
examples: urxvt terminal extensions

- old and possibly dying
- originally used in early internet back-end code
- regular expressions in Linux originate from Perl
- used as a glue language
- perceived to be inelegant due to its unplanned development

sample code:

---
## Python

use: general-purpose, scripting, machine learning
released: 1991
examples: Ansible, Openstack, Blender, Ranger file browser

- designed to be easy to read
- extremely popular
- good first language

---
## Ruby

use: general-purpose, scripting
released: 1995
examples: Ruby on Rails, Homebrew package manager, Metasploit

- designed to be productive and fun
- follows the Principle of Least Astonishment and attempts to minimize programmer confusion

---
## Rust

use:
released:
examples: Alacritty terminal

---
## Scala

use:
released:
examples:

---
## WEB LANGUAGES

### PHP

### HTML

type: markup

### CSS

type: markup

### JavaScript and Node.js

type: scripting

