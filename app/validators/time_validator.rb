class TimeValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    return unless value

    Time.zone.parse(value.to_s)
  rescue ArgumentError => e
    record.erros.add attribute, e.message
  end
end
