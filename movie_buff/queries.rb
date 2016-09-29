# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#  id          :integer      not null, primary key
#  movie_id    :integer      not null
#  actor_id    :integer      not null
#  ord         :integer


def movie_names_before_1940
  # Find all the movies made before 1940. Show the id, title, and year.
  Movie
    .select("id, title, yr")
    .where("yr < 1940")
end

def eighties_b_movies
	# List all the movies from 1980-1989 with scores falling between 3 and 5 (inclusive). Show the id, title, year, and score.
  Movie
    .select("id, title, yr, score")
    .where("(score BETWEEN 3 AND 5) AND (yr BETWEEN 1980 AND 1989)")
end

def vanity_projects
  # List the title of all movies in which the director also appeared as the starring actor. Show the movie id and title and director's name.
  Movie.find_by_sql(<<-SQL)
    WITH starring_actors as (
      SELECT c.movie_id, c.actor_id, a.name
      FROM castings c
      JOIN actors a on c.actor_id = a.id
      WHERE ord = 1
    )

    SELECT m.id, m.title, sa.name
    FROM movies m
    JOIN starring_actors sa on m.id = sa.movie_id
    WHERE sa.actor_id = m.director_id
  SQL
  # Note: Directors appear in the 'actors' table.

end

def starring(whazzername)
	# Find the movies with an actor who had a name like `whazzername`.
	# A name is like whazzername if the actor's name contains all of the letters in whazzername, ignoring case, in order.
  whazzername = whazzername.downcase.split("")
	# ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but not like "stallone sylvester" or "zylvester ztallone"
  actors = Actor.all.includes(:movies)
  #Create an array of names that work
  movies = []
  actors.each do |actor|
    index = 0
    actor_name = actor.name.downcase.split("")
    actor_name.each do |letter|
      next if index == whazzername.length
      if letter == whazzername[index]
        index += 1
      end
    end
    movies.concat(actor.movies.map{|l| l}) if index == whazzername.length
  end
  movies
end

def bad_years
  # List the years in which a movie with a rating above 8 was not released.
  movies = Movie.find_by_sql(<<-SQL)
      SELECT yr, count(case when score > 8 then id else null end) as count
      FROM movies
      GROUP BY 1
    SQL
  movies.select{ |t| t.count == 0 }.map{ |t| t.yr }
end

def golden_age
	# Find the decade with the highest average movie score.

end

def cast_list(title)
  # List all the actors for a particular movie, given the title.  Sort the results by starring order (ord).

end

def costars(name)
  # List the names of the actors that the named actor has ever appeared with.

end

def most_supportive
  # Find the two actors with the largest number of non-starring roles. Show each actor's id, name and number of supporting roles.

end

def what_was_that_one_with(those_actors)
	# Find the movies starring all `those_actors` (an array of actor names). Show each movie's title and id.

end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie

end

def longest_career
	#Find the actor and list all the movies of the actor who had the longest career (the greatest time between first and last movie).

end
