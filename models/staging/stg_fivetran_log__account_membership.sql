{{ config(enabled=fivetran_utils.enabled_vars(['fivetran_log_account_membership'])) }}

with account_membership as (
    
    select * from {{ var('account_membership') }}

),

fields as (

    select
        account_id,
        user_id,
        cast(activated_at as {{ dbt_utils.type_timestamp() }}) as activated_at,
        cast(joined_at as {{ dbt_utils.type_timestamp() }}) as joined_at,
        role as account_role
        
    from account_membership
    
)

select * from fields
