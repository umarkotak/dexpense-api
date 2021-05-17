# API

## USERS

### POST /accounts/register

request header

request body
```
{
  "name": "umar",
  "password": "umar",
  "password_confirmation": "umar",
  "email": "umarkotak@gmail.com"
}
```

response body
```
{
  "success": true,
  "error": "",
  "data": {
    "name": "umar"
  }
}
```

### POST /accounts/login

request header

request body
```
{
  "email": "umarkotak@gmail.com",
  "password": "umar"
}
```

response body
```
{
  "success": true,
  "error": "",
  "data": {
    "authorization_token": "Bearer xxx"
  }
}
```

### GET /accounts/profile

request header

  - Authorization: "Bearer xxx"

request body

response body
```
{
  "success": true,
  "error": "",
  "data": {
    "name": "umar",
    "email": "umarkotak@gmail.com"
  }
}
```

### POST /groups/:id/invite

request header

  - Authorization: "Bearer xxx"

request body
```
{
  "email": "invited.email@gmail.com"
}
```

response body
```
{
  "success": true,
  "error": "",
  "data": {
    "email": "invited.email@gmail.com"
  }
}
```

### POST /transactions

request header

  - Authorization: "Bearer xxx"

request body
```
{
  "category": "food",
  "amounnt": 5000,
  "direction_type": "income/outcome",
  "wallet_id": 1,
  "transaction_at": "2020-01-01T01:01:01Z",
  "name": "bakso pakde",
  "description": "bakso 2; mie ayam 2",
  "note": "beli buat bukber"
}
```

response body
```
{
  "success": true,
  "error": "",
  "data": {
    "id": 1
  }
}
```

### GET /transactions

request header

  - Authorization: "Bearer xxx"

request body

response body
```
{
  "success": true,
  "error": "",
  "data": [
    {
      "category": "food",
      "amounnt": 5000,
      "direction_type": "income/outcome",
      "wallet_id": 1,
      "transaction_at": "2020-01-01T01:01:01Z",
      "name": "bakso pakde",
      "description": "bakso 2; mie ayam 2",
      "note": "beli buat bukber",
      "created_at": "2020-01-01T01:01:01Z",
      "updated_at": "2020-01-01T01:01:01Z"
    }
  ]
}
```
