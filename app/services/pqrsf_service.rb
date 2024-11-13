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
end