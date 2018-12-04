

```bash
curl "https://api.heroku.com/apps/$APP_NAME/releases" \
   -H 'Authorization: Bearer xxxx' \
   -H 'Accept: application/vnd.heroku+json; version=3' \
   -H 'Content-Type: application/json' \
   -H 'Range: version ..; max=15, order=desc'

curl "https://api.heroku.com/apps/$APP_NAME/slugs/$SLUG_ID" \
 -H 'Authorization: Bearer xxxx' \
 -H 'Accept: application/vnd.heroku+json; version=3' \
 -H 'Content-Type: application/json'
 
 curl -o $APP_NAME-slug.tgz "url-to-file" 
 ```
