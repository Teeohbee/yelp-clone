require 'rails_helper'
require 'support/factory_girl'

describe Restaurant, type: :model do

  it { should belong_to(:user) }

  it { should have_many(:reviews).dependent(:destroy) }

  it { should validate_length_of(:name).is_at_least(3) }

  it { should validate_uniqueness_of(:name) }

  it { should validate_presence_of(:user) }

  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: "kf")
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it "is not valid unless it has a unique name" do
    user = create :user
    user.restaurants.create(name: "ABC")
    restaurant = user.restaurants.new(name: "ABC")
    expect(restaurant).to have(1).error_on(:name)
  end

  describe '#average_rating' do
    context 'no reviws' do
      it 'returns "N/A" when there are no reviews' do
        user = create :user
        restaurant = user.restaurants.create(name: 'The Ivy')
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context '1 review' do
      it 'returns that rating' do
        user = create :user
        restaurant = user.restaurants.create(name: 'The Ivy')
        restaurant.reviews.create(rating: 4)
        expect(restaurant.average_rating).to eq 4
      end
    end
  end
end
