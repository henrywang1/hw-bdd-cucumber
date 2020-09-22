# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(title: movie[:title], rating: movie[:rating], release_date: movie[:release_date])
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2. 
  #  page.body is the entire content of the page as a string.
  fail "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |is_uncheck, rating_list|
  rating_list.split(",").each do |rating|
    if is_uncheck == nil
      check("ratings[%s]" % rating.strip)
    else
      uncheck("ratings[%s]" % rating.strip)
    end
  end
end

When /I (un)?check all ratings/ do |is_uncheck|
    Movie.select(:rating).map(&:rating).uniq.each do |rating|
    if is_uncheck == nil
      check("ratings[%s]" % rating)
    else
      uncheck("ratings[%s]" % rating)
    end
  end
end

Then /I should (not )?see: (.*)$/ do |is_not, movies_list|
  movies = movies_list.split(',')
  movies.each do |movie|
    if is_not == nil
      expect(page).to have_content(movie.strip)
    else
      expect(page).not_to have_content(movie.strip)
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.select(:title).map(&:title).each do |movie|
    expect(page).to have_content(movie)
    expect(page).to have_xpath("//tr", count: 11)
  end
end
