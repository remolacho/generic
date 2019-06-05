module EngagementServices
    module Generic
        class SearchByType

            attr_accessor :relation, :relation_fields

            def initialize(model:, field:, def_methods: nil)
                
                model   = model.to_s.split('_').map(&:capitalize).join('')
                @field  = field
                @_methods = def_methods || 'nil'
                @condition = '.not' unless def_methods
                query   = "#{model}.select('#{@field.to_s}').where#{@condition}('#{@field.to_s}' => #{@_methods} ).uniq"
                @types  = eval(query)
                
                @types.each do |type|
                
                    self.define_singleton_method("get_#{type.send(@field).str_slug}") {

                        query = "#{model}.where('#{@field.to_s}' => '#{type.send(@field)&.strip}')"
                        result = eval(query)

                        if self.relation.present? && self.relation_fields.present?
                            return result.joins(self.relation)
                                         .where(self.relation.to_s => self.relation_fields )
                        end

                        return result.where( self.relation_fields ) if self.relation_fields.present?

                        result

                    }
                
                end

            end

            def method_missing(name, *args)
              ArgumentError.new("el metodo #{name} no existe")
            end

        end
    end
end

# service = EngagementServices::Generic::SearchByType.new(model: :admin_notification, field: :notification_type)
# service.get_add_collab

# service = EngagementServices::Generic::SearchByType.new(model: :dimension, field: :dimension_type)
# service.relation = :survey_dimensions
# service.relation_fields = {survey_id: 1019}


