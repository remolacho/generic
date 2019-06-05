module EngagementServices
    module Generic
        class Types

            def initialize(model:, field:, def_methods: nil)
                model   = model.to_s.split('_').map(&:capitalize).join('')
                @field  = field
                @_methods = def_methods || 'nil'
                @condition = '.not' unless def_methods
                query   = "#{model}.select('#{@field.to_s}').where#{@condition}('#{@field.to_s}' => #{@_methods} ).uniq"
                @types = eval(query)
                @types.each do |type|
                    self.define_singleton_method(type.send(@field).str_slug) { return type.send(@field)&.strip }
                end
            end

        end
    end
end

# service1 = EngagementServices::Generic::Types.new(model: :admin_notification, field: :notification_type)
# service2 = EngagementServices::Generic::Types.new(model: :evaluation_type, field: :evaluation_type)
# service3 = EngagementServices::Generic::Types.new(model: :dimension, field: :dimension_type)