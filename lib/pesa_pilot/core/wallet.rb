# lib/pesa_pilot/core/wallet.rb

module PesaPilot
    module Core
        class Wallet
            attr_accessor :id, :name, :type, :initial_balance, :current_balance

            def initialize(id:, name:, type:, initial_balance: 0.0) 
                @id = id
                @name = name
                @type = type
                @initial_balance = initial_balance.to_f
                @current_balance = initial_balance
            end

            def apply_amount(amount) 
                @current_balance += amount
            end
        end
    end
end