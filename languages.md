
## PARADIGMS <sup>[1]</sup> 

**imperative:** programming with an explicit sequence of commands that update state  
**procedural:** imperative programming with procedure calls  
**declarative:** programming by specifying the result you want, not how to get it  
**object-oriented:** programming by defining objects that send messages to each other  
**functional:** programming with function calls that avoid any global state  


## FRAMEWORKS AND RUNTIMES

---
### Node.js

released: 2009  
use: server-side scripting  
type: runtime environment  

- runs JavaScript outside of a browser

---
### .NET

released:  
use:  
type: framework  

![comparison-of-programming-languages](/images/comparison-of-programming-languages.png)

## LANGUAGES

---
### C

released: 1972  
use: systems, applications, general-purpose  
examples: Linux kernel  

---
### C++

released: 1985  
use: systems, applications, games  
examples:  

- most 3D games are written in C++
- strong focus on performance and efficiency

---
### C#

released: 2000  
use: applications, web  
examples:  

- microsoft's .NET answer to java
- heavily object-oriented compared to C or C++

---
### COBOL

released: 1959  
use: business, legacy support, mainframes, transaction processing  
examples:  

- "Common Business-Oriented Language"
- Mostly dead, all current work in COBOL is to maintain older apps

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

released: 1996  
use: style sheet for presentation
examples:  

- "Cascading Style Sheets"
- used to describe how HTML is presented on a web page
- cornerstone of the web, along with HTML and JavaScript

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

released: 1957  
use: numerical, scientific, high-performance computing  
examples:  

- oldest high-level language

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

released: 2009  
use: applications, web, server-side, cloud  
examples: Docker, Ethereum, OpenShift, Kubernetes, Terraform  

- design heavily influenced by C

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, world!")
}
```

---
### Haskell

released: 1990  
use: applications  
examples: Xmonad window manager, Git-annex  

```haskell
factorial n = if n < 2
              then 1
              else n * factorial (n - 1)
```

---
### HTML

released:  
use:  
examples:  

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

released: 1995  
use: application, web, general-purpose  
examples:  

- "write once, run anywhere"
- known for verbose syntax
- Kotlin (released 2011) is a related Java-compatible language developed by JetBrains

```java
public class HelloWorldApp {
    public static void main(String[] args) {
        System.out.println("Hello World!"); // Prints the string to the console.
    }
}
```

---
### JavaScript

released: 1995  
use: web apps, client-side web scripting
examples:  

- enables interactive web pages

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

released: 1993  
use: scripting  
examples:  

- designed for embedded use within applications
- lightweight and portable

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
### Lisp and Clojure

released: 1958  
use:  
examples:  

- known for heavy use of parentheses
- second-oldest high-level language (behind Fortran by 1 year)
- Clojure is a common Lisp dialect

```lisp
 (defun factorial (n)
   (if (= n 0) 1
       (* n (factorial (- n 1)))))
```

---
### Pascal

---
### Perl and Raku (aka Perl 6)

released: 1987 (Perl), 2019 (Raku)  
use: general-purpose, scripting, text parsing  
examples: urxvt terminal extensions  

- old and possibly dying
- originally used in early internet back-end code
- regular expressions in Linux originate from Perl
- used as a glue language
- perceived to be inelegant due to its unplanned development

---
### PHP

released:  
use:  
examples:  

---
### Python

released: 1991  
use: general-purpose, scripting, machine learning, data science  
paradigm: multi-paradigm, but leans towards object-oriented <sup>[2]</sup>  
examples: Ansible, Openstack, Blender, Ranger file browser  

- designed to be easy to read (uses whitespace instead of brackets)
- extremely popular
- good first language

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

released: 1995  
use: general-purpose, scripting  
paradigm: 100% object-oriented: everything is an object
examples: Ruby on Rails, Homebrew package manager, Metasploit  

- designed to be productive and fun, focused on humans rather than computers
- follows the Principle of Least Astonishment and attempts to minimize programmer confusion<sup>[2]</sup>  

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

released: 2010  
use:  
examples: Alacritty terminal, Firefox's Servo engine  

- focused on safety, especially safe concurrency
- one of the most loved languages in StackOverflow's developer survey

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

released:  
use:  
examples:  

[1]: https://cs.lmu.edu/~ray/notes/paradigms/  
[2]: https://www.coursereport.com/blog/ruby-vs-python-choosing-your-first-programming-language  
