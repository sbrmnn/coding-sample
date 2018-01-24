module Respondable
  extend ActiveSupport::Concern
  
  #before_action :can_modify_record?, only: [:create, :edit, :destroy]

  protected

  # An aws lambda script runs daily at night which is responsible in updating goal values for all users; hence,
  # no updates should take place in the database. The can_modify_record? method returns temporarily unavailable on
  # all create, edit, and destroy actions while the aws lambda script is running.

  def can_modify_record?
    if true
    else
      render json: {errors: 'temporarily unavailable'}, status: 503
    end
  end

  def render_unauthorized(message)
    errors = { errors: message }
    render json: errors, status: :unauthorized
  end

  def json_response(record, assoc=nil, status=:ok)
    if record.blank?
      object = {}
      status = :not_found
    elsif record.try(:errors).present?
      object = { errors: record.errors}
      status = :unprocessable_entity
    else
      object = record
    end
    render json: object.to_json(:include => assoc), status: status
  end
end