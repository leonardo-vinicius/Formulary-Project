class CPFValidator < ActiveModel::Validator
  def validate(record)
    if CPF.valid?(record.cpf) != true
      record.errors.add :base, 'cpf invalid'
    end
  end
end