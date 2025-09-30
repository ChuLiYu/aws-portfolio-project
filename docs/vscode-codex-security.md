# VS Code + Codex 本機開發與安全設定筆記

> 本筆記整理在 macOS 上使用 Visual Studio Code（含 Remote Containers 擴充套件）與 Codex CLI 進行本機開發時的環境配置、安全設定與日常操作守則，方便後續在 GitHub 上分享或備忘。

## 1. 環境與工具概覽
- **主機環境**：macOS（Apple Silicon 或 Intel 皆可），Docker Desktop 已安裝並啟用。
- **編輯器**：Visual Studio Code（保持最新版），建議安裝 `ms-vscode-remote.remote-containers` 與 `openai.chatgpt` 擴充套件。
- **CLI**：Codex CLI（`codex`），負責與代理互動並套用沙箱設定。
- **專案結構**：倉庫根目錄可假設為 `~/workspace/my-project`（以下稱 *workspace root*），配合 `.devcontainer/devcontainer.json` 提供容器化開發體驗。

## 2. VS Code 與 Dev Container 設定重點
- `remoteUser` 設為 `node` 並調整 `remoteEnv`，確保 VS Code Server 安裝於 `/home/node/.vscode-server`。
- 保持 `runArgs` 的 `--read-only` 以提升安全性，並透過 `--tmpfs` 及 `-v ${HOME}/.codex:/home/node/.codex:rw` 僅開放必要的可寫路徑。
- 為避免 Dev Containers 啟動流程寫入 `/etc/*`，在 `.devcontainer/devcontainer.json` 新增：
  ```json
  "userEnvProbe": "none",
  "updateRemoteUserUID": false
  ```
  如此一來，容器仍以唯讀根檔案系統運作，但 VS Code Server 與暫存資料可正常寫入。

## 3. Codex CLI 全域與 Profile 設定
Codex 的設定檔位於 `~/.codex/config.toml`，內含一組保守的全域預設與三個情境 Profile。以下範例內容已去識別化，可依實際需求調整：
```toml
# 全域預設（保守）
sandbox_mode = "workspace-write"
approval_policy = "on-failure"

[profiles.dev]      # 推薦平時用：出事才問
sandbox_mode = "workspace-write"
approval_policy = "on-failure"

[profiles.analyze]  # 只讀分析
sandbox_mode = "read-only"
approval_policy = "never"

[profiles.quick]    # 需要高效率、少打擾時再用
sandbox_mode = "workspace-write"
approval_policy = "never"
```
- **全域預設**：採用 `workspace-write` + `on-failure`，在大多數情況下僅允許對工作目錄寫入；若命令失敗才會要求升級權限。
- **profiles.dev**：與全域相同，適合日常開發；若容器內已有足夠權限，失敗時再決定是否升級。
- **profiles.analyze**：強制只讀且拒絕升級，非常適合純檢視或審查時使用。
- **profiles.quick**：允許寫入且永不要求確認，僅在短時間需要高效率的情境使用，避免長期套用以降低風險。

### Profile 切換方式
```bash
codex profile use dev       # 日常模式（預設）
codex profile use analyze   # 只讀檢視
codex profile use quick     # 快速模式
```
切換後可以 `codex profile show` 核對目前生效的設定。

## 4. 本機工作流程範例
1. **啟動容器**：在 VS Code Command Palette 執行 `Dev Containers: Reopen in Container` 或直接以 `codex` 配置的 shell 進入容器。
2. **確認沙箱狀態**：在整合終端輸入 `codex profile show`，確定當前使用的是預期的 profile。
3. **進行開發**：
   - 全部檔案預設僅可在倉庫內寫入。
   - 如需修改配置（例如 `.devcontainer/devcontainer.json`），可直接使用 VS Code 編輯並 git 追蹤。
4. **測試與執行**：
   - 盡量在容器內跑測試，避免破壞主機環境。
   - 若命令被 sandbox 阻擋，先評估是否真的需要擴權，再考慮切換 profile 或透過 `codex run --escalate` 取得一次性授權。
5. **提交變更**：
   - 使用 `git status`、`git diff` 檢查修改。
   - 在提交前可加上驗證步驟（單元測試、Lint）。

## 5. 安全操作守則
- **最小權限原則**：預設使用 `profiles.dev` 或 `profiles.analyze`，確保僅在需要時放寬限制。
- **暫存路徑管理**：`--tmpfs` 參數確保敏感暫存資料不落地；若需要持久化，改用專用 volume。
- **密鑰與憑證控管**：機密資訊一律放在安全的密鑰管理機制（例如 macOS Keychain 或雲端 Secret Manager），不要硬寫在 `config.toml` 或容器環境變數中。
- **監控可寫掛載**：只有 `/workspace`、`/home/node/.vscode-server`、`/var/devcontainer` 以及綁定的 `.codex` 資料夾可寫，降低意外修改系統檔案的風險。
- **升級請求審慎處理**：遇到 `approval_policy = "on-request"` 或手動升級時，務必檢查命令內容與目的。
- **記錄與回溯**：保持 Git 提交訊息清楚，必要時在筆記（例如本文件）中紀錄更動原因。

## 6. 將筆記發佈到 GitHub 的建議流程
1. 將本文件加入 Git 版控：
   ```bash
   git add docs/vscode-codex-security.md
   git commit -m "docs: add vscode + codex security setup notes"
   git push origin <branch>
   ```
2. 在 Pull Request 或 README 中加入連結，便於團隊參考。
3. 定期檢視實際操作流程是否與筆記一致，若環境或政策更新，記得同步調整文件。

---

以上內容可直接拷貝到 GitHub 的 wiki、專案文件或個人部落格，協助其他成員快速理解 VS Code + Codex 的安全開發工作流程。
