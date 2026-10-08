## ai

### LLMs

- GPT 5.6 Terra (Low)
  - More measured and disagreeable
  - Better at troubleshooting
  - Prefers bash for one-off scripts
  - Follows instructions better. More aligned and careful, less willing to expose secrets.
- Gemini 3.8 Flash (Low)
  - More confident and excitable
  - Better at coding and syntax correctness
  - Prefers Python for one-off scripts

### Useful questions to ask during implementation

- Ask it “why” chains like a five year old. Why X, Why Z, etc.
- Walk me through X, first high level, then descending down the layers in increasing levels of detail from a complete lay person to a subject matter expert. 10 levels of depth
- Why did you choose this approach instead of X? What assumptions does this depend on? What failure modes should I understand?
- Give me the causal chain, not just the fix.
- What parts of the architecture look suspicious?
- Give me the architecture.
- What are the five most important invariants?
- Show me every place persistent state exists.
- What can destroy data?
- What happens when the API is unavailable halfway through an operation?
- Which parts would you redesign if this had to support 100x the workload?
