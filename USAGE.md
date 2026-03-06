# How to query DAR API

1. Get session cookie from logged in browser session
2. Query it using the examples below 

Instead of using session cookie you can
[create an access token](https://dar.elter-ri.eu/account/settings/applications/tokens/new/)
in eLTER DAR and use `-H "Authorization: Bearer ${ACCESS_TOKEN}"` for authorization.

# Query all drafts

```shell
curl "https://dar.elter-ri.eu/api/requests/?page=1&size=250" -H "Cookie: session=XXXXXXXX" | \
  jq -r ".hits.hits[] | [.title, .topic.datasets_draft] | @csv"
```
## filter submitted drafts

```shell
curl "https://dar.elter-ri.eu/api/requests/?page=1&size=25&status=submitted" -H "Cookie: session=YYYYYYY" |   \
  jq -r ".hits.hits[] | [.title, .topic.datasets_draft] | @csv"
```

```shell
for i in {1..250} ; do
  curl "https://dar.elter-ri.eu/api/requests/?page=${i}&size=1&status=submitted" -H "Cookie: session=YYYYYYY" |   \
    jq -r ".hits.hits[] | [.title, .topic.datasets_draft] | @csv"
done
```

```shell
for i in {1..250} ; do
  curl "https://dar.elter-ri.eu/api/requests/?page=${i}&size=1&status=submitted" -H "Cookie: session=YYYYYYY" | \
    jq -r ".hits.hits[] | [.title, .topic.datasets_draft] | @csv"
done > dar-requests-drafts-response.csv
```