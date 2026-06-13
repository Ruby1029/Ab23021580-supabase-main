-- Import Gemini single-choice Quiz Materials into quizzes/questions.
-- Source: Notion / Quiz Materials / 單選題(對應核心概念出題) / gemini OK.
-- Safe to re-run; it replaces the old exam quizzes and Gemini quiz titles below.

BEGIN;

DELETE FROM public.quizzes
WHERE title IN (
  '1-1 單元測驗',
  '台中市五權國中_111年八上01段考_自然 - 1-1.3',
  '台中市五權國中_111年八上01段考_自然 - 1-1.2',
  '台中市居仁國中_111年八上01段考_自然 - 1-1.2',
  '台北市弘道國中_111年八上01段考_自然 - 1-1',
  '台北市弘道國中_111年八上01段考_自然 - 1-1.2',
  '台北市弘道國中_111年八上01段考_自然 - 1-1.3',
  '台北市弘道國中_111年八上01段考_理化 - 1-1.3',
  '台北市弘道國中_111年八上01段考_理化 - 1-1.2',
  '台北市東湖國中_111年八上01段考_自然 - 1-1.2',
  'Gemini 單選題(核心概念) - 1-1.1',
  'Gemini 單選題(核心概念) - 1-1.2',
  'Gemini 單選題(核心概念) - 1-1.3'
);

