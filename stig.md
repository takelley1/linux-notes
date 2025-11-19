# DISA STIG

## Automate the Application Security and Development STIG with Claude

- Install Claude Code
- Place the ASD STIG .ckld file in the current directory
```bash
for i in $(seq 1 20); do claude -p --allowedTools "Bash(jq:*) Edit Read" --dangerously-skip-permissions "You are a security researcher evaluating the complaince of the ClickHouse against the DISA Application Security and Develop
ent STIG guidelines. Use your built in knowledge to evaluate whether ClickHouse is compliant. Use your jq tools to find the first 'not reviewed' vulnerability, determine if ClickHouse is compliant, then mark the vulnerability accordingly and include a brief one sentence d
escription in the comments field explaining your rationale. When you are done, print a summary of the vulnerability, print your evaluation for whether it was a finding, and print your justification. use your Edit tool to edit the file after. Do tour Edit tool to edit the
checklist file."; done
```
