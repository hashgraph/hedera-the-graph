DO $$
DECLARE
    drop_schemas_cmd text;
    drop_tables_cmd text;
    drop_views_cmd text;
BEGIN
    -- Prepare command to drop all non-system schemas except 'public'
    SELECT INTO drop_schemas_cmd
        string_agg('DROP SCHEMA ' || quote_ident(schema_name) || ' CASCADE', '; ')
    FROM information_schema.schemata
    WHERE schema_name NOT IN ('public', 'information_schema', 'pg_catalog', 'pg_toast', 'pg_temp_4', 'pg_toast_temp_4');

    -- Execute if command is not null
    IF drop_schemas_cmd IS NOT NULL THEN
        EXECUTE drop_schemas_cmd;
    END IF;

    -- Prepare command to drop all user-created tables in the 'public' schema
    SELECT INTO drop_tables_cmd
        string_agg('DROP TABLE IF EXISTS public.' || quote_ident(table_name) || ' CASCADE', '; ')
    FROM information_schema.tables
    WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
          AND table_name NOT LIKE 'pg_%';

    -- Execute if command is not null
    IF drop_tables_cmd IS NOT NULL THEN
        EXECUTE drop_tables_cmd;
    END IF;

    -- Prepare command to drop all user-created views in the 'public' schema
    SELECT INTO drop_views_cmd
        string_agg('DROP VIEW IF EXISTS public.' || quote_ident(table_name) || ' CASCADE', '; ')
    FROM information_schema.views
    WHERE table_schema = 'public' AND table_name NOT LIKE 'pg_%';

    -- Execute if command is not null
    IF drop_views_cmd IS NOT NULL THEN
        EXECUTE drop_views_cmd;
    END IF;
END $$;
