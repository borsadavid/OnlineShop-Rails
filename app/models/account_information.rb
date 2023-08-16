class AccountInformation < ApplicationRecord
belongs_to :account
has_one_attached :profile_picture

before_save :encrypt_card_code
def encrypt_card_code
  self.card_code_digest = BCrypt::Password.create(card_code_digest)
  self.card_number_digest =BCrypt::Password.create(card_number_digest)
end

end
