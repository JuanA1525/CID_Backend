class PqrsfService
  def self.index
    Pqrsf.order(created_at: :desc)
  end

  def self.create(pqrsf_params)
    pqrsf = Pqrsf.new(pqrsf_params)
    if pqrsf.save
      { pqrsf: pqrsf, status: :created }
    else
      { errors: pqrsf.errors, status: :unprocessable_entity }
    end
  end

  def self.update(pqrsf, pqrsf_params)
    if pqrsf.update(pqrsf_params)
      { pqrsf: pqrsf, status: :ok }
    else
      { errors: pqrsf.errors, status: :unprocessable_entity }
    end
  end

  def self.destroy(pqrsf)
    pqrsf.destroy
    { message: "Pqrsf deleted", status: :ok }
  end

  def self.get_pqrsf_by_user(user_id)
    pqrsf = Pqrsf.where(user_id: user_id).order(created_at: :desc)
    pqrsf
  end

  def self.get_pending_pqrsf
    pqrsf = Pqrsf.where(status: "pending").order(created_at: :desc)
    pqrsf
  end

  def self.get_pqrsf_per_type(pqrsf_type)
    pqrsf = Pqrsf.where(pqrsf_type: pqrsf_type).order(created_at: :desc)
    pqrsf
  end
end
