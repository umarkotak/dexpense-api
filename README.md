# DEXPENSE

```
rails new dexpense --skip-bundle --api
```

## HEROKU

`https://devcenter.heroku.com/articles/getting-started-with-rails6`

heroku pg:backups:capture --app dexpense-api

heroku pg:backups:url b001 --app dexpense-api

pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump

---

## MISC

bundle pristine pg
