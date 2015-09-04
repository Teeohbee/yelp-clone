require 'rails_helper'
require 'support/factory_girl'

feature 'restaurants' do
  let(:user) { build :user }

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before { create :restaurant }

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    before { create :user }

    scenario 'prompts user to sign in first before creating a restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(page).to have_content 'You need to sign in or sign up before continuing'
    end

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      sign_in(user)
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        sign_in(user)
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do
    before { create :restaurant }

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      # expect(current_path).to eq "/restaurants/#{Restaurant.find(kfc).id}"
    end
  end

  context 'editing restaurants' do
    before { create :restaurant }

    scenario 'users aside from creater cannot edit restaurant' do
      user = create :user, email: '123@test.com'
      sign_in(user)
      visit '/restaurants'
      click_link 'Edit KFC'
      expect(page).to have_content 'Cannot edit'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'sign in then let creator edit a restaurant' do
      sign_in(user)
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do
    before { create :restaurant }

    scenario 'removes a restaurant when a user clicks a delete link' do
      sign_in(user)
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'removes reviews with it' do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: 'so so'
      select '3', from: 'Rating'
      click_button 'Leave Review'
      expect(current_path).to eq '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content('so so')
    end
  end

  def sign_in(user)
    visit '/'
    click_link 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end
end
