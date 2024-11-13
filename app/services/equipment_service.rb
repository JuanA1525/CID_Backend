# app/services/equipment_service.rb

class EquipmentService
  def self.index
    equipment = Equipment.order(created_at: :desc)
    equipment_with_names = equipment.map do |eq|
      name = "#{eq.equipment_type}_#{eq.sport.name}_#{eq.id}"
      sport = eq.sport.name
      eq.as_json.merge(name: name, sport: sport)
    end
    equipment_with_names
  end

  def self.index
    equipment = Equipment.order(created_at: :desc)
    equipment_with_names = equipment.map do |eq|
      name = "#{eq.equipment_type}_#{eq.sport.name}_#{eq.id}"
      sport = eq.sport.name
      eq.as_json.merge(name: name, sport: sport)
    end
    equipment_with_names
  end

  def self.show(equipment)
    name = "#{equipment.equipment_type}_#{equipment.sport.name}_#{equipment.id}"
    sport = equipment.sport.name
    equipment.as_json.merge(name: name, sport: sport)
  end

  def self.create(params)
    equipment = Equipment.new(params)
    if equipment.save
      name = "#{equipment.equipment_type}_#{equipment.sport.name}_#{equipment.id}"
      sport = equipment.sport.name
      { equipment: equipment.as_json.merge(name: name, sport: sport), status: :created }
    else
      { errors: equipment.errors, status: :unprocessable_entity }
    end
  end

  def self.update(equipment, params)
    if equipment.update(params)
      name = "#{equipment.equipment_type}_#{equipment.sport.name}_#{equipment.id}"
      sport = equipment.sport.name
      { equipment: equipment.as_json.merge(name: name, sport: sport), status: :ok }
    else
      { errors: equipment.errors, status: :unprocessable_entity }
    end
  end

  def self.destroy(equipment)
    equipment.destroy
  end
end
