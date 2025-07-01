{% test is_between(model, column_name, min_value=None, max_value=None, partition_condition=None) %}

    select 1
    from {{ model.replace_path(identifier=model.identifier ~ "$partitions").quote(identifier=True) }}
    where (
        1 = 0

        {% if min_value is not none %}
            or data.{{ column_name }}.min < {{ min_value }}
        {% endif %}

        {% if max_value is not none %}
            or data.{{ column_name }}.max > {{ max_value }}
        {% endif %}
    )

    {% if partition_condition is not none %}
        and {{ partition_condition }}
    {% endif %}

{% endtest %}
