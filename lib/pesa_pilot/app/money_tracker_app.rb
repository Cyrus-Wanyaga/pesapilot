#frozen_string_literal: true

require 'securerandom'

module PesaPilot
    module App
        class MoneyTrackerApp
            def initialize(wallet_repo:, transactions_repo:)
                @wallet_repo = wallet_repo
                @transactions_repo = transactions_repo
            end

            def add_wallet(name:, type:, initial_balance:)
                existing_wallet = @wallet_repo.find_by_name(name)
                if existing_wallet
                    raise ArgumentError, "A wallet with the name #{name} already exists."
                end

                id = SecureRandom.uuid

                wallet = Core::Wallet.new(
                    id: id,
                    name: name,
                    type: type,
                    initial_balance: initial_balance
                )

                @wallet_repo.create(wallet)
            end

            def record_transaction(wallet:, amount:, timestamp:, category:, description:)
                id = SecureRandom.uuid

                transaction = Core::Transaction.new(
                    id: id,
                    wallet_id: wallet.id,
                    amount: amount,
                    category: category,
                    description: description,
                    timestamp: timestamp
                )

                @transactions_repo.create(transaction)

                new_balance =
                if category.to_s.downcase == "expense"
                    wallet.current_balance - amount
                else 
                    wallet.current_balance + amount
                end

                @wallet_repo.update_balance(wallet_id: wallet.id, new_balance: new_balance)
            end

            def get_total_balance()
                @wallet_repo.all().sum(&:current_balance)
            end
        end
    end
end