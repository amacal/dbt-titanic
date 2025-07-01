{% test has_not_null_ratio(model, column_name, min_ratio=1.00, partition_condition=None) %}

    select 1
    from (
        select 1.0 * sum(record_count - coalesce(data.{{ column_name }}.null_count, record_count)) / nullif(sum(record_count), 0) as ratio
        from {{ model.replace_path(identifier=model.identifier ~ "$partitions").quote(identifier=True) }}

        {% if partition_condition is not none %}
            where {{ partition_condition }}
        {% endif %}
    )
    where ratio < {{ min_ratio }}

{% endtest %}
