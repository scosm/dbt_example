
-- This overrides the built-in macro of this name, so that our custom schema
-- names will be named <custom_schema_name> rather than PUBLIC_<custom_schema_name>,
-- where PUBLIC comes from our profiles.yml, our default schema name.
{%- macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro -%}
