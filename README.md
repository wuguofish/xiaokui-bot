# xiaokui-bot

小葵 Discord Listener Bot 的獨立工作目錄。

目前穩定版本是 Phase 3B：
- `bot_xiaokui.py` 已支援 `stdio` / `ws` 兩種 transport
- 可用 `CODEX_TRANSPORT=ws` 切到 WebSocket 模式
- `CODEX_WS_URL` 預設為 `ws://127.0.0.1:45888`
- ws 初始化會自動做健康檢查與退避重試
- stack 啟動腳本會等待 app-server port ready 再拉起 bot
- app-server 重啟後，既有 thread 恢復已完成實測
- backend 失敗時，bot 會補發一則簡短 fallback 回覆
- Discord 端會用 reaction 標示處理中、成功或失敗
- 每個 Discord 頻道仍維持持久化 Codex thread，對應寫在 `temp/xiaokui_threads.json`

## 主要檔案

- `bot_xiaokui.py`：小葵主程式
- `config_xiaokui.json`：頻道與 allowlist 設定
- `.env.xiaokui`：本機實際執行設定，不納入版控
- `.env.xiaokui.example`：環境變數範例
- `start_xiaokui.bat`：Windows 啟動腳本
- `start_codex_app_server.bat`：獨立啟動 WebSocket app-server
- `start_xiaokui_stack.bat`：一鍵啟動 WebSocket app-server + bot

## 啟動方式

最省事的方式是直接雙擊 `start_xiaokui.bat`。

它會自動做這些事：
- 檢查 `.env.xiaokui` 是否存在
- 如果沒有 `.venv` 就自動建立
- 自動安裝或更新 `requirements.txt` 依賴
- 用虛擬環境啟動 `bot_xiaokui.py`

第一次啟動會比較慢，因為要建立虛擬環境和安裝套件。

如果你想手動啟動，也可以照下面做：

1. 建立虛擬環境：

```powershell
python -m venv .venv
```

2. 安裝依賴：

```powershell
.venv\Scripts\python -m pip install -r requirements.txt
```

3. 依照 `.env.xiaokui.example` 建好 `.env.xiaokui`

4. 啟動：

```powershell
.venv\Scripts\python bot_xiaokui.py
```

補充：
- `CODEX_PATH` 可以填 `codex`、`codex.cmd`、`codex.exe` 或 `codex.ps1`
- Windows 下如果 `codex` 是用 Node/npm 裝的 wrapper，小葵現在會自動解析常見的 `.cmd` / `.ps1`

## WebSocket 模式

如果要試 3B 的 WebSocket transport，有兩種方式：

1. 先在 `.env.xiaokui` 設定：

```text
CODEX_TRANSPORT=ws
CODEX_WS_URL=ws://127.0.0.1:45888
CODEX_CONNECT_RETRIES=4
CODEX_RETRY_BASE_SEC=2
```

2. 啟動 app-server：

```powershell
start_codex_app_server.bat
```

3. 再啟動 bot：

```powershell
start_xiaokui.bat
```

如果想一口氣全部拉起來，直接用 `start_xiaokui_stack.bat`。
