require 'dotenv/load'
require "invoice_lookup/version"
require 'invoice_lookup/graphql_client'
require 'tty-prompt'
require 'pry'

module InvoiceLookup
  prompt = TTY::Prompt.new
  account_number = prompt.ask 'What is your account number?'
  puts "Search for account number #{account_number}"

  endpoint = GraphqlClient.new

  Query = endpoint.client.parse <<-QUERY
  {
    company(account_number: "#{account_number}"){
      name
      bills {
        invoice_number
        invoice_date
        due_date
        total
        amount_outstanding
      }
    }
  }
  QUERY
  
  response = endpoint.client.query(Query)

  prompt.ok "Hello, #{response.data.company.name}!"

  if prompt.yes?('View invoices?')
    response.data.company.bills.each do |bill|
      prompt.warn <<-MSG 
        Invoice #{bill.invoice_number} has a total amount of $#{bill.total} and 
        is due on #{bill.due_date}. $#{bill.amount_outstanding} is still due.
      MSG
    end
  end
end
