# dbt_fivetran_log v0.5.5
## Fixes
- Added the option to disable some models that are not available depending on your Fivetran license. In dbt_project.yml you can now change these flags to disable parts of the package
  - fivetran_log_account_membership
  - fivetran_log_active_volume
  - fivetran_log_credits_used
  - fivetran_log_destination_membership
  - fivetran_log_user

  Include this in your dbt_project.yml file

  ```
  fivetran_log_account_membership: false # Disables account membership models
  fivetran_log_active_volume: false # Disables account membership models
  fivetran_log_credits_used: false # Disables account membership models
  fivetran_log_destination_membership: false # Disables account membership models
  fivetran_log_user: false # Disables account membership models
  ```

# dbt_fivetran_log v0.5.4
## Fixes
- The unique combination of columns test within the `fivetran_log__schema_changelog` model has been updated to also check the `message_data` field. This is needed as schema changelog events may now sync at the same time. ([#51](https://github.com/fivetran/dbt_fivetran_log/pull/51))
- The `fivetran_log__connector_status` model has been adjusted to filter out all logs that contain a `transformation_id`. Transformation logs are not always synced as a JSON object and thus the package may encounter errors on Snowflake warehouses when parsing non-JSON fields. Since transformation records are not used in this end model, they have been filtered out. ([#51](https://github.com/fivetran/dbt_fivetran_log/pull/51))
# dbt_fivetran_log v0.5.3
## Fixes
- Per the [Fivetran Log December 2021 Release Notes](https://fivetran.com/docs/logs/changelog#december2021) every sync results in a final `sync_end` event. In the previous version of this package, a successful sync was identified via a `sync_end` event while anything else was a version of broken. Since all syncs result in a `sync_end` event now, the package has been updated to account for this change within the connector.
- To account for the above fix, a new field (`last_successful_sync_completed_at`) was added to the `fivetran_log__connector_status` model. This field captures the last successful sync for the connector.
# dbt_fivetran_log v0.5.2
## Fixes
- The `fivetran_log__connector_status` model uses a date function off of `created_at` from the `stg_fivetran_log__log` model. This fails on certain redshift destinations as the timestamp is synced as `timestamptz`. Therefore, the field within the staging model is cast using `dbt_utils.type_timestamp` to appropriately cast the field for downstream functions. Further, to future proof, timestamps were cast within the following staging models: `account`, `account_membership`, `active_volume`, `destination_membership`, `destination`, `log`, `transformation`, and `user`. ([#40](https://github.com/fivetran/dbt_fivetran_log/pull/40))
# dbt_fivetran_log v0.5.1

## Features
This release just introduces Databricks compatibility! 🧱🧱

# dbt_fivetran_log v0.5.0
🎉 Official dbt v1.0.0 Compatibility Release 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_fivetran_utils`. The latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

## Additional Features
- Materializes the `fivetran_log__audit_table` incrementally, and employs partitioning for BigQuery users. As a non-incremental table, this model involved high runtimes for some users ([#27](https://github.com/fivetran/dbt_fivetran_log/issues/27))
  - If you would like to apply partitioning to the underlying source tables (ie the `LOG` table), refer to [Fivetran docs](https://fivetran.com/docs/destinations/bigquery/partition-table) on how to do so.
- Expands compatibility to Postgres!

# dbt_fivetran_log v0.5.0-b1
🎉 dbt v1.0.0 Compatibility Pre Release 🎉 An official dbt v1.0.0 compatible version of the package will be released once existing feature/bug PRs are merged.
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_fivetran_utils`. The latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_fivetran_log v0.4.1

## 🚨 Breaking Changes
- n/a

## Bug Fixes
- Added logic in the `fivetran_log__connector_status` model to accommodate the way [priority-first syncs](https://fivetran.com/docs/getting-started/feature#priorityfirstsync) are currently logged. Now, each connector's `connector_health` field can be one of the following values:
    - "broken"
    - "incomplete"
    - "connected"
    - "paused"
    - "initial sync in progress"
    - "priority first sync"
Once your connector has completed its priority-first sync and begun syncing normally, it will be marked as `connected`.

## Features
- Added this changelog to capture iterations of the package!

## Under the Hood
- n/a
