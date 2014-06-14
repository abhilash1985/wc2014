class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def show_name
    full_name.blank? ? email : full_name
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
end
