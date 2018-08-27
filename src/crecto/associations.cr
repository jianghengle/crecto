module Crecto
  module Associations
    CRECTO_ASSOCIATIONS = Array(NamedTuple(association_type: Symbol,
      key: Symbol,
      this_klass: Model.class,
      klass: Model.class,
      foreign_key: Symbol,
      foreign_key_value: Proc(Model, PkeyValue),
      set_association: Proc(Model, (Array(Crecto::Model) | Model), Nil),
      through: Symbol?)).new

    # Get the Class for the assocation name
    # i.e. :posts => Post
    def self.klass_for_association(this_klass : Model.class, association : Symbol)
      CRECTO_ASSOCIATIONS.select { |a| a[:key] == association && a[:this_klass] == this_klass }.first[:klass]
    end

    # Get the foreign key for the association
    # i.e. :posts => :user_id
    def self.foreign_key_for_association(this_klass : Model.class, association : Symbol) : Symbol
      CRECTO_ASSOCIATIONS.select { |a| a[:key] == association && a[:this_klass] == this_klass }.first[:foreign_key]
    end

    def self.foreign_key_for_association(this_klass : Model.class, klass : Crecto::Model.class)
      CRECTO_ASSOCIATIONS.select { |a| a[:klass] == klass && a[:this_klass] == this_klass }.first[:foreign_key]
    end

    # Get the foreign key value from the relation object
    # i.e. :posts, post => post.user_id
    def self.foreign_key_value_for_association(this_klass : Model.class, association : Symbol, item)
      CRECTO_ASSOCIATIONS.select { |a| a[:key] == association && a[:this_klass] == this_klass }.first[:foreign_key_value].call(item).as(PkeyValue)
    end

    # Set the value for the association
    # i.e. :posts, user, [posts] => user.posts = [posts]
    def self.set_value_for_association(this_klass : Model.class, association : Symbol, item, items)
      CRECTO_ASSOCIATIONS.select { |a| a[:key] == association && a[:this_klass] == this_klass }.first[:set_association].call(item, items)
    end

    # Get the association type for the association
    # i.e. :posts => :has_many
    def self.association_type_for_association(this_klass : Model.class, association : Symbol)
      CRECTO_ASSOCIATIONS.select { |a| a[:key] == association && a[:this_klass] == this_klass }.first[:association_type]
    end

    # Get the through association symbol
    # i.e. :posts => :user_posts (if has_many through)
    def self.through_key_for_association(this_klass : Model.class, association : Symbol) : Symbol?
      CRECTO_ASSOCIATIONS.select { |a| a[:key] == association && a[:this_klass] == this_klass }.first[:through]
    end
  end
end
