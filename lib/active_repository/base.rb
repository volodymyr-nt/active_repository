module ActiveRepository
  module Relations; end

  module Base
    extend Forwardable

    AR_DELEGATE_METHODS = [
     :all, :find, :find_by, :first, :last, :count
    ]

    def_delegators :@relation_decorator, *AR_DELEGATE_METHODS

    def initialize
      @relation_decorator =
        self.class.instance_variable_get(:@relation_decorator_class)
        .new(self.class.get_adapter)
    end

    def save(ar_model)
      ar_model.save
    end

    def update(ar_model, params)
      ar_model.update(params)
    end

    def delete(ar_model)
      ar_model.delete
    end

    def destroy(ar_model)
      ar_model.destroy
    end

    def self.included(repostitory_base)

      repostitory_base.instance_eval do
        def self.query(name, body)
          unless body.respond_to?(:call)
            raise ArgumentError, 'The scope body needs to be callable.'
          end

          unless @relation_decorator_class.respond_to?(name)
            @relation_decorator_class.send(:define_method, name, &body)
          end

          define_method(name) do |*args|
            @relation_decorator.send(name, *args)
          end
        end

        def get_adapter
          @adapter
        end

        def self.adapter(adapter_class)
          @adapter = adapter_class
          create_relation_decorator(adapter_class)
        end

        def self.create_relation_decorator(adapter)
          @relation_decorator_class = Relations.const_set(
            build_relation_class_name(adapter),
            Class.new(RelationDecorator)
          )
        end

        def self.build_relation_class_name(adapter)
          # TODO add namespace support
          "#{adapter.name.demodulize}Relation"
        end

        class << self
          alias_method :scope, :query
        end
      end
    end
  end
end
