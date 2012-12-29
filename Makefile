prepare_testing:
	cd spec/dummy && RAILS_ENV='test' bundle exec rake db:drop
	cd spec/dummy && RAILS_ENV='test' bundle exec rake db:create
	cd spec/dummy && RAILS_ENV='test' bundle exec rake db:migrate
	cd spec/dummy && RAILS_ENV='test' bundle exec rake db:seed
