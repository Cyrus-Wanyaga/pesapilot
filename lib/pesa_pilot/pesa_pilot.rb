# lib/pesa_pilot/pesa_pilot.rb

require 'time'
require 'fileutils'
require 'securerandom'

module PesaPilot 
    VERSION = "0.1.0"

    class CLI
        def initialize
            config = YAML.load_file(File.join(__dir__, "..", "..", "..", "config", "database.yml")) rescue {}
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
            else
                help
            end
        end
    end
end
