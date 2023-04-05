class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy
  has_many :applications, through: :pets
  
  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def adoptable_pets_count
    pets.where(adoptable: true).count
  end

  def pets_adopted
    pets.where(adoptable: false).count
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def self.reverse_alpha_shelters 
    find_by_sql("SELECT * FROM shelters ORDER BY name desc;")
  end

  def self.find_name_and_address(shelter_id)
    find_by_sql("
      SELECT id, name, city
      FROM shelters
      WHERE id = #{shelter_id}
    ").first
   end
   
  def self.pending_app_shelters
    joins(:applications).where(applications: {status: "Pending"}).order(name: :asc)
  end

  def average_pet_age
    pets.average(:age).round(2)
  end
end
