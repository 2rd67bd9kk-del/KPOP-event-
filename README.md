# K-POP EVENT starter

## 公開（GitHub Pages）
1. GitHubで新しいPublicリポジトリを作成
2. `index.html` と `supabase.sql` をアップロード
3. Settings → Pages → Deploy from a branch → `main` / `/ (root)` → Save
4. 数分後に表示されたPages URLで確認

## 運営者投稿機能（Supabase）
GitHub Pagesは静的ホスティングのため、ログインと安全な投稿にはSupabaseを使います。

1. Supabaseでプロジェクトを作成
2. SQL Editorで `supabase.sql` の内容を実行
3. Authentication → Usersで管理者ユーザーを作成（公開サインアップは無効推奨）
4. 作成したユーザーのUUIDをSQL末尾の例に入れ、admin_usersへ登録
5. `index.html` の `configureSupabase()` を次のように設定するため、URLとanon keyを入れる:
   - `const SUPABASE_URL = 'https://YOUR_PROJECT.supabase.co';`
   - `const SUPABASE_ANON_KEY = 'YOUR_PUBLIC_ANON_KEY';`
   - `configureSupabase()` 内で localStorage の読み込みをやめ、`sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);`
6. GitHubへcommitするとPagesへ反映
7. アプリの設定 → 運営者ログインから投稿

**重要:** `service_role` keyや秘密鍵は絶対にHTMLへ書かないでください。ブラウザに置いてよいのはSupabaseの公開anon/publishable keyのみ。RLSが必須です。

## 現在の実装範囲
- スマホ向けホームと5タブ
- アーティスト追加・削除・お気に入り（端末内保存）
- 図鑑の名前検索、K-POP/J-POP絞り込み
- お知らせ画面、運営者ログイン画面
- Supabase接続後の公式発表/更新履歴の読み込み、投稿、削除、公開日時予約
- 未接続のニュース・イベント・ランキングは架空データを出さず、未接続と表示

## まだ必要な作業
- Supabaseの接続情報を設定し、実際の管理者アカウントを登録
- ニュース/イベント/チャートAPIのバックエンド連携
- YouTube Data API等のキーをサーバー側で保護して実装
- 実データの出典・取得日時・エラー表示
- 毎日18時の定期アップデート履歴はGitHub Actions等の自動処理を追加して初めて実際に実行できます。履歴を自動で捏造することはせず、実行成功時だけ記録してください。

このスターターは完成した全データプラットフォームではありません。実データ連携前の安全な土台です。
