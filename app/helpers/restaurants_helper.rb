module RestaurantsHelper
  def restaurant_params
    params.require(:restaurant).permit(:name)
  end
end
