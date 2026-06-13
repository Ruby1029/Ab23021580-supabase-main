-- Restore real simulator ids/configs after moving course data from frontend files to Supabase.

UPDATE public.lessons lesson
SET simulator_config = data.config::jsonb,
    sim_content = data.sim_content,
    content_text = data.content_text,
    title = data.title,
    lesson_type = data.lesson_type
FROM public.chapters chapter
JOIN (
  VALUES
    ('1-1.2','A','要如何表達測量結果最完整呢？','敘述',
      jsonb_build_object('id','STATIC_IMAGE'),
      E'\\begin{array}{c}\n\\large\\textbf{測量結果} \\\\[8pt]\n\\text{準確值} + \\text{估計值} + \\text{單位}\n\\end{array}',
      '測量結果 = 準確值 + 估計值 + 單位'),
    ('1-1.2','A1','觀察相鄰兩刻度的間距，比大小 — 點擊三把直尺，哪一把的最小刻度最小？','體感',
      jsonb_build_object(
        'id','MULTI_RULER_CLICK',
        'rulers',jsonb_build_array(
          jsonb_build_object('label','直尺 A','minUnit','1 cm','mmPerDiv',10,'majorInt',10,'unit','cm','hsStart',100),
          jsonb_build_object('label','直尺 B','minUnit','1 mm','mmPerDiv',1,'majorInt',10,'unit','cm','hsStart',100),
          jsonb_build_object('label','直尺 C','minUnit','1 inch','mmPerDiv',25.4,'majorInt',25.4,'unit','inch','hsStart',101.6)
        ),
        'quiz',jsonb_build_object('prefix','','answer','最小單位','suffix',' = 相鄰兩刻度的間距')
      ),
      NULL,
      '最小單位 = 相鄰兩刻度的間距'),
    ('1-1.2','A2','鉛筆至少大於哪個刻度？','邏輯',
      jsonb_build_object(
        'id','PENCIL_RULER',
        'units',jsonb_build_array('110mm','11cm','0.11m'),
        'pencilMm',117,
        'tickIntervalMm',10,
        'majorTickIntervalMm',10,
        'question','鉛筆至少超過哪個刻度？',
        'answer','11',
        'quiz',jsonb_build_object('prefix','','answer','準確值','suffix',' = 利用最小單位表示的準確數值')
      ),
      NULL,
      '準確值 = 利用最小單位表示的準確數值'),
    ('1-1.2','A3','鉛筆不能完全寫成 11cm，觀察長度後，你認為估計填寫多少合適？','邏輯',
      jsonb_build_object(
        'id','PENCIL_RULER',
        'units',jsonb_build_array('117mm','11.7cm','0.117m'),
        'pencilMm',117,
        'tickIntervalMm',10,
        'majorTickIntervalMm',10,
        'question','填寫估計值（單位 cm）',
        'answer','11.7',
        'quiz',jsonb_build_object('prefix','','answer','估計值','suffix',' = 憑肉眼估計的數值，比最小單位小一位數')
      ),
      NULL,
      '估計值 = 憑肉眼估計的數值，比最小單位小一位數'),
    ('1-1.2','A4','觀察測量結果包含什麼呢？將文字標籤拖曳到對應的區域','體感',
      jsonb_build_object(
        'id','MATCH_DIAGRAM',
        'zones',jsonb_build_array('單位','估計值（最後一位）','準確值'),
        'tags',jsonb_build_array('cm','7','11.'),
        'answers',jsonb_build_object('單位','cm','估計值（最後一位）','7','準確值','11.'),
        'quiz',jsonb_build_object('prefix','測量結果 = ','answer','準確值','suffix',' + 一位數的估計值 + 單位')
      ),
      NULL,
      '測量結果 = 準確值 + 一位數的估計值 + 單位'),
    ('1-1.2','B','當每個人測量的估計值略為不同時，該怎麼辦呢？','敘述',
      jsonb_build_object('id','QUIZ_UNIT'),
      E'\\begin{array}{c}\n\\large\\textbf{多筆測量結果的處理} \\\\[8pt]\n\\text{→ 計算「平均值」}\n\\end{array}',
      '多筆測量結果需計算平均值'),
    ('1-1.2','B1','拿出 n 次測量結果，加在一起再除以 n','體感',
      jsonb_build_object(
        'id','AVERAGE_SIMULATOR',
        'records',jsonb_build_array(11.3,11.4,11.2,11.3,11.5),
        'includeOutlier',false,
        'quiz',jsonb_build_object('prefix','','answer','平均值','suffix',' = 測量結果加總 / 加總次數')
      ),
      NULL,
      '平均值 = 測量結果加總 / 加總次數'),
    ('1-1.2','B2','添加一筆錯誤數值後，平均值和所有人差異很大 — 找出並移除它','邏輯',
      jsonb_build_object(
        'id','AVERAGE_SIMULATOR',
        'records',jsonb_build_array(11.3,11.4,11.2,11.3,11.5),
        'includeOutlier',true,
        'outlierValue',15.0,
        'quiz',jsonb_build_object('prefix','準確值有誤的測量資料，必須','answer','移除','suffix','')
      ),
      NULL,
      '準確值有誤的測量資料，必須移除'),

    ('1-1.3','A','烏鴉口渴了，該怎麼喝水呢？','敘述',
      jsonb_build_object('id','IMAGE_CROW_WATER'),
      E'\\begin{array}{c}\n\\large\\textbf{體積的觀察} \\\\[8pt]\n\\text{物體佔有空間的大小，稱為「體積」}\n\\end{array}',
      '物體佔有空間的大小稱為體積'),
    ('1-1.3','A1','觀察投下石頭後，水面的變化？','體感',
      jsonb_build_object('id','CROW_STONE_SIMULATOR','quiz',jsonb_build_object('prefix','投石後水面上升，是因為石頭','answer','佔有空間','suffix','')),
      NULL,
      '石頭把水排開，水面上升'),
    ('1-1.3','B','容器內可裝物體體積的大小，稱為「容積」。','敘述',
      jsonb_build_object('id','QUIZ_UNIT'),
      E'\\begin{array}{c}\n\\large\\textbf{體積單位與容積單位} \\\\[8pt]\n1\\text{ cm}^3 = 1\\text{ ml} = 1\\text{ c.c.}\n\\end{array}',
      '1 cm³ = 1 ml = 1 c.c.'),
    ('1-1.3','B1','點擊滴管，20 滴水能裝滿多少空間？','體感',
      jsonb_build_object('id','WATER_DROP_SIMULATOR','quiz',jsonb_build_object('prefix','1 cm³ = 1 毫升(ml) = ','answer','1','suffix',' c.c.')),
      NULL,
      '1 cm³ = 1 毫升(ml) = 1 c.c.'),
    ('1-1.3','B2','1 公升的水等於幾個 1 cm³ 的小方盒？點擊大方盒觀察','體感',
      jsonb_build_object('id','LITER_BOX_SIMULATOR','quiz',jsonb_build_object('prefix','1 公升 = ','answer','1000','suffix',' 毫升')),
      NULL,
      '1 dm³ = 1 L = 1000 ml = 1000 cm³'),
    ('1-1.3','B3','水費計算單位「一度水」= 1公秉。點擊觀察 1000 瓶','體感',
      jsonb_build_object('id','KILO_LITER_SIMULATOR','quiz',jsonb_build_object('prefix','1 公秉 = ','answer','1000','suffix',' 公升')),
      NULL,
      '1 m³ = 1 kL = 1000 L'),
    ('1-1.3','C','實驗室中通常以量筒，測量液體的體積','敘述',
      jsonb_build_object('id','GRAD_CYLINDER_SIMULATOR'),
      NULL,
      '量筒讀取時視線需平齊液面最低處'),
    ('1-1.3','C1','點選正確的觀測角度來讀取量筒','邏輯',
      jsonb_build_object('id','EYE_LEVEL_SIMULATOR','quiz',jsonb_build_object('prefix','讀取量筒應採用','answer','平視法','suffix','')),
      NULL,
      '採用平視法讀取量筒'),

    ('1-2.1','A','1-2.1A 質量和重量','敘述',
      jsonb_build_object('id','IMAGE_MASS_WEIGHT'),
      NULL,
      ''),
    ('1-2.1','A1','積木組裝小恐龍','體感',
      jsonb_build_object('id','DINO_ASSEMBLE_SIMULATOR','quiz',jsonb_build_array(jsonb_build_object('prefix','','answer','物體','suffix','=占有一定空間的實體(e.g.小恐龍)'),jsonb_build_object('prefix','','answer','物質','suffix','=組成物體的本質(e.g.積木)'))),
      NULL,
      E'物體=占有一定空間的實體(e.g.小恐龍)\n物質=組成物體的本質(e.g.積木)'),
    ('1-2.1','A2','不同環境下，小恐龍固定由30個樂高積木組成','體感',
      jsonb_build_object('id','DINO_MASS_SIMULATOR','quiz',jsonb_build_object('prefix','','answer','質量','suffix',' = 物體內，物質的總量<br/>⇒不隨地點改變')),
      NULL,
      E'質量 = 物體內，物質的總量\n⇒不隨地點改變'),
    ('1-2.1','A3','觀察小恐龍的在電子秤上的讀數','體感',
      jsonb_build_object('id','DINO_WEIGHT_SIMULATOR','quiz',jsonb_build_array(jsonb_build_object('prefix','','answer','重量','suffix',' = 質量受星球引力影響的結果<br/>⇒會隨地點改變。<br/>⇒屬於”力”的一種 [八下第六章][九上第二章]'))),
      NULL,
      E'重量 = 質量受星球引力影響的結果\n⇒會隨地點改變。\n屬於”力”的一種[八下第六章][九上第二章]'),
    ('1-2.1','A4','質量和重量的根本差異','體感',
      jsonb_build_object(
        'id','DINO_SCALAR_VECTOR_SIMULATOR',
        'quiz',jsonb_build_array(
          jsonb_build_object('prefix','','answer','純量','suffix','=純粹的物理量|表示方式：數值＋單位|e.g.   300克'),
          jsonb_build_object('prefix','','answer','向量','suffix','=方向+純量|表示方式：方向+數值＋單位|e.g. 向下 300 克重')
        ),
        'quizLayout','table'
      ),
      NULL,
      '<table class="w-full text-left mt-2 border-collapse border-y border-gray-300 text-lg"><tbody><tr class="border-b border-gray-200"><td class="py-2 pr-4 font-bold whitespace-nowrap">純量</td><td class="py-2 pr-4 text-gray-700">純粹的物理量</td><td class="py-2 pr-4 text-gray-600">數值＋單位</td><td class="py-2 text-gray-500">e.g. 300克</td></tr><tr><td class="py-2 pr-4 font-bold whitespace-nowrap">向量</td><td class="py-2 pr-4 text-gray-700">方向+純量</td><td class="py-2 pr-4 text-gray-600">方向+數值＋單位</td><td class="py-2 text-gray-500">e.g. 向下 300 克重</td></tr></tbody></table>')
) AS data(chapter_key, legacy_lesson_id, title, lesson_type, config, sim_content, content_text)
  ON data.chapter_key = chapter.chapter_key
WHERE lesson.chapter_id = chapter.id
  AND lesson.legacy_lesson_id = data.legacy_lesson_id;
