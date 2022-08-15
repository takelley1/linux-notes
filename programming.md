## PROGRAMMING

### Uncle Bob - The only way to go fast is to go well! - https://www.youtube.com/watch?v=7EmboKQH8lM&list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&index=1

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

- [Comments are for when we can't express ourselves clearly enough in code](https://youtu.be/2a_ytyt9sf8?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=598)
  - [Use the names of functions and variables to explain code rather than comments](https://youtu.be/2a_ytyt9sf8?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=879)

- [Use longer variable names in larger scopes, shorter variable names in narrower scopes](https://youtu.be/2a_ytyt9sf8?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=3146)
- [Function names are the opposite - SHORTER function names in wider scopes, LONGER function names in narrower scopes](https://youtu.be/2a_ytyt9sf8?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=3258)

- Rules of [Test-driven Development](https://youtu.be/58jGpV2Cg50?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=1436)
  1. You're not allowed to write any production code until you've first written a test that fails (the test fails because the production code doesn't exist)
  2. You're not allowed to write more of a test than what is sufficient for it to fail
  3. You're not allowed to write any more production code than what is sufficient to pass the failing test
  - When following these rules, all the code you're working on was fully-functional 1 minute ago
  - The unit-tests also function as low-level documentation for the code
  - [Test-drive development demo](https://youtu.be/58jGpV2Cg50?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=2647)

- [Having a good application architecture allows you to defer major decisions](https://youtu.be/sn0aFEMVTpA?list=PLmmYSbUCWJ4x1GO839azG_BBw8rkh-zOj&t=6486)
