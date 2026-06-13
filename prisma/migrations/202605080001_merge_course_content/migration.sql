UPDATE public.lessons lesson
SET content_url = '/' || chapter.chapter_key
FROM public.chapters chapter
WHERE lesson.chapter_id = chapter.id
  AND chapter.chapter_key IN ('1-1.2', '1-1.3', '1-2.1', '1-2.2');

UPDATE public.lessons lesson
SET is_active = FALSE
FROM public.chapters chapter
WHERE lesson.chapter_id = chapter.id
  AND (
    (chapter.chapter_key = '1-1.2' AND lesson.legacy_lesson_id = 'JOKE')
    OR (chapter.chapter_key = '1-2.2' AND lesson.legacy_lesson_id = 'A3XA4')
  );

WITH chapter_ref AS (
  SELECT id FROM public.chapters WHERE chapter_key = '1-2.2'
), lesson_seed (legacy_lesson_id, full_id, lesson_type, title, content_type, simulator_config, content_text, order_index) AS (
  VALUES
    ('A','1-2.2 A','敘述','質量和重量的單位怎麼表示？','text',NULL::jsonb,'',1),
    ('A1','1-2.2 A1','體感','4度C的1ml水 放在電子秤上','simulation',jsonb_build_object('id','LESSON_122_A1'),'公克 = g',2),
    ('A2','1-2.2 A2','體感','將1L的水 放在電子秤上','simulation',jsonb_build_object('id','LESSON_122_A2'),'1kg = 10³g',3),
    ('A3','1-2.2 A3','邏輯','以10³尺度繼續往上推','simulation',jsonb_build_object('id','LESSON_122_A3'),'1t = 10³kg',4),
    ('A4','1-2.2 A4','體感','比公克還小的是什麼？','simulation',jsonb_build_object('id','LESSON_122_A4'),'1mg = 10⁻³g',5),
    ('B','1-2.2 B','敘述','質量和重量是同一件事嗎？','text',NULL::jsonb,'',7),
    ('B1','1-2.2 B1','體感','觀察符號的規律，差在哪裡？','simulation',jsonb_build_object('id','LESSON_122_B1'),'質量單位加「重」= 重量單位 kg → kgw',8)
)
INSERT INTO public.lessons (
  chapter_id,
  title,
  content_type,
  content_url,
  simulator_config,
  legacy_lesson_id,
  full_id,
  lesson_type,
  sim_content,
  content_text,
  order_index,
  is_active
)
SELECT
  chapter_ref.id,
  lesson.title,
  lesson.content_type,
  '/1-2.2',
  lesson.simulator_config,
  lesson.legacy_lesson_id,
  lesson.full_id,
  lesson.lesson_type,
  NULL,
  lesson.content_text,
  lesson.order_index,
  TRUE
FROM lesson_seed lesson
CROSS JOIN chapter_ref
ON CONFLICT (chapter_id, legacy_lesson_id) WHERE legacy_lesson_id IS NOT NULL DO UPDATE
SET title = EXCLUDED.title,
    content_type = EXCLUDED.content_type,
    content_url = EXCLUDED.content_url,
    simulator_config = EXCLUDED.simulator_config,
    full_id = EXCLUDED.full_id,
    lesson_type = EXCLUDED.lesson_type,
    sim_content = EXCLUDED.sim_content,
    content_text = EXCLUDED.content_text,
    order_index = EXCLUDED.order_index,
    is_active = EXCLUDED.is_active;
