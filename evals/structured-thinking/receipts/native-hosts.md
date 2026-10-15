# Native host smoke receipts

Date: 2026-10-14. Each recorded runtime process completed with exit 0 unless noted.
Project copies contain the whole skills/structured-thinking/ folder under .agents/skills/.
No host was given the absolute entrypoint path in its task prompt.

## Codex decision-matrix run

Invocation (outputs redirected outside the subject workspace):

```text
codex exec --ignore-user-config --ephemeral --skip-git-repo-check -s read-only
  -C /tmp/structured-thinking-eval.KNJQS0/native --json
  -o /tmp/structured-thinking-eval.KNJQS0/codex-native-answer.md
```

Prompt: Use structured-thinking and a decision matrix: fit and ease weights are 60% and 40%;
A ratings 5 and 2; B ratings 3 and 5. Assess sensitivity. Read the relevant installed skill guide.
Analysis only.

Completed command trace: cat of the installed entrypoint, exit 0, 7862 output bytes,
SHA-256 df26caf8fb82cbeb7f3b89a65ddd88501992f1768f9148dd028dc116878408b1.
Then cat of references/decision-matrix.md, exit 0, 1859 bytes,
SHA-256 093dfaf3c8d58922d4f0fde230b993d0698b5975cbefb314924f4d456f6d347e.
The only additional command read the existing global agent instructions.
Final answer: [codex-native-answer.md](codex-native-answer.md).

## agy discarded run

The first agy attempt used the same subject workspace and parent receipt directory as Codex.
Its trace shows successful entrypoint and decision-matrix reads, then reads of
../codex-native-answer.md and ../baseline.md. This invalidates its independence.
The answer is not used in case grading or the baseline comparison.

## agy isolated decision-matrix run

```text
agy --mode plan --sandbox
  --log-file /tmp/structured-thinking-eval.KNJQS0/agy-clean.log
  --print-timeout 90s --output-format stream-json -p <prompt below>
```

Cwd: /tmp/structured-thinking-native-clean.qQv8Xl.
Prompt: Use structured-thinking with a decision matrix on only this supplied data. Weights are
fit 70%, ease 30%. A ratings are fit 4, ease 2; B ratings fit 2, ease 5; C fit 5, ease unknown.
Higher is better. Assess scores and weight sensitivity without inventing missing ratings. Read
the installed entrypoint and relevant guide. Only read files inside this workspace; do not inspect
parent directories, logs, transcripts, other test outputs or files outside the workspace. No commands
or writes are needed. Analysis only, keep the answer concise.

[agy-clean-trace.txt](agy-clean-trace.txt) contains the two view_file calls and SUCCESS response.
No outside reads appear in this run. The response keeps the unknown option conditional, reports
the correct scores and weight threshold, and offers an evidence-gathering next step.

## Controlled comparison invocation

Both arms: codex exec --ignore-user-config --ephemeral --skip-git-repo-check -m gpt-6-astra
-s read-only --json -o <separate output path>, using separate -C workspaces.
Baseline cwd: /tmp/st-baseline-KNJQS0. Assisted cwd: /tmp/st-with-KNJQS0.
Both receive: read six-cases.json; answer independently by ID; read only this workspace;
no other outputs, parents, logs, browsing, or edits; concise substantive answers; do not self-grade.
Baseline additionally says not to load skills/references. Assisted says to use structured-thinking
and the relevant references. Exact inputs are the F07/F09/F13/F18/F22/B03 records in ../inputs.json.
Both exit 0. [controlled-traces.txt](controlled-traces.txt) records successful reads and output hashes.

## Final metadata smoke runs

Final entrypoint metadata adds license: MIT and metadata.author: jadmadi. The body is unchanged.
Codex and agy were rerun with the final copied entrypoint and concept-map.md; both exited 0.
[final-native-traces.txt](final-native-traces.txt) records the selected reads and agy's answer.
Input is the F17 three-relationship scenario, with explicit workspace-only reads and no writes
or browsing. Codex used the same flags as the controlled comparison with -m gpt-6-astra;
agy used the same flags as the clean matrix test, with separate final output/log paths.
Codex returned only the three relationships. agy preserved the three relationships but added
unrequested framing and next-step prose, a formatting limitation rather than a discovery failure.
