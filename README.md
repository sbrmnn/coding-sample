### Documentation of public endpoints:
  https://docs.monotto.com/reference
### Documentation of private endpoints begins here (monotto admin use only!):
Login
-----

**POST /monotto_users/login**
<br />
*Logging in as a user.*
<br />
<br />
> Request
``` 
  curl -v https://api.monotto.com/monotto_users/login.json
  -H "Content-Type:application/json" 
  -d '{
     "email": STRING,
     "password": STRING 
    }'
 ```
> Response

Error:
``` 
  { errors: [ { detail: "Error with your login or password" } ] } 
```
Success:
```
  { :token: <TOKEN> } 
```

Financial Institution
-----

**GET /monotto_users/financial_institutions**
<br />
*Gets all the financial institutions that are in the monotto system. You can also filter the 
response furthur by passing in optional parameter values.*
<br />
<br />
> Request
```
  curl -v -X GET https://api.monotto.com/monotto_users/financial_institutions\
  -H "Content-Type:application/json" \
  -H "Authorization: Token token=TOKEN"\
  -d '{
      "financial_institution": {
       "name": String (Optional)
       "location": String (Optional)
       "core" : String (Optional)
       "web": String (Optional)
       "mobile": String (Optional)
       "notes": Text (Optional)
       "relationship_manager": Text (Optional) 
       "max_transfer": Integer (Optional),
       "transfers_active": Boolean (Optional)
      }
   }'
```

> Response
```
  [
   {
    "id": Integer,
    "name": String, 
    "location": String,  
    "core": String, 
    "web": String, 
    "mobile": String, 
    "notes": Text,
    "relationship_manager": Text,
    "max_transfer": Integer,
    "transfers_active": Boolean,
   }
   {...}
  ]
```

**POST /monotto_users/financial_institutions**
</br>
*Creates a financial institution record with parameter values.*
</br>
</br>
> Request
```
  curl -v -X POST https://api.monotto.com/monotto_users/financial_institutions\
  -H "Content-Type:application/json" \
  -H "Authorization: Token token=TOKEN"\
  -d '{
      "financial_institution": {
       "name": String (Required)
       "location": String (Required)
       "core": String (Optional)
       "web": String (Optional)
       "mobile": String (Optional) 
       "notes": Text (Optional)
       "relationship_manager": Text (Optional)
       "max_transfer": Integer (Optional)
       "transfers_active": Boolean (Optional)
      }
   }'
```

> Response
```
  {
   "id": Integer
   "name": String, 
   "location": String,  
   "core" : String, 
   "web": String, 
   "mobile": String, 
   "notes": Text,
   "relationship_manager": Text,
   "max_transfer": Integer,
   "transfers_active": Boolean
  }
```

**GET /monotto_users/financial_institutions/:id**
</br>
*Retrieves information of the financial institution from the id specified in the path of the url.*
</br>
</br>
> Request
``` 
  curl -v -X POST https://api.monotto.com/monotto_users/financial_institutions/:id\
  -H "Content-Type:application/json" \
  -H "Authorization: Token token=TOKEN"
```
> Response
```
  {
   "id": Integer
   "name": String, 
   "location": String,  
   "core" : String, 
   "web": String, 
   "mobile": String, 
   "notes": Text,
   "relationship_manager": Text,
   "max_transfer": Integer,
   "transfers_active": Boolean
  }
```

**PUT /monotto_users/financial_institutions/:id**
</br>
*Updates information of the financial institution specified by the id in the path of the url.*
</br>
</br>
> Request
```

  curl -v -X PUT https://api.monotto.com/monotto_users/financial_institutions/:id\
  -H "Content-Type: application/json" \
  -H "Authorization: Token token=TOKEN"\
  -d '{
      "financial_institution": {
       "name": String (Optional),
       "location": String (Optional),
       "core": String (Optional),
       "web": String (Optional),
       "mobile": String (Optional), 
       "notes": Text (Optional),
       "relationship_manager": Text (Optional),
       "max_transfer": Integer (Optional),
       "transfers_active": Boolean (Optional)
      }
   }'
```
> Response
```

  {
   "id": Integer,
   "name": String, 
   "location": String,  
   "core" : String, 
   "web": String, 
   "mobile": String, 
   "notes": Text,
   "relationship_manager": Text,
   "max_transfer": Integer,
   "transfers_active": Boolean
  }
```

