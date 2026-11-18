-- Supabase SQL Editorで実行してください
create extension if not exists pgcrypto;
create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  type text not null check (type in ('official','update')),
  publish_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);
alter table public.announcements enable row level security;
-- 公開済みのお知らせは誰でも閲覧可能
create policy "public can read published announcements"
on public.announcements for select
using (publish_at <= now());
-- 投稿・削除はSupabase Authでログインした管理者のみ。
-- 初期設定では全認証ユーザーが書ける設定にしないこと。
-- 管理者ロールを安全に運用するため、以下のadmin_usersテーブルを利用。
create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.admin_users enable row level security;
create policy "admins can read own admin record"
on public.admin_users for select to authenticated
using (user_id = auth.uid());
create policy "admins can insert announcements"
on public.announcements for insert to authenticated
with check (exists(select 1 from public.admin_users where user_id=auth.uid()));
create policy "admins can delete announcements"
on public.announcements for delete to authenticated
using (exists(select 1 from public.admin_users where user_id=auth.uid()));
-- 管理者登録後、Supabase SQL Editorで次を実行（UUIDはAuthentication > Usersから確認）
-- insert into public.admin_users(user_id) values ('管理者ユーザーのUUID');
