# dbt-titanic

A lightweight package of custom dbt tests based on Iceberg's metadata. Designed to reduce the risk of scanning entire tables accidentally.

# install

Add the package to your `packages.yml`:

```yaml
packages:
  - git: "https://github.com/your-org/dbt-titanic.git"
    revision: main
```

Run `dbt deps` to install the macros.

# compatibility

- Works with AWS Athena — these tests are compatible with Iceberg tables queried via Athena, using metadata-only access patterns.
- Supports only primitive top-level column types (int, bigint, string, etc.).
- Nested fields (e.g., inside struct) or complex types (array, map) are not supported.

# available tests

|         Test         |                               Description                                |
| -------------------- | ------------------------------------------------------------------------ |
| `is_not_null`        | Fails if any partitions contain null values in the specified column.     |
| `is_null`            | Fails if any partitions contain non-null values.                         |
| `is_between`         | Ensures the column minimum and maximum fall between the provided bounds. |
| `has_not_null_ratio` | Checks that the ratio of non-null values meets or exceeds `min_ratio`.   |

# usage

Each test supports an optional `partition_condition` argument, allowing you to scope validations to specific Iceberg partitions.

## dbt_titanic.is_not_null

Ensures a column does not have null values in specified partitions.

``` yaml
columns:
  - name: user_id
    data_tests:
      - dbt_titanic.is_not_null:
          partition_condition: "partition.date >= date '2025-07-01'"
```

## dbt_titanic.is_null

Fails if non-null values exist where everything should be null. Useful for sanity checks on empty fields.

``` yaml
columns:
  - name: deleted_at
    data_tests:
      - dbt_titanic.is_null:
          partition_condition: "partition.date >= date '2025-07-01'"
```

## dbt_titanic.is_between

Checks if the column's min and max fall within a numeric range.

``` yaml
columns:
  - name: hour
    data_tests:
      - dbt_titanic.is_between:
          min_value: 0
          max_value: 23
          partition_condition: "partition.date >= date '2025-07-01'"
```

## dbt_titanic.has_not_null_ratio

Validates that the column has at least a minimum ratio of non-null values.

``` yaml
columns:
  - name: request_id
    data_tests:
      - dbt_titanic.has_not_null_ratio:
          min_ratio: 0.95
          partition_condition: "partition.date >= date '2025-07-01'"
```

# license

This project is licensed under the MIT License. See [`LICENSE`](LICENSE) for details.
