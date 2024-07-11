-- size
SELECT
    pg_size_pretty(pg_table_size('Spins')) AS table_size,
    pg_size_pretty(pg_indexes_size('Spins')) AS indexes_size,
    pg_size_pretty(pg_total_relation_size('Spins')) AS total_size;

-- count lines
SELECT COUNT(*) AS total_rows FROM spins;


SELECT
    round(pg_total_relation_size('Spins') / (1024.0 * 1024.0), 2) AS total_size_megabytes;


DO
$$
    BEGIN
        FOR i IN 1..1000000 LOOP
                INSERT INTO spins (
                    created_at,
                    updated_at,
                    country,
                    host,
                    client_ip,
                    user_agent,
                    request,
                    id,
                    game_id,
                    game,
                    session_token,
                    transaction_id,
                    integrator,
                    provider,
                    internal_user_id,
                    external_user_id,
                    currency,
                    start_balance,
                    end_balance,
                    wager,
                    base_award,
                    bonus_award,
                    details,
                    restoring_indexes,
                    is_shown,
                    is_pfr,
                    operator,
                    is_demo,
                    final_award
                )
                VALUES (
                           now(),
                           now(),
                           NULL,
                           'http://localhost:8080',
                           '100.64.1.57',
                           'k6/0.52.0 (https://k6.io/)',
                           jsonb_build_object('wager', 200, 'currency', 'usd', 'engine_params', jsonb_build_object('ante_bet', false), 'session_token', gen_random_uuid()::text),
                           gen_random_uuid(),
                           gen_random_uuid(),
                           'lucky-santa-bonanza',
                           gen_random_uuid(),
                           gen_random_uuid(),
                           'mock',
                           'game_hub',
                           gen_random_uuid(),
                           gen_random_uuid()::text,
                           'usd',
                           9975360,
                           9975160,
                           200,
                           0,
                           0,
                           jsonb_build_object('award', 0, 'stops', jsonb_build_array(193, 0, 154, 45, 115, 193), 'wager', 200, 'features', jsonb_build_object('ante_bet', false, 'buy_bonus', false), 'avalanches', jsonb_build_array(jsonb_build_object('window', jsonb_build_array(jsonb_build_array(4, 3, 1, 4, 7), jsonb_build_array(2, 3, 2, 3, 4), jsonb_build_array(8, 3, 3, 4, 5), jsonb_build_array(1, 6, 9, 4, 9), jsonb_build_array(2, 2, 5, 9, 3), jsonb_build_array(5, 3, 2, 5, 5)), 'pay_items', jsonb_build_array(), 'wild_mask', NULL)), 'overridden_wager', 200, 'total_multiplier', 1, 'award_with_multipliers', 0),
                           jsonb_build_object('base_spin_index', 1, 'bonus_spin_index', 0),
                           true,
                           false,
                           'mock',
                           false,
                           0
                       );
            END LOOP;
    END
$$;

