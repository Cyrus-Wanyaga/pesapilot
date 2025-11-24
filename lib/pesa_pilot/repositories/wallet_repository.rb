#lib/pesa_pilot/repositories/wallet_repository.rb

module PesaPilot
    module Repositories
        class WalletRepository
            def initialize(db)
                @db = db
                @table = @db[:wallets]
            end

            def create(wallet) 
                @table.insert(
                    id: wallet.id,
                    name: wallet.name,
                    type: wallet.type.to_s,
                    initial_balance: wallet.initial_balance,
                    current_balance: wallet.current_balance,
                    created_at: Time.now
                )

                wallet
            end

            def update_balance(wallet_id:, new_balance:)
                @table.where(id: wallet_id).update(current_balance: new_balance)
            end

            def find(id)
                row = @table.where(id: id).first
                return nil unless row
                Core::Wallet.new(
                    id: row[:id],
                    name: row[:name],
                    type: row[:type].to_sym,
                    initial_balance: row[:initial_balance],
                ).tap { |w| w.current_balance = row[:current_balance] }
            end

            def find_by_name(name)
                row = @table.where(name: name).first
                return nil unless row
                Core::Wallet.new(
                    id: row[:id],
                    name: row[:name],
                    type: row[:type].to_sym,
                    initial_balance: row[:initial_balance],
                ).tap { |w| w.current_balance = row[:current_balance] }
            end

            def all
                @table.all.map do |row|
                    Core::Wallet.new(
                        id: row[:id],
                        name: row[:name],
                        type: row[:type].to_sym,
                        initial_balance: row[:initial_balance],
                    ).tap { |w| w.current_balance = row[:current_balance] }
                end
            end
        end
    end
end
