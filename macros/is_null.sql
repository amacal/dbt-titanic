{% test is_null(model, column_name, partition_condition=None) %}

    select 1
    from {{ model.replace_path(identifier=model.identifier ~ "$partitions").quote(identifier=True) }}
    where record_count - coalesce(data.{{ column_name }}.null_count, record_count) > 0

    {% if partition_condition is not none %}
        and {{ partition_condition }}
    {% endif %}

{% endtest %}
