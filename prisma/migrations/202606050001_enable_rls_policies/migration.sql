-- ============================================================
-- RLS (Row Level Security) 政策設定
-- 此專案使用 Prisma + Supabase，API 路由透過 service_role 連線
-- 以下 RLS 政策適用於直接使用 Supabase client 存取時的安全層
-- ============================================================

-- ============================================================
-- 1. 啟用 RLS（所有 public schema 資料表）
-- ============================================================

ALTER TABLE public.profiles          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chapters          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lessons           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_sources    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quizzes           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.questions         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_progress     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.learning_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_answers      ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 2. 移除舊有政策（避免重複執行錯誤）
-- ============================================================

DROP POLICY IF EXISTS "profiles_select_own"           ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_own"           ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_own"           ON public.profiles;

DROP POLICY IF EXISTS "courses_select_active"         ON public.courses;
DROP POLICY IF EXISTS "chapters_select_active"        ON public.chapters;
DROP POLICY IF EXISTS "lessons_select_active"         ON public.lessons;
DROP POLICY IF EXISTS "lesson_sources_select"         ON public.lesson_sources;
DROP POLICY IF EXISTS "quizzes_select_active"         ON public.quizzes;
DROP POLICY IF EXISTS "questions_select_active"       ON public.questions;

DROP POLICY IF EXISTS "user_progress_select_own"      ON public.user_progress;
DROP POLICY IF EXISTS "user_progress_insert_own"      ON public.user_progress;
DROP POLICY IF EXISTS "user_progress_update_own"      ON public.user_progress;

DROP POLICY IF EXISTS "learning_sessions_select_own"  ON public.learning_sessions;
DROP POLICY IF EXISTS "learning_sessions_insert_own"  ON public.learning_sessions;
DROP POLICY IF EXISTS "learning_sessions_update_own"  ON public.learning_sessions;

DROP POLICY IF EXISTS "user_answers_select_own"       ON public.user_answers;
DROP POLICY IF EXISTS "user_answers_insert_own"       ON public.user_answers;
DROP POLICY IF EXISTS "user_answers_delete_own"       ON public.user_answers;

-- ============================================================
-- 3. profiles — 使用者只能讀取與修改自己的 profile
-- ============================================================

CREATE POLICY "profiles_select_own"
  ON public.profiles FOR SELECT
  USING (id = auth.uid());

CREATE POLICY "profiles_insert_own"
  ON public.profiles FOR INSERT
  WITH CHECK (id = auth.uid());

CREATE POLICY "profiles_update_own"
  ON public.profiles FOR UPDATE
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- ============================================================
-- 4. courses / chapters / lessons / lesson_sources — 公開唯讀
--    已登入使用者可讀取 is_active = true 的課程資料
-- ============================================================

CREATE POLICY "courses_select_active"
  ON public.courses FOR SELECT
  USING (is_active = true AND auth.role() = 'authenticated');

CREATE POLICY "chapters_select_active"
  ON public.chapters FOR SELECT
  USING (is_active = true AND auth.role() = 'authenticated');

CREATE POLICY "lessons_select_active"
  ON public.lessons FOR SELECT
  USING (is_active = true AND auth.role() = 'authenticated');

CREATE POLICY "lesson_sources_select"
  ON public.lesson_sources FOR SELECT
  USING (auth.role() = 'authenticated');

-- ============================================================
-- 5. quizzes / questions — 已登入使用者可讀取啟用中的測驗
-- ============================================================

CREATE POLICY "quizzes_select_active"
  ON public.quizzes FOR SELECT
  USING (is_active = true AND auth.role() = 'authenticated');

-- questions 跟著 quiz 走，只要能看到 quiz 就能看到題目
-- 注意：不暴露 correct_answer 欄位的保護由 API 層負責（/api/quizzes 只在已作答後才回傳解答）
CREATE POLICY "questions_select_active"
  ON public.questions FOR SELECT
  USING (
    auth.role() = 'authenticated'
    AND EXISTS (
      SELECT 1 FROM public.quizzes q
      WHERE q.id = quiz_id AND q.is_active = true
    )
  );

-- ============================================================
-- 6. user_progress — 使用者只能操作自己的進度
-- ============================================================

CREATE POLICY "user_progress_select_own"
  ON public.user_progress FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "user_progress_insert_own"
  ON public.user_progress FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "user_progress_update_own"
  ON public.user_progress FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- ============================================================
-- 7. learning_sessions — 使用者只能操作自己的學習紀錄
-- ============================================================

CREATE POLICY "learning_sessions_select_own"
  ON public.learning_sessions FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "learning_sessions_insert_own"
  ON public.learning_sessions FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "learning_sessions_update_own"
  ON public.learning_sessions FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- ============================================================
-- 8. user_answers — 使用者只能讀取/新增/刪除自己的答題紀錄
-- ============================================================

CREATE POLICY "user_answers_select_own"
  ON public.user_answers FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "user_answers_insert_own"
  ON public.user_answers FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- 允許使用者刪除自己的答案（重新測驗功能）
CREATE POLICY "user_answers_delete_own"
  ON public.user_answers FOR DELETE
  USING (user_id = auth.uid());

-- ============================================================
-- 9. 確保 service_role 不受 RLS 限制（Prisma server-side 存取）
--    Supabase 的 service_role 預設 bypass RLS，此設定僅作明確聲明
-- ============================================================

-- 注意事項：
-- Prisma 使用 DATABASE_URL（含 service_role 憑證）時，所有操作均 bypass RLS
-- RLS 政策主要保護直接使用 anon key 或 authenticated 角色的 Supabase client 存取
-- 本應用程式的安全邊界在 API 路由層（requireSupabaseUser + validation.ts）

-- ============================================================
-- 10. 公開閱讀政策（允許匿名取得課程清單，選用）
--     若需要讓未登入使用者也能瀏覽課程，取消下方註解
-- ============================================================

-- CREATE POLICY "courses_public_select"
--   ON public.courses FOR SELECT
--   USING (is_active = true);

-- CREATE POLICY "chapters_public_select"
--   ON public.chapters FOR SELECT
--   USING (is_active = true);
