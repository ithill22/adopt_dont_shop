require 'rails_helper'

RSpec.describe 'admin application show', type: :feature do

  let!(:shelter_1) { Shelter.create!(name: "Dumb Friends League", city: "Denver", foster_program: false, rank: 9) }
  let!(:pet_1) { shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false) }
  let!(:pet_2) { shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true) }
  let!(:application_1) { Application.create!(name: "John Doe", street_address: "123 Main St", city: "Denver", state: "CO", zip_code: "80202", description: "I love dogs", status: "In Progress") }
  let!(:application_pets_1) { ApplicationPet.create!(application_id: application_1.id, pet_id: pet_1.id) }

  describe 'As a visitor, when I visit an admin applications show page' do
    it 'For every pet that the application is for, I see a button to approve the application for that specific pet' do
      visit "/admin/applications/#{application_1.id}"

      click_button('Approve Pet')
      expect(current_path).to eq("/admin/applications/#{application_1.id}")
      expect(page).to have_content('Approved')
    end
  end
end