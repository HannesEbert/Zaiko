-- Retention: hard-purge soft-deleted rows after 30 days, and drop expired
-- invites.
--
-- The function is the committed, reviewable artifact. Scheduling is done with
-- pg_cron when it is available (hosted Supabase); locally, where pg_cron is not
-- loaded, the scheduling step is skipped so `supabase db reset` stays green and
-- purge_expired() can be run by any external scheduler.

create or replace function public.purge_expired()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from public.foods
    where deleted_at is not null
      and deleted_at < now() - interval '30 days';

  delete from public.inventory_items
    where deleted_at is not null
      and deleted_at < now() - interval '30 days';

  delete from public.household_invites
    where expires_at < now();
end;
$$;

-- Schedule daily at 03:00 if pg_cron is present; otherwise skip quietly.
do $$
begin
  begin
    create extension if not exists pg_cron;
  exception
    when others then
      raise notice
        'pg_cron unavailable; purge schedule skipped (run purge_expired() via an external scheduler)';
      return;
  end;

  perform cron.schedule(
    'zaiko-purge-expired',
    '0 3 * * *',
    'select public.purge_expired();'
  );
end;
$$;
