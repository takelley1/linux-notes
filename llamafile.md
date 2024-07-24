
## [Llamafile](https://github.com/Mozilla-Ocho/llamafile)

- Running llama 3.1 llamafile and prompt style:
  ```bash
  ./llama3.1-8b-instruct.llamafile --temp 0 -ngl 999 -p 'Who is the 45th president?<|end_header_id|>' --silent-prompt 2>/dev/null
  ```
  - Note the `<|end_header_id|>` at end of prompt.
