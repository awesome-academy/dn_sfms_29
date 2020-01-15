class DateValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    return unless value

    comparation_field_start = parse_date record, options.values.first
    comparation_field_end = parse_date record, attribute
    return unless comparation_field_start[:value] ||
                  comparation_field_end[:value]

    end_value = value.to_i
    start_value = comparation_field_start[:value].to_i
    play_time = end_value - start_value
    return if start_value < end_value && (play_time % 3600).zero?

    message = options[:message] || :after
    record.errors.add attribute, message
  end

  def parse_date record, value
    {value: value.to_datetime,
     field_name: value}
  rescue NoMethodError, ArgumentError
    {value: record.try(value),
     field_name: record.class.human_attribute_name(value)}
  end
end