**DELETE /monotto_users/financial_institutions/:id**
</br>
*Deletes the financial instiution record that is specified by the id in the url.*
</br>
</br>
> Request
```
  curl -v -X DELETE https://api.monotto.com/monotto_users/financial_institutions/:id\
  -H "Content-Type:application/json"\
  -H "Authorization: Token token=TOKEN"
```
> Response
```

  {
   "id": Integer,
   "name": String, 
   "location": String,  
   "core" : String, 
   "web": String, 
   "mobile": String, 
   "notes": Text,
   "relationship_manager": Text,
   "max_transfer": Integer,
   "transfers_active": Boolean
  }
```
User
-----

**GET /monotto_users/users**
</br>
*Gets all the users that are in the monotto system. You can also filter the 
response furthur by passing in optional parameter values.*
</br>
</br>
> Request
```
  curl -v -X GET https://api.monotto.com/monotto_users/users\
  -H "Content-Type:application/json"\
  -H "Authorization: Token token=TOKEN"\ 
  -d '{
      "user": {
       "sequence": String (Optional),
       "bank_user_id": String (Optional),
       "savings_account_identifier": String (Optional),
       "checking_account_identifier": String (Optional),
       "transfers_active": Boolean (Optional), 
       "safety_net_active": Boolean (Optional),
       "financial_institution_id": Integer (Optional)
      }
     }'
```
> Response
```
  [
   {
    "id": Integer,
    "sequence": String (Optional),
    "bank_user_id": String (Optional),
    "savings_account_identifier": String (Optional),
    "checking_account_identifier": String (Optional),
    "transfers_active": Boolean (Optional), 
    "safety_net_active": Boolean (Optional),
    "financial_institution_id": Integer (Optional)
   },

   {...}
  ]
```

**POST /monotto_users/users**
</br>
*Creates a user record with parameter values.*
</br>
</br>
> Request
```
  curl -v -X POST https://api.monotto.com/monotto_users/users\
  -H "Content-Type:application/json"\
  -H "Authorization: Token token=TOKEN"\ 
  -d '{
      "user": {
       "sequence": String (Required),
       "bank_user_id": String (Required),
       "savings_account_identifier": String (Required),
       "checking_account_identifier": String (Required),
       "financial_institution_id": Integer (Required),
       "transfers_active": Boolean (Optional), 
       "safety_net_active": Boolean (Optional)
      }
     }'
```
 > Response
```
     {
       "id": Integer,
       "sequence": String (Required),
       "bank_user_id": String (Required),
       "savings_account_identifier": String (Required),
       "checking_account_identifier": String (Required),
       "financial_institution_id": Integer (Required),
       "transfers_active": Boolean (Optional), 
       "safety_net_active": Boolean (Optional)
     }
```

**GET /monotto_users/users/:id**
</br>
*Retrieves information of the user from the id specified in the path of the url.*
</br>
</br>
> Request
```
   curl -v -X GET https://api.monotto.com//monotto_users/users/:id\
   -H "Content-Type:application/json"\
   -H "Authorization: Token token=TOKEN"
```
> Response
```
  {
   "id": Integer,
   "sequence": String (Required),
   "bank_user_id": String (Required),
   "savings_account_identifier": String (Required),
   "checking_account_identifier": String (Required),
   "financial_institution_id": Integer (Required),
   "transfers_active": Boolean (Optional), 
   "safety_net_active": Boolean (Optional)
  }
```

