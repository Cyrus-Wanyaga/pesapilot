#lib/pesa_pilot/repositories/transactions_repository.rb

module PesaPilot
    module Repositories
        class TransactionsRepository
            def initialize(db)
                @db = db
                @table = @db[:transactions]
            end

            def create(transaction)
                @table.insert(
                    id: transaction.id,
                    wallet_id: transaction.wallet_id,
                    timestamp: transaction.timestamp,
                    amount: transaction.amount,
                    category: transaction.category,
                    description: transaction.description,
                    created_at: Time.now
                )

                transaction
            end
        end
    end
end

            