-- Gemini 單選題(核心概念) - 1-1.1
WITH quiz_ref AS (
  INSERT INTO public.quizzes (chapter_id, title, time_limit, passing_score, is_active)
  SELECT id, 'Gemini 單選題(核心概念) - 1-1.1', NULL, 60, TRUE
  FROM public.chapters
  WHERE chapter_key = '1-1'
  RETURNING id
)
INSERT INTO public.questions (quiz_id, question_text, question_image_url, question_type, options, correct_answer, explanation, explanation_image_url, score, order_index)
SELECT quiz_ref.id, '小熊準備代表學校參加全國大專院校的創新創業競賽，在填寫專案展示海報的規格時，主辦單位要求海報的寬度必須剛好是 60 公分。小熊打算用英文寫一封電子郵件向國外廠商訂製這款海報，她需要將規格中的單位轉換為國際通用的英文縮寫。請問在科學與國際通用的標準單位中，60 公分 應該如何正確表示？', NULL, 'single_choice', '[{"key":"A","text":"60 m","image_url":null},{"key":"B","text":"60 mm","image_url":null},{"key":"C","text":"60 cm","image_url":null},{"key":"D","text":"60 km","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.1 A1
核心概念：長度單位的國際標準縮寫對應，1 公分 = 1 cm。
(A) 錯誤：m 代表公尺（Meter），60 m 是 60 公尺，長度嚴重誇大。
(B) 錯誤：mm 代表毫米（Millimeter），60 mm 只有 6 公分。
(C) 正確：公分的國際通用英文縮寫為 cm（Centimeter），因此 60 公分寫成 60 cm 完全正確。
(D) 錯誤：km 代表公里（Kilometer），60 km 是 60 公里。', NULL, 1, 1 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '小明在進行「校園生態地圖」的自主學習課題，他用相機記錄了燕尾蝶、獨角仙和非基改大豆的生長長度。在整理數據時，他發現手邊有四筆不同來源的筆記，但有些單位的英文字母大小寫或縮寫寫錯了。請幫小明找出哪一個選項的長度標示，在科學文獻的單位規範中是「完全正確且合法」的？', NULL, 'single_choice', '[{"key":"A","text":"昆蟲觸角長度為 2.5 CM","image_url":null},{"key":"B","text":"葉片寬度記錄為 8.0 cM","image_url":null},{"key":"C","text":"幼蟲身體長度為 4.2 cm","image_url":null},{"key":"D","text":"蛹的長度記錄為 3.1 c.m.","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.1 A1
核心概念：國際標準單位（SI 制）的縮寫具有嚴格的大小寫規範，公分必須固定為全小寫的「cm」，且中間與末尾不可加點。
(A) 錯誤：CM 全大寫不符合國際標準單位制的規範。
(B) 錯誤：cM 的 M 大寫是錯誤的。
(C) 正確：國際標準單位中，公分（Centimeter）的專屬縮寫就是全小寫的 cm，此格式完全正確。
(D) 錯誤：縮寫符號不需要也不應該加上縮寫點。', NULL, 1, 2 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '跨國成衣品牌委託物流公司運送一批由台灣設計師設計的機能運動外套，這批外套的包裝箱側面印著標示：「包裹厚度限制為 35.4 cm」。然而，當這批貨物抵達歐洲自動化海關倉儲系統時，系統的條碼機只能讀取符合標準 ISO 國際公制規格且單位標示精確的「公分」符號。由於印刷受潮導致部分字體模糊，系統發出警報並顯示四個可能的解讀數據。請依據科學計量學規範，選出最不可能引起系統警報的正確公分格式。', NULL, 'single_choice', '[{"key":"A","text":"35.4 centimeters","image_url":null},{"key":"B","text":"35.4 cm","image_url":null},{"key":"C","text":"35.4 公分(cm)","image_url":null},{"key":"D","text":"以上三種格式在國際科學計算機自動化讀取時都完全等價且合法","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.1 A1
核心概念：在資訊系統與精密科學計算中，標準長度符號具有唯一性與簡潔性。
(A) 錯誤：英文全拼雖然意思正確，但不屬於標準單位符號。
(B) 正確：數字搭配標準小寫「cm」是最合法且無歧義的格式。
(C) 錯誤：中英文混雜屬於冗餘字串。
(D) 錯誤：三者並不等價。', NULL, 1, 3 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '爺爺在客廳看電視時，覺得畫面太小，想買一台全新的大電視。他在購物網站上看到規格寫著「電視螢幕對角線長度為 5 公寸」。爺爺對「公寸」這個單位沒概念，於是詢問正在讀大學的小明。請問小明應該告訴爺爺，5 公寸 等於多少公分？', NULL, 'single_choice', '[{"key":"A","text":"0.5 公分","image_url":null},{"key":"B","text":"5 公分","image_url":null},{"key":"C","text":"50 公分","image_url":null},{"key":"D","text":"500 公分","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.1 A2
核心概念：長度單位的基礎換算，已知 1 公寸 = 10 公分。
(A) 錯誤：方向錯誤。
(B) 錯誤：沒有換算。
(C) 正確：5 × 10 = 50 公分。
(D) 錯誤：誤乘以 100。', NULL, 1, 4 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '阿基師打算在廚房安裝一個新的不鏽鋼收納層架，用來擺放各式辛香料。他用傳統的台尺測量，並將尺寸轉換成現代公制單位上傳給訂製廠商。他寫著：「層架總長度為 12.5 公寸」。廠商回覆：「阿基師您好，我們的機器裁切設定只接受以『公分（cm）』為單位的整數或小數數據。」請問阿基師應該將訂單上的長度修改為多少公分？', NULL, 'single_choice', '[{"key":"A","text":"1.25 公分","image_url":null},{"key":"B","text":"125 公分","image_url":null},{"key":"C","text":"1250 公分","image_url":null},{"key":"D","text":"0.125 公分","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.1 A2
核心概念：利用 1 公寸 = 10 公分 進行小數換算。
(A) 錯誤：方向錯誤。
(B) 正確：12.5 × 10 = 125 公分。
(C) 錯誤：多乘了一個 10。
(D) 錯誤：除以了 100。', NULL, 1, 5 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '小雲正在幫一家文創家居公司規劃一套「空間動線模擬系統」。系統資料庫內存儲了五種不同室內美學（現代簡約、侘寂、輕奢、中式禪風、文藝風）的家具尺寸。某一款中式禪風玄關櫃的長度在舊系統中被記錄為 L = 18 公寸。現在小雲需要寫一段 SQL 程式碼，將所有家具長度統一換算成「公分（cm）」以利前端渲染。若新系統要求數據必須符合「1.8 × 10ⁿ cm」的科學記號格式，請問其中 n 的值應該是多少？', NULL, 'single_choice', '[{"key":"A","text":"n = 1","image_url":null},{"key":"B","text":"n = 2","image_url":null},{"key":"C","text":"n = 3","image_url":null},{"key":"D","text":"n = -1","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.1 A2
核心概念：先換算成公分，再轉換為科學記號。
(A) 錯誤：18 cm 不符合題意。
(B) 正確：18 公寸 = 180 公分，而 180 = 1.8 × 10²，因此 n = 2。
(C) 錯誤：變成 1800 cm。
(D) 錯誤：方向相反。', NULL, 1, 6 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '學校舉辦校慶運動會，體育老師用石灰粉在操場上畫了一條直線跑道，準備進行 100 公尺短跑決賽。小剛在理化課學到「公尺」和「公分」都是長度單位，他很好奇如果把這條 100 公尺 的跑道全部用公分來表示，應該會是多少公分？', NULL, 'single_choice', '[{"key":"A","text":"100 公分","image_url":null},{"key":"B","text":"1000 公分","image_url":null},{"key":"C","text":"10000 公分","image_url":null},{"key":"D","text":"100000 公分","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.1 A3
核心概念：1 公尺 = 100 公分。
(A) 錯誤：未換算。
(B) 錯誤：少一個零。
(C) 正確：100 × 100 = 10000 公分。
(D) 錯誤：多一個零。', NULL, 1, 7 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '曉明趁著週末早晨到附近的森林公園進行「空腹走路 30 分鐘」的健康微習慣。他開啟手機上的 GPS 健走 App，走完後畫面顯示他今天總共繞著生態池走了「0.15 公尺」？曉明揉揉眼睛，懷疑是 App 系統的工程師把單位寫錯了，因為這個數字換算成公分後小得可憐，根本不符合他繞生態池走一圈的實際長度。請問 0.15 公尺 實際上「只等於」多少公分？', NULL, 'single_choice', '[{"key":"A","text":"1.5 公分","image_url":null},{"key":"B","text":"15 公分","image_url":null},{"key":"C","text":"150 公分","image_url":null},{"key":"D","text":"0.0015 公分","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.1 A3
核心概念：小數形式的公尺換算成公分。
(A) 錯誤：只乘以 10。
(B) 正確：0.15 × 100 = 15 公分。
(C) 錯誤：多乘了一個 10。
(D) 錯誤：方向反了。', NULL, 1, 8 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '國立科學工藝博物館正在規劃一個「微縮世界特殊材料展」。工程師利用 3D 列印技術製作了一個極其精密的展示台，其設計圖紙上的長度標示為 3/250 公尺。為了配合現場裝潢師傅使用的傳統公分皮尺，工程師必須將這個分數長度轉換為「小數形式的公分（cm）」。請問轉換後的正確結果應該是多少公分？', NULL, 'single_choice', '[{"key":"A","text":"0.012 公分","image_url":null},{"key":"B","text":"0.12 公分","image_url":null},{"key":"C","text":"1.2 公分","image_url":null},{"key":"D","text":"12 公分","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.1 A3
核心概念：分數單位換算需先換算再轉成小數。
(A) 錯誤：尚未轉換成公分。
(B) 錯誤：小數點位置錯誤。
(C) 正確：3/250 × 100 = 300/250 = 1.2 公分。
(D) 錯誤：放大十倍。', NULL, 1, 9 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '木工實作課上，老師發給每個人一片厚度為 3 公分 的樟木板用來雕刻杯墊。小強用游標卡尺測量時，發現卡尺上的主要刻度單位是「毫米（mm）」。小強想知道，這片 3 公分 厚的木板，如果用毫米來表示，應該是多少毫米？', NULL, 'single_choice', '[{"key":"A","text":"0.3 毫米","image_url":null},{"key":"B","text":"3 毫米","image_url":null},{"key":"C","text":"30 毫米","image_url":null},{"key":"D","text":"300 毫米","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.1 A4
核心概念：1 公分 = 10 毫米。
(A) 錯誤：方向錯誤。
(B) 錯誤：未換算。
(C) 正確：3 × 10 = 30 毫米。
(D) 錯誤：多乘一個 10。', NULL, 1, 10 FROM quiz_ref;

-- Gemini 單選題(核心概念) - 1-1.2
WITH quiz_ref AS (
  INSERT INTO public.quizzes (chapter_id, title, time_limit, passing_score, is_active)
  SELECT id, 'Gemini 單選題(核心概念) - 1-1.2', NULL, 60, TRUE
  FROM public.chapters
  WHERE chapter_key = '1-1.2'
  RETURNING id
)
INSERT INTO public.questions (quiz_id, question_text, question_image_url, question_type, options, correct_answer, explanation, explanation_image_url, score, order_index)
SELECT quiz_ref.id, '曉明在文具店挑選皮尺，準備用來測量自己畢業專案展示架的長度。他發現店裡有兩種皮尺：甲皮尺每公分之間劃有 10 個小格；乙皮尺每公分之間只劃了 2 個小格。請問這兩條皮尺的「最小單位」分別是多少？', NULL, 'single_choice', '[{"key":"A","text":"甲：1 cm，乙：0.5 cm","image_url":null},{"key":"B","text":"甲：0.1 cm，乙：0.5 cm","image_url":null},{"key":"C","text":"甲：1 mm，乙：2 cm","image_url":null},{"key":"D","text":"甲：0.1 mm，乙：5 mm","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.2 A1
核心概念：最小單位＝直尺上相鄰兩刻度之間的實質間距。甲皮尺將 1 cm 等分成 10 小格，每格為 0.1 cm；乙皮尺將 1 cm 等分成 2 小格，每格為 0.5 cm。', NULL, 1, 1 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '婷婷在木工觀光工廠體驗製作手工木盒，老師傅給了她一把特製的鋼直尺。這把鋼尺上的數字標示是以「英吋（inch）」為單位，而在數字 2 與數字 3 之間，總共細分成了 8 個相鄰的小水平刻度線。已知 1 英吋等同於 2.54 公分。請問這把鋼直尺的「最小單位」在物理上相當於多少公分？', NULL, 'single_choice', '[{"key":"A","text":"0.125 公分","image_url":null},{"key":"B","text":"0.254 公分","image_url":null},{"key":"C","text":"0.3175 公分","image_url":null},{"key":"D","text":"2.54 公分","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.2 A1
核心概念：先找出測量工具上的刻度間距比例，再透過單位換算求出實際物理長度。1 英吋分成 8 格，每格為 1/8 英吋；2.54 × 1/8 = 0.3175 公分。', NULL, 1, 2 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '阿法正在編寫一個自動化晶圓影像量測系統的演算法。相機畫素的物理間距為固定值。系統讀取一把數位微米尺的規格說明書，內文寫著：「本雷射光柵尺在 1 毫米（mm）的物理長度內，精準刻製了 500 條光柵刻度線（相鄰兩線等距）。」請問這個智慧量測系統在進行邊緣偵測時，所依據的該工具「最小單位」應該設定為多少微米（μm，其中 1 mm = 1000 μm）？', NULL, 'single_choice', '[{"key":"A","text":"0.5 μm","image_url":null},{"key":"B","text":"2 μm","image_url":null},{"key":"C","text":"5 μm","image_url":null},{"key":"D","text":"500 μm","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.2 A1
核心概念：最小單位是單一區間的長度。在總長度內均分刻度，每格長度＝總長度 ÷ 總格數。1 mm ÷ 500 = 0.002 mm = 2 μm。', NULL, 1, 3 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '物理實驗課上，小強使用一把最小單位為「毫米（mm）」的鐵尺來測量一片矩形金屬片的長度。金屬片的邊緣剛好非常精準地停留在直尺上「5.8 公分」的刻度線上，完全沒有超過。請問小強在寫下這筆「準確值」數據時，哪一個數值才最符合科學上準確值的定義？', NULL, 'single_choice', '[{"key":"A","text":"5 公分","image_url":null},{"key":"B","text":"5.8 公分","image_url":null},{"key":"C","text":"5.80 公分","image_url":null},{"key":"D","text":"5.800 公分","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.2 A2
核心概念：準確值是利用工具的最小單位能直接讀取出的精確數值，不包含最後一位的肉眼估計。最小單位 1 mm = 0.1 cm，因此可準確讀到 5.8 cm。', NULL, 1, 4 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '阿亮買了一支新型的數位電子料理溫度計來煮舒肥牛排。說明書上寫著：「本產品之最小顯示刻度間距為 0.5°C。」阿亮將溫度計插入水中，螢幕最後穩定顯示出 62.5°C。請從測量值的原理來分析，這個數據中的「準確值」部分應該是多少？', NULL, 'single_choice', '[{"key":"A","text":"62°C","image_url":null},{"key":"B","text":"62.5°C","image_url":null},{"key":"C","text":"60°C","image_url":null},{"key":"D","text":"電子儀器是自動跳數字的，因此不含有準確值","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.2 A2
核心概念：準確值由測量工具的最小單位決定。若量測讀數剛好是最小單位的整數倍，則該讀數本身全為準確值。', NULL, 1, 5 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '某精密地質觀測站裝設了一台用來監測斷層微小移動的「光纖應變計」。該儀器的最小刻度單位設定為「0.02 毫米（mm）」。在一次地震後，應變計的指針指在兩個相鄰刻度線「4.14 mm」與「4.16 mm」的正中央。研究員在報告中寫下測量值為 4.150 mm。請問在這個最終的測量數據中，真正的「準確值」應該如何解構與表示？', NULL, 'single_choice', '[{"key":"A","text":"4 mm","image_url":null},{"key":"B","text":"4.1 mm","image_url":null},{"key":"C","text":"4.14 mm","image_url":null},{"key":"D","text":"4.15 mm","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.2 A2
核心概念：當物體位於兩刻度之間，準確值只能寫到物體所超過的前一個刻度線所代表的數值。指針落在 4.14 與 4.16 之間，可確定超過 4.14 mm。', NULL, 1, 6 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '媽媽用軟皮尺幫小明量腰圍。皮尺上的最小單位是「公分（cm）」。小明湊過去看，發現皮尺的線條越過了 65 公分，但還沒到 66 公分，大約落在中間偏右一點點的地方。媽媽說：「我們必須加上一位估計值。」請問下列哪一個腰圍數據的記錄方式，最符合「估計值」的規範？', NULL, 'single_choice', '[{"key":"A","text":"65 公分，因為不用估計","image_url":null},{"key":"B","text":"65.7 公分，其中的「0.7」是估計值","image_url":null},{"key":"C","text":"65.75 公分，其中的「0.05」是估計值","image_url":null},{"key":"D","text":"60 公分，其中的「0」是估計值","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.2 A3
核心概念：估計值必須且只能有一位，位於最小單位的下一位。最小單位是公分，因此估計值應寫在小數點後第一位。', NULL, 1, 7 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '小華在理化實驗室拿了一把刻度模糊的直尺測量鉛筆長度。他隱約看出直尺的最小單位是「分米（dm，即 10 公分）」。測量時，筆尖大約落在 1 分米到 2 分米之間。小華記錄鉛筆長度為 1.45 分米。請幫小華分析，他寫下的這三個數字「1」、「4」、「5」，哪一個才是真正的「估計值」？', NULL, 'single_choice', '[{"key":"A","text":"「1」是估計值，因為最左邊最重要","image_url":null},{"key":"B","text":"「4」是估計值，因為它是最小單位的下一位","image_url":null},{"key":"C","text":"「5」是估計值，因為它是這串數字的最後一位","image_url":null},{"key":"D","text":"這個數據記錄格式本身就錯了，無法找出正確的估計值","image_url":null}]'::jsonb, 'D', '課程內容PK：1-1.2 A3
核心概念：估計值只能出現在最小單位的下一位。1.45 分米出現兩位小數，違反只能有一位估計值的規則，因此整筆資料格式錯誤。', NULL, 1, 8 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '在國家奈米元件實驗室中，科學家利用電子顯微鏡量測微影製程後的線寬。儀器輸出的原始波形圖顯示，目標線寬落在標線刻度「32.4 μm」與「32.5 μm」之間，且非常靠近 32.4 μm。科學家為了追求精準，在報告中寫下線寬為 32.413 μm。審查委員審閱後指出：「這不符合國中理化所學的測量基本原理。」請問審查委員的意思是，該數據的估計值違反了什麼原則？', NULL, 'single_choice', '[{"key":"A","text":"估計值不應該是數字 1，應該用 0 表示","image_url":null},{"key":"B","text":"最小單位是 0.1 μm，估計值只能寫到小數點後第二位，後面不應再有 3","image_url":null},{"key":"C","text":"微米單位太小，科學上規定微米以下的測量一律不准寫出估計值","image_url":null},{"key":"D","text":"靠近前一個刻度時，應直接捨去，不該寫出估計值","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.2 A3
核心概念：估計值只能有一位。最小單位為 0.1 μm，因此估計值只能到小數第二位；32.413 多寫了一位。', NULL, 1, 9 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '體育股長大同用捲尺幫大家量身高。量完後，他在黑板上草率地寫下了四位同學的身高紀錄。理化老師開玩笑說：「大同啊，你寫的數據有些在科學上根本是不完整的測量結果喔！」請問下列大同記錄的四個數據中，哪一個才是「最完整且正確」的測量結果？', NULL, 'single_choice', '[{"key":"A","text":"小明：165.4","image_url":null},{"key":"B","text":"小華：162 公分","image_url":null},{"key":"C","text":"小紅：158.3 cm","image_url":null},{"key":"D","text":"小剛：向北 170.1 cm","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.2 A4
核心概念：完整測量結果＝準確值＋一位估計值＋單位。小紅的 158.3 cm 包含數值、估計值與單位。', NULL, 1, 10 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '新北市萬里區的某間地政事務所收到一筆土地邊界測量申報，申請書上寫著某條界線的長度為「0.04520 公里（km）」。承辦員 Ruby 想要解構這個數據，以推算出當初測量人員所使用的專業測量捲尺，其「最小單位」究竟是多少？請問下列哪一個推論才是正確的？', NULL, 'single_choice', '[{"key":"A","text":"最小單位是 1 公里","image_url":null},{"key":"B","text":"最小單位是 1 公尺","image_url":null},{"key":"C","text":"最小單位是 1 分米（10 公分）","image_url":null},{"key":"D","text":"最小單位是 1 厘米（1 公分）","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.2 A4
核心概念：從測量結果逆推最小單位。測量值最後一位是估計值，倒數第二位所在位數為工具最小單位；0.04520 km 的倒數第二位對應 0.001 km = 1 m。', NULL, 1, 11 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '四位同學分別用不同的直尺來測量同一片長方形晶片的長度。每個人量出來並記錄的結果如下表。已知大家在讀取與估計時都沒有犯錯。請問關於這四把直尺的「精密度（最小單位）」對比，下列哪一個物理邏輯推論是完全正確的？・阿明：0.0350 m・阿強：35.0 mm・小紅：3.50 cm・小麗：0.350 dm', NULL, 'single_choice', '[{"key":"A","text":"阿明使用的直尺最精密，因為他的數據小數位數最多","image_url":null},{"key":"B","text":"阿強與小紅使用的直尺精密度完全相同","image_url":null},{"key":"C","text":"阿明、小紅、小麗三人所使用直尺的最小單位其實完全一樣","image_url":null},{"key":"D","text":"四個人所使用的直尺，其最小單位各不相同，無法比較","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.2 A4
核心概念：比較不同單位的精密度時，必須先統一換算至相同單位，再比較倒數第二位所在的位置。阿明、小紅、小麗換算後最小單位皆為 0.1 cm。', NULL, 1, 12 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '四位同學受委託測量同一張理化實驗桌的寬度，大家都使用同一把最小單位為「公分（cm）」的木直尺。每人各自獨立測量一次後，記錄下來的數據如下。理化老師說：「根據科學測量的潛規則，裡面有一筆資料的準確值明顯有誤，必須直接移除（剔除），不能記錄進來！」請問應該被移除的是哪一筆資料？', NULL, 'single_choice', '[{"key":"A","text":"小明：60.2 cm","image_url":null},{"key":"B","text":"小華：60.5 cm","image_url":null},{"key":"C","text":"小紅：63.4 cm","image_url":null},{"key":"D","text":"小麗：60.0 cm","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.2 B1
核心概念：同一工具測量同一物體時，準確值應高度一致。若差異過大，代表重大操作錯誤。63.4 cm 與其他約 60 cm 的數據差異過大，應剔除。', NULL, 1, 13 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '五位同學用同一把直尺測量理化課本的厚度，紀錄分別為：1.24 cm、1.22 cm、1.53 cm、1.25 cm、1.23 cm。小強說：「只要把這五個數據加起來除以 5，就能得到最接近課本真實厚度的平均值。」請問小強的想法對不對？如果進行修正，正確的平均值應該是多少？', NULL, 'single_choice', '[{"key":"A","text":"對，平均值是 1.29 cm","image_url":null},{"key":"B","text":"不對，應該先移除偏離過大的 1.53 cm，其餘四個數據平均後得到 1.24 cm","image_url":null},{"key":"C","text":"不對，五個數據都要保留，但要去掉最高和最低分，平均得到 1.24 cm","image_url":null},{"key":"D","text":"不對，應該先移除 1.53 cm，其餘四個數據平均後得到 1.235 cm，再四捨五入成 1.24 cm","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.2 B1
核心概念：計算平均值前，應先剔除明顯錯誤的異常值。1.53 cm 明顯偏離其他數據，應剔除；剩餘平均為 1.235 cm，修約後為 1.24 cm。', NULL, 1, 14 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '某工程團隊受託檢測高鐵高架橋墩的沉陷量。四位工程師使用同一台高精度雷射測距儀（最小單位為 0.1 mm）對同一觀測點進行量測。申報的數據整理如下表。專案總監審查時發現，這群數據在科學格式與除錯規則上有嚴重的問題。請問，在「移除錯誤與不合規範的資料」後，最終能上報的「正確平均沉陷量」應該記錄為多少毫米（mm）？・工程師 A：12.34 mm・工程師 B：12.3 mm・工程師 C：12.36 mm・工程師 D：15.35 mm', NULL, 'single_choice', '[{"key":"A","text":"13.10 mm","image_url":null},{"key":"B","text":"12.35 mm","image_url":null},{"key":"C","text":"12.34 mm","image_url":null},{"key":"D","text":"12.347 mm","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.2 B1
核心概念：需同時檢查格式是否合法與數據是否異常。B 格式錯誤，D 差異過大，移除；A 與 C 平均為 12.35 mm。', NULL, 1, 15 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '小華正在進行液體體積量測實驗。他將水倒入量筒中後，準備讀取刻度。老師走過來提醒他：「讀取量筒中水的刻度時，眼睛的視線一定要用『平視法』。」請問下列關於平視法的操作描述，何者完全正確？', NULL, 'single_choice', '[{"key":"A","text":"站在凳子上，從高處往下看水面刻度","image_url":null},{"key":"B","text":"蹲下身子，讓眼睛的視線和量筒內的水面保持水平同一高度","image_url":null},{"key":"C","text":"把量筒高高舉起，拿得比眼睛還要高，從下往上看","image_url":null},{"key":"D","text":"只要能看清量筒上的數字，從任何角度看都可以","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.2 B2
核心概念：平視法可消除視差。眼睛需與液面保持同高度。', NULL, 1, 16 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '小紅在量筒中倒入適量的水。讀取刻度時，因為懶得蹲下身子，她直接站在桌邊「由上往下（俯視）」看著量筒內的水面中心最低處，並記錄讀數為 V甲。隨後老師糾正了她，她改用標準的「平視法」重新讀取正確的刻度為 V乙。請問關於這兩個讀數的大小關係，下列何者正確？', NULL, 'single_choice', '[{"key":"A","text":"V甲 ＞ V乙","image_url":null},{"key":"B","text":"V甲 ＜ V乙","image_url":null},{"key":"C","text":"V甲 ＝ V乙","image_url":null},{"key":"D","text":"無法判斷，這取決於量筒是塑膠做的還是玻璃做的","image_url":null}]'::jsonb, 'A', '課程內容PK：1-1.2 B2
核心概念：俯視時讀數偏大。俯視時視線投影會落在真實液面上方，因此讀數偏大。', NULL, 1, 17 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '曉明在實驗室操作兩個不同的量筒。甲量筒裝水（水面因內聚力與附著力交互作用呈中央下凹的杯狀），乙量筒裝水銀（液面呈中央上凸的帽狀）。曉明在讀取這兩個量筒的刻度時，皆不小心犯了「仰視（由下往上看）」的錯誤，並將讀到的數值記錄下來。若兩液體的真實體積分別為 V水 與 V水銀。請問曉明記錄下來的讀數，與真實體積相比會如何？', NULL, 'single_choice', '[{"key":"A","text":"水的讀數比真實體積大；水銀的讀數比真實體積小","image_url":null},{"key":"B","text":"水的讀數比真實體積小；水銀的讀數比真實體積大","image_url":null},{"key":"C","text":"兩個量筒讀出來的數值，都會比真實體積還要小","image_url":null},{"key":"D","text":"兩個量筒讀出來的數值，都會比真實體積還要大","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.2 B2
核心概念：仰視時，無論液面凹凸，讀數都會偏小。', NULL, 1, 18 FROM quiz_ref;

-- Gemini 單選題(核心概念) - 1-1.3
WITH quiz_ref AS (
  INSERT INTO public.quizzes (chapter_id, title, time_limit, passing_score, is_active)
  SELECT id, 'Gemini 單選題(核心概念) - 1-1.3', NULL, 60, TRUE
  FROM public.chapters
  WHERE chapter_key = '1-1.3'
  RETURNING id
)
INSERT INTO public.questions (quiz_id, question_text, question_image_url, question_type, options, correct_answer, explanation, explanation_image_url, score, order_index)
SELECT quiz_ref.id, '小明在童話故事裡讀到「烏鴉喝水」的故事：一隻口渴的烏鴉發現一個細長瓶子裡有水，但水面太低牠喝不到。聰明的烏鴉開始把附近的小石頭一隻隻叼進瓶子裡，過了一陣子，水面真的上升到瓶口，烏鴉順利喝到了水。從理化實驗的角度來看，下列關於水面上升的原因，何者敘述最正確？', NULL, 'single_choice', '[{"key":"A","text":"石頭進入水中後融化了，讓水的總體積變多","image_url":null},{"key":"B","text":"石頭具有吸水性，吸水後把底部的水分往上擠","image_url":null},{"key":"C","text":"石頭占有空間，把原本水占有的空間排擠開，導致水面上升","image_url":null},{"key":"D","text":"石頭太重了，把瓶底往下壓，導致水面相對上升","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.3 A1
核心概念：物體占有空間（排水法原理）。當不溶於水的固體沉入水中，會排擠掉與自身體積相等的液體，使液面上升。', NULL, 1, 1 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '小華想測量一個造型奇特且不規則的青銅公仔體積。他先在量筒中裝入 50 mL 的水，當他把公仔完全浸沒入水中後，發現量筒的讀數上升到了 85 mL。如果小華將公仔撈起後，改將一塊完全不吸水、體積為 10 cm3 的黏土塞進公仔底部的中空凹槽內（不影響公仔外形），再重新放回裝有 50 mL 水的量筒中。請問此時量筒的讀數會變成多少？', NULL, 'single_choice', '[{"key":"A","text":"85 mL，因為公仔外形沒變，排開的水量與原本相同","image_url":null},{"key":"B","text":"95 mL，因為多加了黏土的體積，排開的水量會變大","image_url":null},{"key":"C","text":"60 mL，因為黏土會把公仔內部重力抵消","image_url":null},{"key":"D","text":"條件不足，無法判斷","image_url":null}]'::jsonb, 'A', '課程內容PK：1-1.3 A1
核心概念：排水法測量的是物體排開液體的外部總體積。若外形未變，則排開體積不變。公仔外部輪廓所占空間決定讀數，因此仍是 85 mL。', NULL, 1, 2 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '婷婷在實驗室進行一項精密測量。她準備了一個裝滿水（剛好齊平溢水口）的溢水杯，並在下方放置一個空燒杯捕捉溢出的水。她將一個乾燥、內部充滿微小氣孔的特殊多孔火山岩石（已知其不溶於水，但會緩慢吸水直到飽和）輕輕放入溢水杯中。岩石最後完全沉入水底。婷婷發現溢水杯中溢出的水體積為 40 mL，而將岩石撈出後，擦乾表面秤重，發現岩石總共吸收了 15 mL 的水。請問這塊火山岩石「純固體實體（不含氣孔）」的真正體積是多少？', NULL, 'single_choice', '[{"key":"A","text":"55 cm^3","image_url":null},{"key":"B","text":"40 cm^3","image_url":null},{"key":"C","text":"25 cm^3","image_url":null},{"key":"D","text":"15 cm^3","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.3 A1
核心概念：排水法中，溢出的水量＝物體外觀體積－吸入孔洞中的水量。岩石外觀體積＝40+15=55 mL；氣孔占 15 mL，真正固體體積＝55−15−15=25 cm3。', NULL, 1, 3 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '育才國中八年級的同學在舉辦下午茶派對。小華買了一瓶手搖飲，上面標示容量為 700 c.c.；小明買了一盒鮮乳，包裝上寫著容量為 290 mL；小紅在理化課本上看到某種正方體積木的體積是 1 cm3。理化老師開玩笑說：「其實這三種單位的稱呼，在體積與容積上是一家親喔！」請問下列關於這三個單位的換算關係，何者完全正確？', NULL, 'single_choice', '[{"key":"A","text":"1 c.c.=10 mL","image_url":null},{"key":"B","text":"1 cm3=1 mL=1 c.c.","image_url":null},{"key":"C","text":"1 mL=100 c.c.","image_url":null},{"key":"D","text":"1 c.c. 比 1 cm3 還要大很多","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.3 B1
核心概念：cm3、mL、c.c. 三者完全相等，比例為 1:1:1。', NULL, 1, 4 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '護理師志明在準備為病人注射藥物。醫生處方開立：「給予抗生素 0.05 公升」。志明看著手上的針筒，發現針筒上的刻度單位是以 c.c. 來標示。請問志明應該用針筒抽取多少 c.c. 的藥水，才符合醫生的處方規定？', NULL, 'single_choice', '[{"key":"A","text":"0.5 c.c.","image_url":null},{"key":"B","text":"5 c.c.","image_url":null},{"key":"C","text":"50 c.c.","image_url":null},{"key":"D","text":"500 c.c.","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.3 B1
核心概念：1 L=1000 mL=1000 c.c.。0.05×1000=50，因此應抽取 50 c.c.。', NULL, 1, 5 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '小智正在協助學校開發一套「實驗室庫存管理系統」。系統資料庫在儲存液體體積時，統一使用標準字串格式。某一筆歷史實驗數據記錄著：「消耗硫酸明礬溶液 4.5 dm3」。系統前端畫面為了讓國中生易讀，需要將其轉換為「c.c.」顯示。請問小智應該在後端寫入什麼樣的換算程式邏輯，才能在畫面上顯示正確的數值？', NULL, 'single_choice', '[{"key":"A","text":"將 dm3 的數值乘以 10 即可得到 c.c.","image_url":null},{"key":"B","text":"將 dm3 的數值乘以 100 即可得到 c.c.","image_url":null},{"key":"C","text":"將 dm3 的數值乘以 1000 即可得到 c.c.","image_url":null},{"key":"D","text":"dm3 就是 c.c.，數值完全不用變動","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.3 B1
核心概念：1 dm3=1000 c.c.。4.5 dm3=4500 c.c.。', NULL, 1, 6 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '媽媽去超市買了一瓶大包裝的柳橙汁，瓶身上標示著容量為 2 公升 (L)。小強剛好學到體積單位，他想知道這瓶柳橙汁如果換算成「毫升 (mL)」或「立方分米 (dm3)」，應該是多少？下列哪一組換算數據完全正確？', NULL, 'single_choice', '[{"key":"A","text":"2 公升=200 毫升=20 dm3","image_url":null},{"key":"B","text":"2 公升=2000 毫升=2 dm3","image_url":null},{"key":"C","text":"2 公升=20000 毫升=0.2 dm3","image_url":null},{"key":"D","text":"2 公升=2 毫升=2000 dm3","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.3 B2
核心概念：1 L=1000 mL=1 dm3，因此 2 L=2000 mL=2 dm3。', NULL, 1, 7 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '某牌氣泡水機的說明書上寫著：「為了達到最佳飽和度，建議每次製作氣泡水時，寶特瓶內的水量剛好裝到 0.8 dm3 的安全線。」小美家裡只有一個帶有「毫升 (mL）」刻度的烘焙量杯。請問小美應該用量杯量取多少毫升的水倒入寶特瓶，才最接近說明書的建議？', NULL, 'single_choice', '[{"key":"A","text":"8 毫升","image_url":null},{"key":"B","text":"80 毫升","image_url":null},{"key":"C","text":"800 毫升","image_url":null},{"key":"D","text":"8000 毫升","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.3 B2
核心概念：1 dm3=1000 mL。0.8×1000=800 mL。', NULL, 1, 8 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '家裡要訂製一個系統廚具的嵌入式烘碗機。空間規劃師說：「目前預留的安裝空間，其長、寬、高分別為 50 公分、40 公分、60 公分。」小明查閱某款烘碗機的規格，其內部容積標示為「115 公升」。如果不考慮機殼厚度，請問這個預留空間「能不能」放得下這台烘碗機？且預留空間相當於多少 dm3？', NULL, 'single_choice', '[{"key":"A","text":"放得下，因為空間體積為 120 dm3，大於烘碗機容積","image_url":null},{"key":"B","text":"放不下，因為空間體積只有 12 dm3，遠小於 115 公升","image_url":null},{"key":"C","text":"放得下，因為空間體積為 120000 dm3，遠大於 115 公升","image_url":null},{"key":"D","text":"放不下，因為公分與公升無法進行任何體積轉換","image_url":null}]'::jsonb, 'A', '課程內容PK：1-1.3 B2
核心概念：1 dm3=1 L。50 cm=5 dm、40 cm=4 dm、60 cm=6 dm，因此體積=5×4×6=120 dm3=120 L，大於 115 L。', NULL, 1, 9 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '2026年夏天南部水情吃緊，某市立游泳池為了配合節水措施，決定計算其兒童戲水池的蓄水量。管理員查閱工程圖，發現該戲水池裝滿水時的體積是 5 立方公尺 (m3)。請問這 5 立方公尺的水，換算成台灣自來水公司常用的計算單位「公秉 (kl)」，應該是多少公秉？', NULL, 'single_choice', '[{"key":"A","text":"0.005 公秉","image_url":null},{"key":"B","text":"5 公秉","image_url":null},{"key":"C","text":"500 公秉","image_url":null},{"key":"D","text":"5000 公秉","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.3 B3
核心概念：1 m3=1 kl，因此 5 m3=5 kl。', NULL, 1, 10 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '氣象局發布豪雨特報，某山區在 24 小時內降下了高達 400 毫米 (mm) 的雨量。科學家估算，這次降雨為該當地的水庫集水區帶來了約 2 公秉 (kl) 的進水量。小強想知道，如果要把這 2 公秉的水全部換算成科學實驗常用的「毫升 (mL）」來表示，應該如何寫出其正確的數量？', NULL, 'single_choice', '[{"key":"A","text":"2×10³ 毫升","image_url":null},{"key":"B","text":"2×10⁴ 毫升","image_url":null},{"key":"C","text":"2×10⁵ 毫升","image_url":null},{"key":"D","text":"2×10⁶ 毫升","image_url":null}]'::jsonb, 'D', '課程內容PK：1-1.3 B3
核心概念：1 kl=1,000,000 mL，所以 2 kl=2×10⁶ mL。', NULL, 1, 11 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '新北市板橋區某新建案正在規劃地下室的社區緊急消防蓄水池。法規規定該大樓的蓄水池容量至少必須達到 6,000,000 mL。建商在設計圖上畫出了一個長 3 公尺、寬 2 公尺、深 1.5 公尺的長方體地下水槽。請問這個水槽裝滿時的體積是多少立方公尺 (m3)？且是否符合消防法規的最低容量規定？', NULL, 'single_choice', '[{"key":"A","text":"體積為 9 m3，符合法規規定","image_url":null},{"key":"B","text":"體積為 9 m3，不符合法規規定","image_url":null},{"key":"C","text":"體積為 0.9 m3，不符合法規規定","image_url":null},{"key":"D","text":"體積為 90 m3，符合法規規定","image_url":null}]'::jsonb, 'A', '課程內容PK：1-1.3 B3
核心概念：長方體體積＝長×寬×高。3×2×1.5=9 m3=9,000,000 mL，大於 6,000,000 mL。', NULL, 1, 12 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '小明在理化課進行液體體積量測實驗。他將水倒入量筒中，準備讀取刻度。老師走過來提醒他：「讀取量筒中水的刻度時，眼睛的視線一定要用『平視法』。」請問下列關於平視法的操作描述，何者正確？', NULL, 'single_choice', '[{"key":"A","text":"站在凳子上，從高處往下看水面刻度","image_url":null},{"key":"B","text":"蹲下身子，讓眼睛的視線和量筒內的水面保持同一高度","image_url":null},{"key":"C","text":"把量筒拿起來，拿得比眼睛還要高，從下往上看","image_url":null},{"key":"D","text":"隨便找個舒服的角度看，只要看得到數字即可","image_url":null}]'::jsonb, 'B', '課程內容PK：1-1.3 C1
核心概念：平視法可避免視差。眼睛需與液面同高。', NULL, 1, 13 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '小紅在量筒中倒入適量的水，若她讀取刻度時，因為懶得蹲下，直接站在桌邊「由上往下（俯視）」看著量筒內的水面中心最低處，並記錄讀數為 V甲。隨後老師糾正她，她改用標準的「平視法」重新讀取正確的刻度為 V乙。請問關於這兩個讀數的大小關係，下列何者正確？', NULL, 'single_choice', '[{"key":"A","text":"V甲＞V乙","image_url":null},{"key":"B","text":"V甲＜V乙","image_url":null},{"key":"C","text":"V甲＝V乙","image_url":null},{"key":"D","text":"無法判斷，取決於量筒的材質","image_url":null}]'::jsonb, 'A', '課程內容PK：1-1.3 C1
核心概念：俯視讀數偏大。俯視時投影位置偏上，因此讀數偏大。', NULL, 1, 14 FROM quiz_ref
UNION ALL
SELECT quiz_ref.id, '曉明在實驗室操作兩個不同的量筒。甲量筒裝水（水面呈中央下凹的杯狀），乙量筒裝水銀（水銀面呈中央上凸的帽狀）。曉明在讀取刻度時，皆不小心犯了「仰視（由下往上看）」的錯誤，並將讀到的數值記錄下來。若兩液體的真實體積分別為 V水 與 V水銀。請問曉明記錄下來的讀數，與真實體積相比會如何？', NULL, 'single_choice', '[{"key":"A","text":"兩者都比真實體積大","image_url":null},{"key":"B","text":"水的讀數比真實體積小；水銀的讀數比真實體積大","image_url":null},{"key":"C","text":"兩者都比真實體積小","image_url":null},{"key":"D","text":"水的讀數比真實體積大；水銀的讀數比真實體積小","image_url":null}]'::jsonb, 'C', '課程內容PK：1-1.3 C1
核心概念：仰視時，讀數皆會偏小。無論水或水銀，仰視時視線投影都落在真實液面下方。', NULL, 1, 15 FROM quiz_ref;

COMMIT;