**PUT /monotto_users/users/:id**
</br>
*Updates information of the user specified by the id in the path of the url.*
</br>
</br>
> Request
```
  curl -v -X PUT https://api.monotto.com/monotto_users/users/:id\
  -H "Content-Type:application/json" \
  -H "Authorization: Token token=TOKEN" \ 
  -d '{
      "user": {
       "sequence": String (Optional),
       "bank_user_id": String (Optional),
       "savings_account_identifier": String (Optional),
       "checking_account_identifier": String (Optional),
       "transfers_active": Boolean (Optional), 
       "safety_net_active": Boolean (Optional),
       "financial_institution_id": Integer (Optional)
      }
     }'
```
> Response
 ``` 
  {
   "id": Integer,
   "sequence": String (Required),
   "bank_user_id": String (Required),
   "savings_account_identifier": String (Required),
   "checking_account_identifier": String (Required),
   "financial_institution_id": Integer (Required),
   "transfers_active": Boolean (Optional), 
   "safety_net_active": Boolean (Optional)
  }
```

**DELETE /monotto_users/users/:id**
</br>
*Deletes the user record that is specified by the id in the url.*
</br>
</br>
> Request
``` 
  curl -v -X DELETE https://api.monotto.com/monotto_users/users/:id\
  -H "Content-Type:application/json"\
  -H "Authorization: Token token=TOKEN"
```
> Response
```
   {
   "id": Integer,
   "sequence": String (Required),
   "bank_user_id": String (Required),
   "savings_account_identifier": String (Required),
   "checking_account_identifier": String (Required),
   "financial_institution_id": Integer (Required),
   "transfers_active": Boolean (Optional), 
   "safety_net_active": Boolean (Optional)
  }
```

Goal
-----

**GET /monotto_users/goals**
</br>
*Gets all the goals that are in the monotto system. You can also filter the 
response furthur by passing in optional parameter values.*
</br>
</br>
> Request
```
  curl -v -X GET https://api.monotto.com/monotto_users/goals\ 
  -H "Content-Type:application/json" \
  -H "Authorization: Token token=TOKEN"\
  -d '{
      "goal": {
       "name": String (Optional),
       "priority": Integer (Optional),
       "amount": Integer (Optional),
       "completion" : Integer (Optional),
       "user_id": Integer (Optional),
       "tag": String (Optional)
      }
   }'
```
> Response
```
  [
     {
       "id": Integer,
       "name": String (Optional),
       "priority": Integer (Optional),
       "amount": Integer (Optional),
       "completion" : Integer (Optional),
       "user_id": Integer (Optional),
       "tag": String (Optional)
     }
     {...}
    ]
 ```

**POST /monotto_users/goals**
</br>
*Creates a goal record with parameter values.*
</br>
</br>
> Request
```
  curl -v -X POST https://api.monotto.com/monotto_users/goals\ 
  -H "Content-Type:application/json" \
  -H "Authorization: Token token=TOKEN"\
  -d '{
      "goal": {
       "name": String (Required),
       "priority": Integer (Required),
       "amount": Integer (Optional),
       "completion" : Integer (Optional),
       "user_id": Integer (Optional),
       "tag": String (Optional)
      }
   }
```
> Response
```
    {
     "id": Integer,
     "name": String (Required),
     "priority": Integer (Required),
     "amount": Integer (Optional),
     "completion" : Integer (Optional),
     "user_id": Integer (Optional),
     "tag": String (Optional)
    }
```

**GET /monotto_users/goals/:id**
</br>
*Retrieves information of a specific goal with the id specified in the path of the url.*
</br>
</br>
> Request
```
  curl -v -X GET https://api.monotto.com/monotto_users/monotto_users/goals/:id\
  -H "Content-Type:application/json"\
  -H "Authorization: Token token=TOKEN"
```

> Response
 ``` 
  {
   "id": Integer,
   "name": String,
   "priority": Integer,
   "amount": Integer,
   "completion": Integer,
   "user_id": Integer,
   "tag": String
  }
```
**PUT /monotto_users/goals/:id**
</br>
*Updates information of the goal specified by the id in the path of the url.*
</br>
</br>
> Request
```
  curl -v -X PUT https://api.monotto.com/monotto_users/goals/:id\
  -H "Content-Type: application/json"\
  -H "Authorization: Token token=TOKEN"\
  -d '{
      "goal": {
        "name": String (Optional),
        "priority": Integer (Optional),
        "amount": Integer (Optional),
        "completion": Integer (Optional),
        "user_id": Integer (Optional),
        "tag": String (Optional)
      }
   }'
 ```
