# lib/pesa_pilot/pesa_pilot.rb

require 'time'
require 'fileutils'
require 'securerandom'
require 'sequel'
require 'yaml'

#load core
require_relative "core/transaction"
require_relative "core/wallet"
require_relative "core/transfer"

#load repositories
require_relative "repositories/database"
require_relative "repositories/wallet_repository"
require_relative "repositories/transactions_repository"

#load app
require_relative "app/money_tracker_app"

module PesaPilot 
    VERSION = "0.1.0"

    class CLI
        def initialize
            config = YAML.load_file(File.join(__dir__, "..", "..", "..", "config", "database.yml")) rescue {}
            db_path = config.dig('sqlite', 'database') || File.join(Dir.pwd, "pesa_pilot.db")
            @db = Repositories::Database.connect_sqlite(db_path)
            @wallet_repo = Repositories::WalletRepository.new(@db)
            @transactions_repo = Repositories::TransactionsRepository.new(@db)
            @app = App::MoneyTrackerApp.new(
                wallet_repo: @wallet_repo,
                transactions_repo: @transactions_repo
            )
        end

        def help
            puts <<~USAGE
                PesaPilot CLI
                Usage: 
                    money_tracker init-db
                    money_tracker add-wallet "Name" type initial_balance
                    money_tracker wallets
                    money_tracker record wallet_name amount category description
                    money_tracker import csv|json file_path
                    money_tracker report daily YYYY-MM-DD
                    money_tracker report monthly YYYY-MM
                    money_tracker balance
                    money_tracker help

                USAGE
        end

        def run(agrv) 
            cmd = agrv.shift
            case cmd
            when "help", nil
                help
            when "init-db"
                Repositories::Database.init_schema(@db)
                puts "Database initialized successfully"
            when "add-wallet"
                name = agrv.shift
                type = agrv.shift
                balance = (agrv.shift || '0').to_f
                wallet = @app.add_wallet(name: name, type: type.to_sym, initial_balance: balance)
                puts "Created wallet #{wallet.name} (#{wallet.type}) with balance #{wallet.current_balance}"
            when "wallets"
                @wallet_repo.all.each { |w| puts "#{w.id} | #{w.name} | #{w.type} | #{w.current_balance}"}
            when "record"
                name = agrv.shift
                amount = agrv.shift.to_f
                category = (agrv.shift || "expense").downcase
                timestamp = agrv.shift.to_s
                description = agrv.join(' ')
                wallet = @wallet_repo.find_by_name(name)
                unless wallet
                    puts "Wallet not found: #{name}"
                    return
                end
                @app.record_transaction(wallet: wallet, amount: amount, category: category, description: description, timestamp: timestamp)
                puts "Recorded #{amount} on #{wallet.name} as #{category}"
            when "balance"
                balance = @app.get_total_balance
                puts "Total wallet balance is #{balance.to_s}"
            else
                help
            end
        end
    end
end
