module EngagementServices
    module Generic
        class Search

            attr_accessor :object, :relation

            def initialize(object:, relation:)
                @attributes = {}
                @object = object
                @relation = relation
            end

            def method_missing(name, *args)
                
                return yield if block_given?

                attribute = name.to_s
                
                return @attributes[attribute.chop] = args[0] if attribute =~ /=$/

                @attributes[attribute]

            end

            def get(condition = nil)
              object.send(relation).where(condition)
            rescue
              ArgumentError.new('Debes enviar la relacion y el objeto')
            end

        end
    end
end

# survey = Survey.find 1019
# dimension = Dimension.find 63129
# eval_type = EvaluationType.find 1640

# PA por survey y estado
# service = EngagementServices::Generic::Search.new(object: survey, relation: :commitments)
# service.status = [0, 1, 2]
# service.get({ state: service.status })

# PA por dimension en el survey
# service3 = EngagementServices::Generic::Search.new(object: dimension, relation: :commitments)
# service3.get({ survey_id: survey.id })

# dimensiones por tipo de evaluacion
# service2 = EngagementServices::Generic::Search.new(object: eval_type, relation: :dimensions)
# service2.get

# bloque
# service.joins_models{ service3.get({survey_id: survey.id}).joins(dimension: :evaluation_type).where(evaluation_types: {id: eval_type.id}) }

