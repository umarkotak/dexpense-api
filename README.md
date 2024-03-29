# DEXPENSE

```
rails new dexpense --skip-bundle --api
```

## HEROKU

`https://devcenter.heroku.com/articles/getting-started-with-rails6`

heroku pg:backups:capture --app dexpense-api

heroku pg:backups:url b001 --app dexpense-api

pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump

## MAC INSTALLATION

```
rbenv install 2.7.2

bundle install --path vendor/bundle

// SET CONFIG DB

bin/rails db:migrage

make run
```

---

## MISC

bundle pristine pg

## RUN POSTGRESQL

https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart
```
sudo service postgresql start
```


## INSTALL ON UBUNTU

```
bundler exec spring binstub --all
```

## BACKUP AND RESTORE DB HEROKU

```
scp -i "~/.ssh/default.pem" latest.dump ubuntu@ec2-13-214-123-225.ap-southeast-1.compute.amazonaws.com:~
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U admin -d dexpense_development latest.dump
https://www.baeldung.com/linux/detach-process-from-terminal
```

## PRE-REQUISITES

```
install postgres
https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart

install rbenv
https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-20-04

install ruby

```
