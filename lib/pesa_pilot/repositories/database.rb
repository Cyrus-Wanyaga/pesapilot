#lib/pesa_pilot/repositories/database.rb

require 'sequel'

module PesaPilot
    module Repositories
        module Database
            def self.connect_sqlite(path)
                db = Sequel.sqlite(path)
                db
            end

            def self.init_schema(db)
                db.create_table? :wallets do
                    String :id, primary_key: true
                    String :name
                    String :type
                    Float :initial_balance
                    Float :current_balance
                    DateTime :created_at
                end

                db.create_table? :transactions do
                    String :id, primary_key: true
                    String :wallet_id
                    DateTime :timestamp
                    Float :amount
                    String :category
                    String :description
                    DateTime :created_at
                end

                db.create_table? :transfers do
                    String :id, primary_key: true
                    String :from_wallet_id
                    String :to_wallet_id
                    Float :amount
                    DateTime :timestamp
                    String :description
                    DateTime :created_at
                end
            end
        end
    end
end