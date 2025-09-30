# VS Code + Codex Local Development & Security Notes

> This note summarizes how to run local development on macOS with Visual Studio Code (including the Remote Containers extension) and the Codex CLI. It collects environment setup, security practices, and daily operating tips so it can be shared or archived on GitHub.

## 1. Environment & Tool Overview
- **Host environment:** macOS (Apple Silicon or Intel), with Docker Desktop installed and running.
- **Editor:** Visual Studio Code (keep it up to date), ideally with `ms-vscode-remote.remote-containers` and `openai.chatgpt` extensions.
- **CLI:** Codex CLI (`codex`), responsible for interacting with agents while enforcing sandbox settings.
- **Project layout:** Assume the repository root is `~/workspace/my-project` (referred to as the *workspace root* below), with `.devcontainer/devcontainer.json` enabling a containerized workflow.

## 2. Key VS Code & Dev Container Settings
- Set `remoteUser` to `node` and adjust `remoteEnv` so the VS Code Server installs into `/home/node/.vscode-server`.
- Keep `--read-only` in `runArgs` for stronger protection, and rely on `--tmpfs` together with `-v ${HOME}/.codex:/home/node/.codex:rw` so only essential paths are writable.
- To stop the Dev Containers boot process from touching `/etc/*`, add the following to `.devcontainer/devcontainer.json`:
  ```json
  "userEnvProbe": "none",
  "updateRemoteUserUID": false
  ```
  This keeps the root filesystem read-only while still allowing the VS Code Server and temp data to be written safely.

## 3. Codex CLI Global & Profile Configuration
The Codex config file lives at `~/.codex/config.toml`. It ships with a conservative global default and three profiles for different scenarios. The example below is de-identified; tweak it for your own needs:
```toml
# Global default (conservative)
sandbox_mode = "workspace-write"
approval_policy = "on-failure"

[profiles.dev]      # Recommended day-to-day: only escalate when something fails
sandbox_mode = "workspace-write"
approval_policy = "on-failure"

[profiles.analyze]  # Read-only inspection
sandbox_mode = "read-only"
approval_policy = "never"

[profiles.quick]    # Use sparingly when you need uninterrupted automation
sandbox_mode = "workspace-write"
approval_policy = "never"
```
- **Global default:** `workspace-write` + `on-failure` so the CLI only writes within the workspace and escalates only when a command fails.
- **profiles.dev:** Mirrors the global default for everyday development; you can decide on escalation if a command fails.
- **profiles.analyze:** Forces read-only mode and rejects escalation—perfect for reviews.
- **profiles.quick:** Allows writes and never asks for approval; limit it to short, trusted automation bursts.

### Switching Profiles
```bash
codex -p dev       # Day-to-day mode (same as running `codex` if aliased)
codex -p analyze   # Read-only inspection
codex -p quick     # High-speed automation
```
You can also add shell aliases (for example in `~/.zshrc`):
```bash
alias codex-dev='codex -p dev'
alias codex-analyze='codex -p analyze'
alias codex-quick='codex -p quick'
alias codex='codex -p dev'  # Make `codex` default to the dev profile
```
Run `source ~/.zshrc` (or restart the terminal) to make the aliases available.

## 4. Sample Local Workflow
1. **Launch Codex or the container:** Use VS Code’s *Dev Containers: Reopen in Container* command, or run Codex with the desired profile in the terminal.
2. **Confirm the sandbox profile:** Run `codex -p dev --help` or similar to ensure you’re in the expected mode (or run `echo $CODEx_PROFILE` if you maintain an environment variable).
3. **Develop:**
   - By default, the sandbox permits writing only inside the repository.
   - Edit configuration (such as `.devcontainer/devcontainer.json`) directly in VS Code and track changes with Git.
4. **Test & run:**
   - Prefer running tests inside the container to avoid polluting the host.
   - If the sandbox rejects a command, confirm it really needs broader access before switching profiles or using `codex run --escalate 'command'` for a one-off elevation.
5. **Commit changes:**
   - Use `git status` / `git diff` to review modifications.
   - Add validation steps (unit tests, lint) before committing.

## 5. Security Best Practices
- **Least privilege:** Stay on `profiles.dev` or `profiles.analyze` by default; only relax the policies when absolutely necessary.
- **Temp-path hygiene:** The `--tmpfs` mounts keep sensitive temporary files off disk; if persistence is required, use a dedicated volume.
- **Secret management:** Store keys and secrets in a secure vault (macOS Keychain, cloud secret managers) instead of writing them into `config.toml` or container environment variables.
- **Writable-mount awareness:** Keep writable mounts limited to `/workspace`, `/home/node/.vscode-server`, `/var/devcontainer`, and the bound `.codex` folder to reduce the risk of accidental system modifications.
- **Approval discipline:** When operating in a profile with prompts (like `on-failure`), review the commands before granting sandbox escalation.
- **Traceability:** Maintain clear Git commit messages and, when appropriate, document rationale in notes like this one for better auditing.

## 6. Recommended GitHub Publishing Flow
1. Add the note to version control:
   ```bash
   git add docs/vscode-codex-security-en.md
   git commit -m "docs: add vscode + codex security setup notes (en)"
   git push origin <branch>
   ```
2. Link it in the README or a wiki entry so your team can find it easily.
3. Revisit the document whenever tooling or policy changes to keep guidance accurate.

---

Feel free to copy this note to a GitHub wiki, project docs, or a personal blog so teammates can quickly understand how to combine VS Code and Codex for secure local development.
