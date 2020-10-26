Person.destroy_all
Favorite.destroy_all
Movie.destroy_all
Job.destroy_all

Person.create(name: 'Benedict Cumberbatch', imdb_id: 'nm1212722')
Person.create(name: 'Colin Cumberbatch', imdb_id: 'nm0191772')
Person.create(name: 'Scott Cumberbatch', imdb_id: 'nm0191773')
Person.create(name: 'Joan Cumberbatch', imdb_id: 'nm10264868')

Movie.create(name: 'Meet the Cumberbatchs', imdb_id: 'tt0503336')
Movie.create(name: 'The VelociPastor', imdb_id: 'tt1843303')
Movie.create(name: 'Avengers Assemble', imdb_id: 'tt2455546')

Favorite.create(name: 'The VelociPastor', imdb_id: 'tt1843303')
Favorite.create(name: 'Benedict Cumberbatch', imdb_id: 'nm1212722')

Job.create(movie_id: Movie.all.first.id, person_id: Person.all.first.id)
