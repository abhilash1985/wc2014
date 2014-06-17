class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :predictions
         
  def show_name
    full_name.blank? ? email : full_name
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def current_admin
    current_user && current_user.is_admin
  end
end
