
## [Llamafile](https://github.com/Mozilla-Ocho/llamafile)

- Running llama 3.1 llamafile and prompt style:
  ```bash
  ./llama3.1-8b-instruct.llamafile --temp 0 -ngl 999 -c 45000 -p 'Who is the 45th president?<|end_header_id|>' --silent-prompt 2>/dev/null
  ```
  - `-ngl 999` = Offload to GPU
  - `-c 45000` = Allocate 45000 tokens
  - Note the `<|end_header_id|>` at end of prompt. If this isn't present the output will continue forever.
