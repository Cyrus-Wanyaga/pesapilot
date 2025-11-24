#frozen_string_literal: true

require 'securerandom'

module PesaPilot
    module App
        class MoneyTrackerApp
            def initialize(wallet_repo:)
                @wallet_repo = wallet_repo
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
        end
    end
end