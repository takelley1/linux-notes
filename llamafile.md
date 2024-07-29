
## [Llamafile](https://github.com/Mozilla-Ocho/llamafile)

- Running llama 3.1 llamafile and prompt style:
  ```bash
  ./llama3.1-8b-instruct.llamafile --temp 0 -ngl 9999 -c 0 -p 'Who is the 45th president?<|end_header_id|>' --silent-prompt 2>/dev/null
  ```
  - `-ngl 9999` = Offload to GPU
  - `-c 0` = Allocate as many tokens as possible
  - Note the `<|end_header_id|>` at end of prompt. If this isn't present the output will continue forever.

- SSH into server with a llamafile and give it a prompt:
  ```bash
  scp "./llm_prompt.txt" llmserver:~/
  ssh llmserver "./llama3.1-8b-instruct.llamafile --temp 0.5 -c 0 -ngl 9999 --cli --silent-prompt --file ./llm_prompt.txt" | tee "./llm_output.txt"
  ssh llmserver "rm -v ./llm_prompt.txt"
  ```
