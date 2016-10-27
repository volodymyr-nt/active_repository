module ActiveRepository
  class RelationDecorator
    include Enumerable
    extend Forwardable

    RETURN_RELATION_METHODS = [
     :find_by_sql,  :all, :where,
     :order, :joins, :group, :includes,
     :having, :limit, :offset, :select, :not
   ]

    PURE_DELEGATE_METHODS = [
     :find, :find_by, :first, :last, :count,
     :to_sql, :explain, :to_s, :to_a, :to_h,
     :as_json, :to_json, :take
    ]

    RETURN_RELATION_METHODS.each do |name|
      define_method(name) do |*args|
        relation = @relation.send(name, *args)
        # new_verion = clone
        # new_verion.relation = relation
        # new_verion
        self.class.new(relation)
      end
    end

    def_delegators :@relation, *PURE_DELEGATE_METHODS

    def initialize(relation)
      @relation = relation
    end

    def relation
      @relation
    end

    def each
      @relation.each { |item| yield item }
    end
  end
end