> Response
```
  {
   "id": Integer,
   "name": String,
   "priority": Integer,
   "amount": Integer,
   "completion" : Integer,
   "user_id": Integer,
   "tag": String
  }
```

**DELETE /monotto_users/goals/:id**
</br>
*Deletes the goal that is specified by the id in the url.*
</br>
</br>
> Request
```
  curl -v -X DELETE https://api.monotto.com/monotto_users/goals/:id\
  -H "Content-Type: application/json"\
  -H "Authorization: Token token=TOKEN"
```
> Response
```
  {
   "id": Integer,
   "name": String,
   "priority": Integer,
   "amount": Integer,
   "completion" : Integer,
   "user_id": Integer,
   "tag": String
  }
 ```
Demographic
-----

**GET /monotto_users/demographics**
</br>
*Gets all the demographic information that are in the monotto system. You can also filter the 
response furthur by passing in optional parameter values.*
</br>
</br>
> Request
```
  curl -v -X GET https://api.monotto.com/monotto_users/demographics\
    -H "Content-Type:application/json"\
    -H "Authorization: Token token=TOKEN"\
    -d '{
        "demographic": {
          "user_id": Integer (Optional),
          "key": String (Optional),
          "value" : String (Optional)
        }
     }'
```
> Response
```
  [
    {
      "id": Integer,
      "user_id": Integer,
      "key": String,
      "value" : String
    }
   {...}
  ]
 ```
 
**POST /monotto_users/demographics**
</br>
*Creates a demographic record with parameter values.*
</br>
</br>
> Request
```
  curl -v -X POST https://api.monotto.com/monotto_users/demographics\
    -H "Content-Type:application/json" \
    -H "Authorization: Token token=TOKEN"\
    -d '{
        "demographic": {
          "user_id": Integer (Required),
          "key": String (Optional),
          "value" : String (Optional)
        }
     }'
```
> Response
```
  {
    "id": Integer,
    "user_id": Integer,
    "key": String,
    "value" : String
  }
```

**GET /monotto_users/demographics/:id**
</br>
*Retrieves information of the demographic record from the id specified in the path of the url.*
</br>
</br>
> Request
```
  curl -v -X POST https://api.monotto.com/monotto_users/demographics/:id\ 
    -H "Content-Type:application/json"\
    -H "Authorization: Token token=TOKEN"
```
> Response
```  
  {
    "id": Integer,
    "user_id": Integer (Optional),
    "key": String (Optional),
    "value" : String (Optional)
  }
```

**PUT /monotto_users/demographics/:id**
</br>
*Updates demographic record.*
</br>
</br>
> Request
```
  curl -v -X PUT https://api.monotto.com/monotto_users/demographics/:id\ 
    -H "Content-Type:application/json"\
    -H "Authorization: Token token=TOKEN"\
    -d '{
        "demographic": {
          "user_id": Integer (Optional),
          "key": String (Optional),
          "value" : String (Optional)
        }
     }'
```
> Response
```
  {
    "id": Integer,
    "user_id": Integer (Optional),
    "key": String (Optional),
    "value" : String (Optional)
  }
```

**DELETE /monotto_users/demographics/:id**
</br>
*Deletes the demograhic record that is specified by the id in the url.*
</br>
</br>
```
  curl -v -X DELETE https://api.monotto.com/monotto_users/demographics/:id 
    -H "Content-Type:application/json"\
    -H "Authorization: Token token=TOKEN"
```
> Response
``` 
  {
    "id": Integer,
    "user_id": Integer,
    "key": String,
    "value" : String
  }
```


Bank Admin
-----

