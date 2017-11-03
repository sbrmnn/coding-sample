module Response
  extend ActiveSupport::Concern
  
  protected

  def render_unauthorized(message)
    errors = { errors: [ { detail: message } ] }
    render json: errors, status: :unauthorized
  end

  def json_response(record)
    if record.blank?
      object = {}
      status = :not_found
    elsif record.try(:errors).present?
      object = record.errors
      status = :unprocessable_entity
    else
      status = :ok
      object = record  
      assoc = record.class.is_a?(ActiveRecord::Relation) ? record.first.class.reflect_on_all_associations.map{|l| l.name} : record.class.reflect_on_all_associations.map{|l| l.name}
    end
    render json: object.to_json(:include => assoc), status: status
  end
end