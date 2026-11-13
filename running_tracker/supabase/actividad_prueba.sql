-- Actividad de prueba: una vuelta corriendo por el Parque de Mayo, San Juan.
-- Pegar en Supabase > SQL Editor > Run.
-- Se asigna al último usuario que se registró en la app.
insert into public.activities (user_id, type, distance_km, duration_seconds, calories, route)
values (
  (select id from auth.users order by created_at desc limit 1),
  'run',
  2.56,
  922, -- 15 min 22 s, ritmo 6:00 /km
  179,
  '[[-31.53, -68.535], [-31.529094, -68.535153], [-31.52825, -68.535603], [-31.527525, -68.536318], [-31.526969, -68.53725], [-31.526619, -68.538335], [-31.5265, -68.5395], [-31.526619, -68.540665], [-31.526969, -68.54175], [-31.527525, -68.542682], [-31.52825, -68.543397], [-31.529094, -68.543847], [-31.53, -68.544], [-31.530906, -68.543847], [-31.53175, -68.543397], [-31.532475, -68.542682], [-31.533031, -68.54175], [-31.533381, -68.540665], [-31.5335, -68.5395], [-31.533381, -68.538335], [-31.533031, -68.53725], [-31.532475, -68.536318], [-31.53175, -68.535603], [-31.530906, -68.535153], [-31.53, -68.535]]'::jsonb
);
