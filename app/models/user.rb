class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :attempts

  def from_for_word word
      word[self.language_from.to_s]
  end

  def to_for_word word
      word[self.language_to.to_s]
  end
end