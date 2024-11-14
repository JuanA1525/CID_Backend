class PqrsfService
  def self.index
    Pqrsf.order(created_at: :desc)
  end

  def self.create(params)
    pqrsf = Pqrsf.new(params)
    if pqrsf.save
      { pqrsf: pqrsf, status: :created }
    else
      { errors: pqrsf.errors, status: :unprocessable_entity }
    end
  end

  def self.update(pqrsf, params)
    if pqrsf.update(params)
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
    Pqrsf.where(user_id: user_id).order(created_at: :desc)
  end

  def self.get_pending_pqrsf
    Pqrsf.where(pending: true).order(created_at: :desc)
  end

  def self.get_pqrsf_per_type(pqrsf_type)
    Pqrsf.where(pqrsf_type: pqrsf_type).order(created_at: :desc)
  end
end
