require 'spec_helper'

describe HydraAttribute::HydraAttributeSet do
  describe '.hydra_attribute_sets_by_hydra_set_id' do
    it 'should return all models with the following hydra_set_id' do
      ::ActiveRecord::Base.connection.insert('INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(1, 1)')
      ::ActiveRecord::Base.connection.insert('INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(2, 1)')
      ::ActiveRecord::Base.connection.insert('INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(2, 2)')

      hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(1)
      hydra_attribute_sets.should have(2).records
      hydra_attribute_sets[0].hydra_attribute_id.should be(1)
      hydra_attribute_sets[1].hydra_attribute_id.should be(2)
    end

    it 'should return blank array if there are not any models with the following hydra_set_id' do
      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(1).should be_blank
    end

    it 'should cache result into the nested hydra_set storage' do
      ::ActiveRecord::Base.connection.insert('INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(1, 1)')
      HydraAttribute::HydraAttributeSet.hydra_set_identity_map[1].should be_nil

      hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(1)
      hydra_attribute_sets.should have(1).item
      HydraAttribute::HydraAttributeSet.hydra_set_identity_map[1].should == hydra_attribute_sets
    end

    it 'should accept string as well' do
      ::ActiveRecord::Base.connection.insert('INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(2, 1)')
      HydraAttribute::HydraAttributeSet.hydra_set_identity_map[1].should be_nil

      hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id('1')
      hydra_attribute_sets.should have(1).item
      HydraAttribute::HydraAttributeSet.hydra_set_identity_map[1].should == hydra_attribute_sets
    end
  end

  describe '.hydra_attribute_sets_by_hydra_attribute_id' do
    it 'should return all models with the following hydra_attribute_id' do
      ::ActiveRecord::Base.connection.insert('INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(1, 1)')
      ::ActiveRecord::Base.connection.insert('INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(2, 1)')
      ::ActiveRecord::Base.connection.insert('INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(2, 2)')

      hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(2)
      hydra_attribute_sets.should have(2).records
      hydra_attribute_sets[0].hydra_set_id.should be(1)
      hydra_attribute_sets[1].hydra_set_id.should be(2)
    end

    it 'should return blank array if there are not any models with the following hydra_attribute_id' do
      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(1).should be_blank
    end

    it 'should cache result into the nested hydra_attribute storage' do
      ::ActiveRecord::Base.connection.insert('INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(1, 1)')
      HydraAttribute::HydraAttributeSet.hydra_attribute_identity_map[1].should be_nil

      hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(1)
      hydra_attribute_sets.should have(1).item
      HydraAttribute::HydraAttributeSet.hydra_attribute_identity_map[1].should == hydra_attribute_sets
    end

    it 'should accept string as well' do
      ::ActiveRecord::Base.connection.insert('INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(1, 2)')
      HydraAttribute::HydraAttributeSet.hydra_attribute_identity_map[1].should be_nil

      hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id('1')
      hydra_attribute_sets.should have(1).item
      HydraAttribute::HydraAttributeSet.hydra_attribute_identity_map[1].should == hydra_attribute_sets
    end
  end

  describe '.hydra_attributes_by_hydra_set_id' do
    it 'should return hydra_attribute models for the following hydra_set_id' do
      a1 = ::ActiveRecord::Base.connection.insert(%q[INSERT INTO hydra_attributes(entity_type, name, backend_type) VALUES('Product', 'name', 'string')])
      a2 = ::ActiveRecord::Base.connection.insert(%q[INSERT INTO hydra_attributes(entity_type, name, backend_type) VALUES('Product', 'code', 'string')])

      ::ActiveRecord::Base.connection.insert("INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(#{a1}, 1)")
      ::ActiveRecord::Base.connection.insert("INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(#{a2}, 1)")
      ::ActiveRecord::Base.connection.insert("INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(#{a2}, 2)")

      hydra_attributes = HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id(1)
      hydra_attributes.should have(2).models
      hydra_attributes[0].name.should == 'name'
      hydra_attributes[1].name.should == 'code'
    end

    it 'should return blank array if there are not any models with the following hydra_set_id' do
      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id(1).should be_blank
    end

    it 'should cache result into the nested hydra_attributes_by_hydra_set_id storage' do
      id = ::ActiveRecord::Base.connection.insert(%q[INSERT INTO hydra_attributes(entity_type, name, backend_type) VALUES('Product', 'name', 'string')])
      ::ActiveRecord::Base.connection.insert("INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(#{id}, 1)")

      hydra_attributes = HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id(1)
      hydra_attributes.should have(1).model
      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id_identity_map[1].should == hydra_attributes
    end

    it 'should accept string as well' do
      id = ::ActiveRecord::Base.connection.insert(%q[INSERT INTO hydra_attributes(entity_type, name, backend_type) VALUES('Product', 'name', 'string')])
      ::ActiveRecord::Base.connection.insert("INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(#{id}, 1)")
      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id_identity_map[1].should be_nil

      hydra_attributes = HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id('1')
      hydra_attributes.should have(1).model
      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id_identity_map[1].should == hydra_attributes
    end
  end

  describe '.hydra_sets_by_hydra_attribute_id' do
    it 'should return hydra_set models for the following hydra_attribute_id' do
      s1 = ::ActiveRecord::Base.connection.insert(%q[INSERT INTO hydra_sets(entity_type, name) VALUES('Product', 'one')])
      s2 = ::ActiveRecord::Base.connection.insert(%q[INSERT INTO hydra_sets(entity_type, name) VALUES('Product', 'two')])

      ::ActiveRecord::Base.connection.insert("INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(1, #{s1})")
      ::ActiveRecord::Base.connection.insert("INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(1, #{s2})")
      ::ActiveRecord::Base.connection.insert("INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(2, #{s2})")

      hydra_sets = HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id(1)
      hydra_sets.should have(2).models
      hydra_sets[0].name.should == 'one'
      hydra_sets[1].name.should == 'two'
    end

    it 'should return blank array if there are not any models with the following hydra_attribute_id' do
      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id(1).should be_blank
    end

    it 'should cache result into the nested hydra_sets_by_hydra_attribute_id storage' do
      id = ::ActiveRecord::Base.connection.insert(%q[INSERT INTO hydra_sets(entity_type, name) VALUES('Product', 'one')])
      ::ActiveRecord::Base.connection.insert("INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(2, #{id})")

      hydra_sets = HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id(2)
      hydra_sets.should have(1).model
      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id_identity_map[2].should == hydra_sets
    end

    it 'should accept string as well' do
      id = ::ActiveRecord::Base.connection.insert(%q[INSERT INTO hydra_sets(entity_type, name) VALUES('Product', 'one')])
      ::ActiveRecord::Base.connection.insert("INSERT INTO hydra_attribute_sets(hydra_attribute_id, hydra_set_id) VALUES(2, #{id})")
      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id_identity_map[2].should be_nil

      hydra_sets = HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id('2')
      hydra_sets.should have(1).model
      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id_identity_map[2].should == hydra_sets
    end
  end

  describe '#create' do
    it 'should store created record into hydra_set cache if it exists' do
      hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(1)
      hydra_attribute_sets.should be_blank

      hydra_attribute_set = HydraAttribute::HydraAttributeSet.new(hydra_attribute_id: 2, hydra_set_id: 1)
      hydra_attribute_set.save

      hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_set_identity_map[1]
      hydra_attribute_sets.should have(1).item
      hydra_attribute_sets.should include(hydra_attribute_set)
    end

    it 'should not store created record into hydra_set cache if it does not exist yet' do
      hydra_attribute_set = HydraAttribute::HydraAttributeSet.new(hydra_attribute_id: 2, hydra_set_id: 1)
      hydra_attribute_set.save

      HydraAttribute::HydraAttributeSet.hydra_set_identity_map[1].should be_nil
    end

    it 'should store created record into hydra_attribute cache if it exists' do
      hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(1)
      hydra_attribute_sets.should be_blank

      hydra_attribute_set = HydraAttribute::HydraAttributeSet.new(hydra_attribute_id: 1, hydra_set_id: 2)
      hydra_attribute_set.save

      hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_identity_map[1]
      hydra_attribute_sets.should have(1).item
      hydra_attribute_sets.should include(hydra_attribute_set)
    end

    it 'should not store created record into hydra_attribute cache if it does not exist yet' do
      hydra_attribute_set = HydraAttribute::HydraAttributeSet.new(hydra_attribute_id: 1, hydra_set_id: 2)
      hydra_attribute_set.save

      HydraAttribute::HydraAttributeSet.hydra_set_identity_map[1].should be_nil
    end

    it 'should store hydra_attribute into hydra_attribute_by_hydra_set_id cache if it exists' do
      hydra_attributes = HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id(5)
      hydra_attributes.should be_blank

      hydra_attribute = HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'title', backend_type: 'string')

      hydra_attribute_set = HydraAttribute::HydraAttributeSet.new(hydra_attribute_id: hydra_attribute.id, hydra_set_id: 5)
      hydra_attribute_set.save

      hydra_attributes = HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id_identity_map[5]
      hydra_attributes.should have(1).item
      hydra_attributes.should include(hydra_attribute)
    end

    it 'should not store hydra_attribute into hydra_attribute_by_hydra_set_id cache if it does not exist yet' do
      hydra_attribute     = HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'title', backend_type: 'string')
      hydra_attribute_set = HydraAttribute::HydraAttributeSet.new(hydra_attribute_id: hydra_attribute.id, hydra_set_id: 5)
      hydra_attribute_set.save

      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id_identity_map[5].should be_nil
    end

    it 'should store hydra_set into hydra_set_by_hydra_attribute_id cache if it exists' do
      hydra_sets = HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id(5)
      hydra_sets.should be_blank

      hydra_set = HydraAttribute::HydraSet.create(entity_type: 'Product', name: 'one')

      hydra_attribute_set = HydraAttribute::HydraAttributeSet.new(hydra_attribute_id: 5, hydra_set_id: hydra_set.id)
      hydra_attribute_set.save

      hydra_sets = HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id_identity_map[5]
      hydra_sets.should have(1).model
      hydra_sets.should include(hydra_set)
    end

    it 'should not store hydra_set into hydra_set_by_hydra_attribute_id cache if it does not exist yet' do
      hydra_set           = HydraAttribute::HydraSet.create(entity_type: 'Product', name: 'one')
      hydra_attribute_set = HydraAttribute::HydraAttributeSet.new(hydra_attribute_id: 5, hydra_set_id: hydra_set.id)
      hydra_attribute_set.save

      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id_identity_map[5].should be_nil
    end
  end

  describe '#delete' do
    it 'should remove model from hydra_set cache if it exists' do
      hydra_attribute_set1 = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: 1)
      hydra_attribute_set2 = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: 2)
      hydra_attribute_set3 = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 2, hydra_attribute_id: 3)

      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(1).should have(2).model
      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(2).should have(1).model

      hydra_attribute_set2.destroy

      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(1).should have(1).model
      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(2).should have(1).model

      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(1).should include(hydra_attribute_set1)
      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(2).should include(hydra_attribute_set3)
    end

    it 'should not touch hydra_set cache if it is nil' do
      HydraAttribute::HydraAttributeSet.hydra_set_identity_map[1].should be_nil

      hydra_attribute_set = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: 1)
      hydra_attribute_set.destroy

      HydraAttribute::HydraAttributeSet.hydra_set_identity_map[1].should be_nil
    end

    it 'should remove model from hydra_attribute cache if it exists' do
      hydra_attribute_set1 = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: 1)
      hydra_attribute_set2 = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 2, hydra_attribute_id: 1)
      hydra_attribute_set3 = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 3, hydra_attribute_id: 2)

      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(1).should have(2).model
      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(2).should have(1).model

      hydra_attribute_set2.destroy

      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(1).should have(1).model
      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(2).should have(1).model

      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(1).should include(hydra_attribute_set1)
      HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(2).should include(hydra_attribute_set3)
    end

    it 'should not touch hydra_attribute cache if it is nil' do
      HydraAttribute::HydraAttributeSet.hydra_attribute_identity_map[1].should be_nil

      hydra_attribute_set = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: 1)
      hydra_attribute_set.destroy

      HydraAttribute::HydraAttributeSet.hydra_attribute_identity_map[1].should be_nil
    end

    it 'should remove hydra_attribute from hydra_attributes_by_hydra_set cache if it exists' do
      hydra_attribute1 = HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'one', backend_type: 'string')
      hydra_attribute2 = HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'two', backend_type: 'string')

                            HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: hydra_attribute1.id)
      hydra_attribute_set = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: hydra_attribute2.id)
                            HydraAttribute::HydraAttributeSet.create(hydra_set_id: 2, hydra_attribute_id: hydra_attribute2.id)

      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id(1).should have(2).model
      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id(2).should have(1).model

      hydra_attribute_set.destroy

      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id(1).should have(1).model
      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id(2).should have(1).model

      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id(1).should include(hydra_attribute1)
      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id(2).should include(hydra_attribute2)
    end

    it 'should not touch hydra_attributes_by_hydra_set cache if it is nil' do
      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id_identity_map[1].should be_nil

      hydra_attribute_set = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: 1)
      hydra_attribute_set.destroy

      HydraAttribute::HydraAttributeSet.hydra_attributes_by_hydra_set_id_identity_map[1].should be_nil
    end

    it 'should remove hydra_set from hydra_sets_by_hydra_attribute_id cache if it exists' do
      hydra_set1 = HydraAttribute::HydraSet.create(entity_type: 'Product', name: 'one')
      hydra_set2 = HydraAttribute::HydraSet.create(entity_type: 'Product', name: 'two')

                            HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set1.id, hydra_attribute_id: 1)
      hydra_attribute_set = HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set2.id, hydra_attribute_id: 1)
                            HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set2.id, hydra_attribute_id: 2)

      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id(1).should have(2).model
      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id(2).should have(1).model

      hydra_attribute_set.destroy

      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id(1).should have(1).model
      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id(2).should have(1).model

      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id(1).should include(hydra_set1)
      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id(2).should include(hydra_set2)
    end

    it 'should not touch hydra_sets_by_hydra_attribute_id cache if it is nil' do
      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id_identity_map[1].should be_nil

      hydra_attribute_set = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: 1)
      hydra_attribute_set.destroy

      HydraAttribute::HydraAttributeSet.hydra_sets_by_hydra_attribute_id_identity_map[1].should be_nil
    end
  end

  describe '#hydra_set' do
    it 'should return HydraSet model if this model is persisted' do
      hydra_set = HydraAttribute::HydraSet.create(name: 'default', entity_type: 'Product')

      hydra_attribute_set = HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set.id, hydra_attribute_id: 2)
      hydra_attribute_set.hydra_set.should be(hydra_set)
    end

    it 'should return nil if this model is not persisted' do
      HydraAttribute::HydraAttributeSet.new.hydra_set.should be_nil
    end
  end

  describe '#hydra_attribute' do
    it 'should return HydraAttribute model if this model is persisted' do
      hydra_attribute = HydraAttribute::HydraAttribute.create(name: 'title', entity_type: 'Product', backend_type: 'string')

      hydra_attribute_set = HydraAttribute::HydraAttributeSet.create(hydra_set_id: 2, hydra_attribute_id: hydra_attribute.id)
      hydra_attribute_set.hydra_attribute.should be(hydra_attribute)
    end

    it 'should return nil if this model is not persisted' do
      HydraAttribute::HydraAttributeSet.new.hydra_attribute.should be_nil
    end
  end

  describe 'callbacks' do
    describe 'hydra_set destroyed' do
      let!(:hydra_set)           { HydraAttribute::HydraSet.create(name: 'default', entity_type: 'Product') }
      let!(:hydra_attribute)     { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'title', backend_type: 'string') }
      let!(:hydra_attribute_set) { HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set.id, hydra_attribute_id: hydra_attribute.id) }

      it 'should destroy hydra_attribute_set relation from database' do
        hydra_set.destroy
        ::ActiveRecord::Base.connection.select_value(%[SELECT COUNT(*) FROM hydra_attribute_sets WHERE id=#{hydra_attribute_set.id}]).to_i.should be(0)
      end

      it 'should remove hydra_attribute_set relation from cache' do
        hydra_set.destroy
        lambda do
          HydraAttribute::HydraAttributeSet.find(hydra_attribute_set.id)
        end.should raise_error(HydraAttribute::RecordNotFound, "Couldn't find HydraAttribute::HydraAttributeSet with id=#{hydra_attribute_set.id}")
      end

      it 'should remove hydra_set cache' do
        HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(hydra_set.id).should include(hydra_attribute_set)
        hydra_set.destroy
        HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(hydra_set.id).should be_blank
      end

      it 'should remove hydra_set from hydra_attribute cache' do
        hydra_set2           = HydraAttribute::HydraSet.create(name: 'second', entity_type: 'Product')
        hydra_attribute_set2 = HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set2.id, hydra_attribute_id: hydra_attribute.id)

        hydra_set.destroy
        hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(hydra_attribute.id)
        hydra_attribute_sets.should_not include(hydra_attribute_set)
        hydra_attribute_sets.should     include(hydra_attribute_set2)
      end
    end

    describe 'hydra_attribute destroyed' do
      let!(:hydra_set)           { HydraAttribute::HydraSet.create(name: 'default', entity_type: 'Product') }
      let!(:hydra_attribute)     { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'title', backend_type: 'string') }
      let!(:hydra_attribute_set) { HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set.id, hydra_attribute_id: hydra_attribute.id) }

      it 'should destroy hydra_attribute_set relation from database' do
        hydra_attribute.destroy
        ::ActiveRecord::Base.connection.select_value(%[SELECT COUNT(*) FROM hydra_attribute_sets WHERE id=#{hydra_attribute_set.id}]).to_i.should be(0)
      end

      it 'should remove hydra_attribute_set relation from cache' do
        hydra_set.destroy
        lambda do
          HydraAttribute::HydraAttributeSet.find(hydra_attribute_set.id)
        end.should raise_error(HydraAttribute::RecordNotFound, "Couldn't find HydraAttribute::HydraAttributeSet with id=#{hydra_attribute_set.id}")
      end

      it 'should remove hydra_attribute cache' do
        HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(hydra_attribute.id).should include(hydra_attribute_set)
        hydra_attribute.destroy
        HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_attribute_id(hydra_attribute.id).should be_blank
      end

      it 'should remove hydra_attribute from hydra_set cache' do
        hydra_attribute2     = HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'code', backend_type: 'string')
        hydra_attribute_set2 = HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set.id, hydra_attribute_id: hydra_attribute2.id)

        hydra_attribute.destroy
        hydra_attribute_sets = HydraAttribute::HydraAttributeSet.hydra_attribute_sets_by_hydra_set_id(hydra_set.id)
        hydra_attribute_sets.should_not include(hydra_attribute_set)
        hydra_attribute_sets.should     include(hydra_attribute_set2)
      end
    end
  end

  describe 'validations' do
    it 'should require hydra_set_id' do
      hydra_attribute_set = HydraAttribute::HydraAttributeSet.new
      hydra_attribute_set.valid?
      hydra_attribute_set.errors.should include(:hydra_set_id)

      hydra_attribute_set.hydra_set_id = 1
      hydra_attribute_set.valid?
      hydra_attribute_set.errors.should_not include(:hydra_set_id)
    end

    it 'should require hydra_attribute_id' do
      hydra_attribute_set = HydraAttribute::HydraAttributeSet.new
      hydra_attribute_set.valid?
      hydra_attribute_set.errors.should include(:hydra_attribute_id)

      hydra_attribute_set.hydra_attribute_id = 1
      hydra_attribute_set.valid?
      hydra_attribute_set.errors.should_not include(:hydra_attribute_id)
    end

    it 'should have unique hydra_set_id with hydra_attribute_id' do
      HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: 2).should be_persisted
      HydraAttribute::HydraAttributeSet.create(hydra_set_id: 1, hydra_attribute_id: 2).should_not be_persisted
    end
  end
end