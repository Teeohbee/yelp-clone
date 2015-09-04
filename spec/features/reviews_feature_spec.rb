require 'rails_helper'

feature 'reviewing' do
  before { create :restaurant }
  let(:user) { build :user }

  scenario 'allows users to leave a review using a form' do
    sign_in(user)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario "doesn't allow a user to re-review a restaurant" do
    sign_in(user)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    click_link 'Review KFC'
    expect(page).to have_content('You have already reviewed this restaurant')
  end

  def sign_in(user)
    visit '/'
    click_link 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end
end
