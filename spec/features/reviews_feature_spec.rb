require 'rails_helper'

feature 'reviewing' do
  before { create :restaurant }
  let(:user) { build :user }
  let(:usertwo) { build(:user, email: 'test2@test.com') }

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
    2.times do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: 'so so'
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('You have already reviewed this restaurant')
  end

  scenario 'displays an average rating for all reviews' do
    sign_in(user)
    leave_review('So, so', '3')
    click_link 'Sign out'
    sign_in(usertwo)
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: 4')
  end

  scenario 'users can delete their reviews' do
    sign_in(user)
    leave_review('Food was terrible', '3')
    visit restaurants_path
    click_link 'Delete Review'
    expect(page).not_to have_content 'Food was terrible'
  end

  scenario 'users can delete only their own reviews' do
    sign_in(user)
    leave_review('Food was terrible', '3')
    click_link 'Sign out'
    sign_in(usertwo)
    visit restaurants_path
    click_link 'Delete Review'
    expect(page).to have_content 'Food was terrible'
  end

  def sign_in(user)
    visit '/'
    click_link 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def leave_review(thoughts, rating)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

end
