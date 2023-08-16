module ProductsHelper

def render_stars(rating)
  full_stars = rating.to_i
  half_star = rating.to_f % 1 >= 0.5
  empty_stars = 5 - full_stars - (half_star ? 1 : 0)

  stars = ""

  full_stars.times do
    stars += '<i class="fas fa-star"></i>'
  end

  if half_star
    stars += '<i class="fas fa-star-half-alt"></i>'
  end

  empty_stars.times do
    stars += '<i class="far fa-star"></i>'
  end

  stars.html_safe
end


end
