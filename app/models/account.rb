class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  
  has_one :account_information
  has_one :order
  has_many :product_qrs

  def confirmation_required?
    !confirmed?
  end

end
