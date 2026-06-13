# 待確認冗餘清單

以下項目目前**先保留**，因為還無法確認是否有外部 client、既有教材連結、書籤網址或第三方系統依賴。

## API

- `src/routes/api/courses/+server.ts`

  - Repo 內目前沒找到 `/api/courses` 呼叫。
  - 待確認是否有外部前端、測試腳本或第三方系統使用。

- `src/routes/api/lessons/[lessonId]/+server.ts`
  - Repo 內目前沒找到 `/api/lessons/...` 呼叫。
  - 待確認是否有外部 client 或教材頁面直接存取。

## 頁面路由

- `src/routes/lesson/[id]/+page.svelte`
- `src/routes/lesson/[id]/+page.server.ts`

  - Repo 內目前沒找到 `/lesson/...` 站內導向。
  - 待確認是否有外部連結、書籤或 QR code 使用這組 URL。

- `src/routes/1-1/1-1.2/+page.svelte`
- `src/routes/1-1/1-1.2/+page.server.ts`
  - 功能與 `src/routes/1-1.2/*` 高度重複。
  - 待確認 `/1-1/1-1.2` 是否為既有正式網址或教材入口。

## 建議確認方式

- 檢查正式站或測試站存取紀錄。
- 詢問原開發者是否有外部系統或教材連結依賴這些路徑。
- 若未來要移除，先改為 redirect 或記錄 warning，觀察一段時間再刪除。
