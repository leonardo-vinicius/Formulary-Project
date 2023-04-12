class CPFValidator < ActiveModel::Validator
    def validate(record)
      if CPF.valid?(record.cpf) != true
        record.errors.add :base, "cpf invalido"
      end
    end
end