**GET /monotto_users/bank_admins**
</br>
*Gets all the bank admins that are in the monotto system. You can also filter the 
  response furthur by passing in optional parameter values.*
</br>
</br>
> Request
``` 
  curl -v -X GET https://api.monotto.com/monotto_users/bank_admins\
  -H "Content-Type:application/json" \
  -H "Authorization: Token token=TOKEN"\
  -d '{
      "bank_admin": {
       "financial_institution_id": String,
       "email" : String, 
       "name" :  String,
       "title" : String, 
       "phone" : String, 
       "notes":  String, 
       "is_primary" : Boolean, 
       "password" : String
      }
   }'
```
> Response
```
      [
        {
         "id": Integer,
         "financial_institution_id": String (Required),
         "email" : String, 
         "name" :  String,
         "title" : String, 
         "phone" : String, 
         "notes":  String, 
         "is_primary" : Boolean (Default: False), 
         "password" : String
        },
        {...}
      ]
 ```

**POST /monotto_users/bank_admins**
</br>
*Creates bank admin record with parameter values.*
</br>
</br>
> Request
```
  curl -v -X POST https://api.monotto.com/monotto_users/bank_admins\
  -H "Content-Type:application/json" \
  -H "Authorization: Token token=TOKEN"\
  -d '{
      "bank_admin": {
       "financial_institution_id": String (Required),
       "email" : String, 
       "name" :  String (Required),
       "title" : String (Required), 
       "phone" : String (Required), 
       "notes":  String, 
       "is_primary" : Boolean (Default: False), 
       "password" : String
      }
   }'
```
> Response
```
    {
       "id": Integer,
       "financial_institution_id": String (Required),
       "email" : String, 
       "name" :  String (Required),
       "title" : String (Required), 
       "phone" : String (Required), 
       "notes":  String, 
       "is_primary" : Boolean (Default: False), 
       "password" : String
    }
```

**GET /monotto_users/bank_admins/:id**
</br>
*Gets bank admin specified by id in url path.*
</br>
</br>
> Request
``` 
   curl -v -X GET https://api.monotto.com/monotto_users/bank_admins/:id\
   -H "Content-Type:application/json" \
   -H "Authorization: Token token=TOKEN"
```
>Response
```
     {
       "id": Integer,
       "financial_institution_id": String (Required),
       "email" : String, 
       "name" :  String (Required),
       "title" : String (Required), 
       "phone" : String (Required), 
       "notes":  String, 
       "is_primary" : Boolean (Default: False), 
       "password" : String
    }
```
**PUT /monotto_users/bank_admins/:id**
</br>
*Updates bank admin record.*
</br>
</br>
> Request
```
 
 * Request
  
  curl -v -X PUT https://api.monotto.com/monotto_users/bank_admins/:id\
  -H "Content-Type:application/json" \
  -H "Authorization: Token token=TOKEN"\
  -d '{
      "bank_admin": {
       "financial_institution_id": String,
       "email" : String, 
       "name" :  String,
       "title" : String, 
       "phone" : String, 
       "notes":  String, 
       "is_primary" : Boolean, 
       "password" : String
      }
   }'
 ```
> Response
 ```  
   {
       "id": Integer,
       "financial_institution_id": String,
       "email" : String, 
       "name" :  String,
       "title" : String, 
       "phone" : String, 
       "notes":  String, 
       "is_primary" : Boolean, 
       "password_digest" : String
    }
```

**DELETE /monotto_users/bank_admins/:id**
</br>
*Deletes the bank admin record that is specified by the id in the url.*
</br>
</br>
> Request
```
  curl -v -X DELETE https://api.monotto.com/monotto_users/bank_admins/:id\
  -H "Content-Type:application/json"\
  -H "Authorization: Token token=TOKEN"
```
> Response
```
   {
       "id": Integer,
       "financial_institution_id": String,
       "email" : String, 
       "name" :  String,
       "title" : String, 
       "phone" : String, 
       "notes":  String, 
       "is_primary" : Boolean, 
       "password_digest" : String
   }
```
