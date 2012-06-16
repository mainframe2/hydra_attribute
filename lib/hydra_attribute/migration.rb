module HydraAttribute
  class Migration
    extend Forwardable
    def_delegators :@migration, :create_table, :drop_table, :add_index

    def initialize(migration)
      @migration = migration
    end

    def create_attributes
      create_table :hydra_attributes do |t|
        t.string :entity_type,  limit: 32, null: false
        t.string :name,         limit: 32, null: false
        t.string :backend_type, limit: 16, null: false
        t.string :default_value
        t.timestamps
      end
      add_index :hydra_attributes, [:entity_type, :name], unique: true, name: 'hydra_attributes_composite_index'

      create_table :hydra_sets do |t|
        t.string :entity_type, limit: 32, null: false
        t.string :name,        limit: 32, null: false
        t.timestamps
      end
      add_index :hydra_sets, [:entity_type, :name], unique: true, name: 'hydra_sets_composite_index'

      create_table :hydra_attribute_sets do |t|
        t.integer :hydra_attribute_id, null: false
        t.integer :hydra_set_id,       null: false
      end
      add_index :hydra_attribute_sets, [:hydra_attribute_id, :hydra_set_id], unique: true, name: 'hydra_attribute_sets_composite_index'
    end

    def drop_attributes
      drop_table :hydra_attribute_sets
      drop_table :hydra_sets
      drop_table :hydra_attributes
    end

    def create_entity(name, options = {}, &block)
      create_table name, options do |t|
        t.integer :hydra_set_id
        block.call(t)
      end

      SUPPORT_TYPES.each do |type|
        table_name = "hydra_#{name.to_s.singularize}_#{type}_values"
        create_table table_name do |t|
          t.integer :entity_id,          null: false
          t.integer :hydra_attribute_id, null: false
          t.send type, :value
          t.timestamps
        end
        add_index table_name, [:entity_id, :hydra_attribute_id], unique: true, name: "hydra_#{type}_values_composite_index"
      end
    end

    def drop_entity(name)
      drop_table name
      drop_table "#{name.to_s.singularize}_#{type}_values"
    end
  end
end