
## PARADIGMS <sup>[1]</sup>

- **Imperative:** Programming with an explicit sequence of commands that update state.<br>
  - **Procedural:** Imperative programming with procedure calls.<br>
  - **Object-oriented:** Programming by defining objects that send messages to each other.<br>
- **Declarative:** Programming by specifying the result you want, not how to get it.<br>
  - **Functional:** Programming with function calls that avoid any global state.<br>


## FRAMEWORKS AND RUNTIMES

---
### Node.js

Released: 2009<br>
Type: Runtime environment<br>
Use: Server-side scripting<br>

- Runs JavaScript outside of a browser.

---
### .NET

Released:<br>
Type: Framework<br>
Use:<br>

![comparison-of-programming-languages](/images/comparison-of-programming-languages.png)

## LANGUAGES

---
### C

Examples: Linux kernel<br>
Paradigm:
Released: 1972<br>
Use: Systems, apps, general-purpose<br>

---
### C++

Examples:<br>
Released: 1985<br>
Use: Systems, apps, games<br>

- Most 3D games are written in C++.
- Strong focus on performance and efficiency.

---
### C#

Examples:<br>
Released: 2000<br>
Use: Apps, web<br>

- Microsoft's .NET answer to Java.
- Heavily object-oriented compared to C or C++.

---
### COBOL

*Common Business-Oriented Language*

Examples:<br>
Released: 1959<br>
Use: Business, legacy support, mainframes, transaction processing<br>

- Mostly dead, all current work in COBOL is to maintain older apps.

```cobol
  OPEN INPUT sales, OUTPUT report-out
  INITIATE sales-report

  PERFORM UNTIL 1 <> 1
      READ sales
          AT END
              EXIT PERFORM
      END-READ

      VALIDATE sales-record
      IF valid-record
          GENERATE sales-on-day
      ELSE
          GENERATE invalid-sales
      END-IF
  END-PERFORM

  TERMINATE sales-report
  CLOSE sales, report-out
  .
```

---
### CSS

*Cascading Style Sheets*

Examples:<br>
Released: 1996<br>
Use: Style sheet for presentation<br>

- Used to describe how HTML is presented on a web page.
- Cornerstone of the web, along with HTML and JavaScript.

```css
body {
   overflow: hidden;
   background-color: #000000;
   background-image: url(images/bg.gif);
   background-repeat: no-repeat;
   background-position: left top;
}
```

---
### Fortran

Examples:<br>
Released: 1957<br>
Use: Numerical, scientific, high-performance computing<br>

- Oldest high-level language.

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
### Go

Examples: Docker, Ethereum, OpenShift, Kubernetes, Terraform<br>
Released: 2009<br>
Use: Applications, web, server-side, cloud<br>

- Design heavily influenced by C.

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, world!")
}
```

---
### Haskell

Examples: Xmonad window manager, Git-annex<br>
Released: 1990<br>
Use: Applications<br>

```haskell
factorial n = if n < 2
              then 1
              else n * factorial (n - 1)
```

---
### HTML

Examples:<br>
Released:<br>
Use:<br>

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <style>
    #xyz { color: blue; }
    </style>
  </head>
  <body>
    <p id="xyz" style="color: green;"> To demonstrate specificity </p>
  </body>
</html>
```

---
### Java and Kotlin

Examples:<br>
Released: 1995<br>
Use: Apps, web, general-purpose<br>

- "Write once, run anywhere".
- Known for verbose syntax.
- Kotlin (released 2011) is a related Java-compatible language developed by JetBrains.

```java
public class HelloWorldApp {
    public static void main(String[] args) {
        System.out.println("Hello World!"); // Prints the string to the console.
    }
}
```

---
### JavaScript

Examples:<br>
Released: 1995<br>
Use: Web apps, client-side web scripting<br>

- Enables interactive web pages.

```javascript
function factorial(n) {
    if (n === 0)
        return 1; // 0! = 1

    return n * factorial(n - 1);
}

factorial(3); // returns 6
```

---
### Lua

Examples:<br>
Released: 1993<br>
Use: Scripting<br>

- Designed for embedded use within applications.
- Lightweight and portable.

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
### Lisp

*LISt Processing*

Dialects: [Clojure](https://clojure.org), [Common Lisp](https://lisp-lang.org/), Emacs Lisp, Racket, Scheme
Examples: Emacs, Grammarly<br>
Paradigm: Functional, procedural
Released: 1958<br>
Use: AI, scripting, apps<br>

- Technically a family of programming languages.
- Recently seen a resurgence
- Known for heavy use of parentheses and prefix-style syntax.
- Second-oldest high-level language (behind Fortran by 1 year).

```lisp
 (defun factorial (n)
   (if (= n 0) 1
       (* n (factorial (- n 1)))))
```

---
### Pascal <sup>[3]</sup>

Examples:<br>
Paradigm: Procedural
Released: 1970<br>
Use:<br>

- Emphasis on structured programming.
- Designed to improve upon ALGOL, FORTRAN, and COBOL.
- Popular in the 1970s and 80s.
- Replaced by C and C++

---
### Perl and Raku

Examples: Urxvt terminal extensions<br>
Paradigm:
Released: 1987 (Perl), 2019 (Raku)<br>
Use: General-purpose, scripting, text parsing<br>

- Old and possibly dying.
- Perl 6 became Raku, a separate project.
- Originally used in early internet back-end code.
- Regular expressions in Linux originate from Perl.
- Popular as a "glue language".
- Perceived to be inelegant due to its unplanned development.

---
### PHP

Examples:<br>
Released:<br>
Use:<br>

---
### Python

Examples: Ansible, Openstack, Blender, Ranger file browser<br>
Paradigm: Multi-paradigm, but leans towards object-oriented <sup>[2]</sup><br>
Released: 1991<br>
Use: General-purpose, scripting, machine learning, data science<br>

- Designed to be easy to read (uses whitespace instead of brackets).
- Extremely popular.
- Good first language.

```python
# computing a factorial
n = 23
fact = 1

for i in range(1,n+1):
    fact = fact * i

print ("The factorial of 23 is : ",end="")
print (fact)
```

---
### Ruby

Examples: Puppet, Chef, Ruby on Rails, Homebrew, Metasploit<br>
Paradigm: Strictly object-oriented<br>
Released: 1995<br>
Use: General-purpose, scripting<br>

- Designed to be productive and fun, focused on humans rather than computers.
- Follows the Principle of Least Astonishment and attempts to minimize programmer confusion<sup>[2]</sup>.

```ruby
def factorial(n)
 if n == 0
  return 1
 else
  return n * factorial(n-1)
 end
end
```

---
### Rust

Examples: Alacritty terminal, Firefox's Servo engine<br>
Released: 2010<br>
Use:<br>

- Focused on safety, especially safe concurrency.
- One of the most loved languages in StackOverflow's developer survey.

```rust
fn factorial(i: u64) -> u64 {
    match i {
        0 => 1,
        n => n * factorial(n-1)
    }
}
```

---
### Scala

Examples:<br>
Released:<br>
Use:<br>

[1]: https://cs.lmu.edu/~ray/notes/paradigms/
[2]: https://www.coursereport.com/blog/ruby-vs-python-choosing-your-first-programming-language
[3]: https://www.britannica.com/technology/Pascal-computer-language
