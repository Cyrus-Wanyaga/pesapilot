# lib/pesa_pilot/core/transaction.rb

module PesaPilot
    module Core
        class transaction
            attr_accessor :id, :wallet_id, :timestamp, :amount, :category, :description

            def initialize(id:, wallet_id:, timestamp:, amount:, category:, description: '')
                @id = id
                @wallet_id = wallet_id
                @timestamp = timestamp.is_a?(Time) ? timestamp : Time.parse(timestamp.to_s)
                @amount = amount.to_f
                @category = category.to_sym
                @description = description
            end

            def expense?
                amount < 0
            end

            def income?
                amount > 0
            end
        end
    end
end