## Programming

- [Functions should be extremely small, like under 10 lines if possible](https://youtu.be/7EmboKQH8lM?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=3341)
  - Continue extracting out functions until you can't reasonably extract any more
    - Code should read like prose
  - Group functions that modify the same variables into classes

- [Functions should only have a few arguments, 3 or 4 at most](https://youtu.be/7EmboKQH8lM?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=4238)
  - Avoid using booleans as function arguments. Instead, extract the boolean portion out into its own function
  - Functions that need more arguments should receive objects or data structures

- [Functions that return values should not have side-effects](https://youtu.be/7EmboKQH8lM?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=5667)
  - Only functions that return nothing should have side-effects

- [Every line of a function should be at the same level of abstraction](https://youtu.be/7EmboKQH8lM?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=2773)
