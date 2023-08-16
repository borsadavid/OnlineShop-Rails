class OrderMailer < ApplicationMailer
include Rails.application.routes.url_helpers
  require 'wicked_pdf'
  layout 'mailer'
  default from: "steals.and.deals.orders@gmail.com"

  def send_to_admin_new_order(processed_orders)
    @account = Account.where(role: 'admin')
    @processed_orders = processed_orders
    attachments['invoice.pdf'] = generate_pdf_invoice
    
    @account.each do |account|
    mail(to: account.email, subject: 'New order placed')
    end
  end

  def new_question(product_id, product_question)
    @product_question = product_question
    @product = Product.find_by(id: product_id)
    @category_name = ""
    @category_name = Category.find(@product.category_id).name 
    @account_name =  product_question.account.account_information&.first_name.presence || "User"
    @account = Account.where(role: 'admin')
    @account.each do |account|
    mail(to: account.email, subject: "New Question Posted")
    end
  end

  def send_update_mail(processed_orders)
    @processed_orders = processed_orders
    account = Account.find_by(id: @processed_orders.first.account_id)
    mail(to: account.email, subject: "You order is #{@processed_orders.first.status}!")
  end

  def stock_empty_email(product)
    @account = Account.where(role: 'admin')
    @product = product
    @category_name = Category.find(@product.category_id).name 
    @account.each do |account|
    mail(to: account.email, subject: 'A product ran out of stock!')
    end
  end

  def send_email(account, processed_orders)
    @account = account
    @processed_orders = processed_orders
    attachments['invoice.pdf'] = generate_pdf_invoice
    mail(to: account.email, subject: 'Order Placed!')
  end

  private

    def generate_pdf_invoice
      pdf = WickedPdf.new.pdf_from_string(
        render_to_string(
          template: 'order_mailer/invoice_pdf',
        )
      )
      pdf
    end

end
