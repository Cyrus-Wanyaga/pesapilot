#lib/pesa_pilot/core/transfer.rb

module PesaPilot
    module Core
        class Transfer
            attr_accessor :id, :from_wallet_id, :to_wallet_id, :amount, :timestamp, :description

            def initialize(id:, from_wallet_id:, to_wallet_id:, amount:, timestamp:, description: '')
                @id = id
                @from_wallet_id = from_wallet_id
                @to_wallet_id = to_wallet_id
                @amount = amount.to_f
                @timestamp = timestamp.is_a?(Time) ? timestamp : Time.parse(timestamp.to_s)
                @description = description
            end
        end
    end
end