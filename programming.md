## PARADIGMS
[1]

- **imperative: programming with an explicit sequence of commands that update state**
  - **procedural: imperative programming with procedure calls**
  ```
  start:
    numPeople = length(people)
    if i >= numPeople goto finished
    p = people[i]
    nameLength = length(p.name)
    if nameLength <= 5 goto nextOne
    upperName = toUpper(p.name)
    addToList(result, upperName)
  nextOne:
    i = i + 1
    goto start
  finished:
    return sort(result)
    ```
 
- **declarative: programming by specifying the result you want, not how to get it**
  ```
  select upper(name)
  from people
  where length(name) > 5
  order by name
  ```

- **object-oriented: programming by defining objects that send messages to each other**
  ```
  result = []
  for p in people {
      if p.name.length > 5 {
          result.add(p.name.toUpper);
      }
  }
  return result.sort;
  ```

- **functional: programming with function calls that avoid any global state.**
  ```
  let
      fun uppercasedLongNames [] = []
        | uppercasedLongNames (p :: ps) =
            if length(name p) > 5 then (to_upper(name p))::(uppercasedLongNames ps)
            else (uppercasedLongNames ps)
  in
      sort(uppercasedLongNames(people))
  ```

## LANGUAGES

---
## C

released:  
use: systems, applications, general-purpose  
examples: Linux kernel  

---
## C++

released:  
use: systems, applications, games  
examples:  

- most 3D games are written in C++

---
## C\#

released:  
use: applications, web  
examples:  

---
## COBOL

---
## Fortran

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
## Go

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
## Haskell

released: 1990  
use: applications  
examples: Xmonad window manager, Git-annex  

```haskell
factorial n = if n < 2
              then 1
              else n * factorial (n - 1)
```

---
## Java and Kotlin

released: 1995  
use: application, web, general-purpose  
examples:  

- "write once, run anywhere"
- known for verbose syntax

```java
public class HelloWorldApp {
    public static void main(String[] args) {
        System.out.println("Hello World!"); // Prints the string to the console.
    }
}
```

---
## Lua

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
## Lisp and Clojure

released: 1958  
use:  
examples:  

- known for heavy use of parenthesis
- second-oldest high-level language (behind Fortran by 1 year)

```lisp
 (defun factorial (n)
   (if (= n 0) 1
       (* n (factorial (- n 1)))))
```

---
## Perl and Raku (aka Perl 6)

released: 1987 (Perl), 2019 (Raku)  
use: general-purpose, scripting, text parsing  
examples: urxvt terminal extensions  

- old and possibly dying
- originally used in early internet back-end code
- regular expressions in Linux originate from Perl
- used as a glue language
- perceived to be inelegant due to its unplanned development

---
## Python

released: 1991  
use: general-purpose, scripting, machine learning, data science  
paradigm: multi-paradigm, but leans towards object-oriented [2]
examples: Ansible, Openstack, Blender, Ranger file browser  

- designed to be easy to read (uses whitespace instead of brackets)
- extremely popular
- good first language

```python
# Python code to demonstrate naive method 
# to compute factorial 
n = 23
fact = 1
  
for i in range(1,n+1): 
    fact = fact * i 
      
print ("The factorial of 23 is : ",end="") 
print (fact) 
```

---
## Ruby

released: 1995  
use: general-purpose, scripting  
paradigm: 100% object-oriented: everything is an object
examples: Ruby on Rails, Homebrew package manager, Metasploit  

- designed to be productive and fun, focused on humans rather than computers
- follows the Principle of Least Astonishment and attempts to minimize programmer confusion [2]

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
## Rust

released:  
use:  
examples: Alacritty terminal  

---
## Scala

released:  
use:  
examples:  

---
## WEB LANGUAGES

### PHP

### HTML

### CSS

### JavaScript and Node.js

---
#### sources

[1] https://cs.lmu.edu/~ray/notes/paradigms/  
[2] https://www.coursereport.com/blog/ruby-vs-python-choosing-your-first-programming-language  
