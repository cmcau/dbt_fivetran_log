{{ config(enabled=fivetran_utils.enabled_vars(['fivetran_log_destination_membership'])) }}

with destination_membership as (
    
    select * from {{ var('destination_membership') }}

),

fields as (

    select
        destination_id,
        user_id,
        cast(activated_at as {{ dbt_utils.type_timestamp() }}) as activated_at,
        cast(joined_at as {{ dbt_utils.type_timestamp() }}) as joined_at,
        role as destination_role
        
    from destination_membership
)

select * from fields
