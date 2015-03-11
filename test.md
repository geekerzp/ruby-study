FORMAT: 1A

HOST: https://api.chino.io/v1/


# CHINO 

# Introduction

CHINO provides a set of API to securely *store* privacy sensitive data of your applications and users.

CHINO API is built by developers for developers to simplify their life. It is based on RESTful principles and aims at providing great user experience. 

If you notice anything that is against our objectives, please tell it to us at info@chino.io.


## Supported Resources

CHINO REST API is build around the following 5 *main* resources:
- `User` is a person associated with a specific CHINO customer who can accesso to API (based on its access rights).
- `Group` cluster of users having the same access rights.
- `Repository` organizes data and are meant to simplify access rights management (i.e. through permissions assigned to *Groups* and *Users* )
- `Schema` describes a document's content by listing all the *fields* contained in a *Document*. A *schema* is used also to index documents based on their structure and to allow users to search over documents. 
- `Document` contains the actual data. Documents are associated to a *schema* and are in JSON format. Documents can also embed other representations (e.g. XML or HL7) within their fields. Max size of a doc is 10MB.
- `BLOB` (still a work in progress) is used to store large files (up to 100MB). To facilitate *BLOB* retrieval a user should save for each *BLOB* a corresponding *document* containing metadata about the *BLOB* and therefore having its own *schema*.

## Offered API

For each resource CHINO offers a series of `CRUDA` operations following RESTful conventions. API are available at: `https://api.chino.io/v1/`. 

### Supported HTTPS requests:
The RESTful operations over defined resources support the following HTTP methods:
- `GET` - Retrieves a resource or list of resources
- `POST` - Creates a resource
- `PUT` - Updates a resource
- `DELETE` - Delete a resource

CHINO uses URL encoding for GET operations and `application/json` econding for the other operations. 

### Supported Server Responses
Responses leverage the following subset of standard HTTP status codes:
- `200 - OK`, the request was successful.
- `201 - Created`, the request was successful and a resource was created.
- `400 - Bad Request`, the request could not be understood or was missing required parameters.
- `401 - Unauthorized`, authentication failed, please login correctly.
- `403 - Forbidden`, access denied to the requested resource due to the lack of priviledges.
- `404 - Not Found`, resource was not found.
- `500 - Internal Server Error`, something wrong happened on the server. Please try again later and (possibly) report the accident to us.
- `503 - Service Unavailable`, the service is temporary unavailable. Try again later. 

<!-- `429 - Too Many Requests`, exceeded CHINO API limits. Please pause requests, wait one minute, and try again. -->

## Example requests & responses
In the following we show some examples of requests and responses. 

To show some API call examples we use the following example values:
- `<Access-Token>` : `hgQ3rgkxLcbE7KR`
- `<Customer-Id>` : `345e8400-rt34-sg45-xad3-222255440245`
- `<Customer-Key>` : `550e8400-e29b-41d4-a716-446655440000 `


### Request example of a GET of a user
An example of a `GET` User operation:

```[JSON]
curl    -X GET 
        -u <Customer-Id>:<Customer-Key>"
        https://api.chino.io/v1/users/4ee2ba4a-a934-4239-b7b6-e52f31142b81
```
### Request example POST
An example of a `POST` User operation (PS. add backslashes):

```[JSON]
curl  -X POST 
      -u <Customer-Id>:<Customer-Key>"
      -d "{
            "username": "john",
            "password": "pswjohn",
            "is_active": true,
            "attributes": {
                "first_name":  "John",
                "last_name": "Doe",
                "email": "john@acme.com
            }
        }"
  https://api.chino.io/v1/users/
``` 

### Response example
A response message looks like this:

```[JSON]
{
    "result": "success",
    "result_code": 200,
    "message": null,
    "data": {
        "user": {
            "username": "james",
            "user_id": "d88084ef-b6f7-405d-9863-d35b99543389",
            "insert_date": "2015-02-05T10:53:38.157",
            "last_update": "2015-02-05T10:53:38.157",
            "is_active": true,
            "attributes": {
                "first_name":  "James",
                "last_name": "Ford",
                "email": "james@acme.com
            },
            "groups": [ ]
        }
    }
}

```
Note that the `attributes` node can contain any set of data, giving more flexibility to the `User` resource.

### Error response example
```[JSON]
{
    "result": "error",
    "result_code": 404,
    "message": "Document not found",
    "data": null
}
```
Error messages leverage the standard HTTP status codes and in addition gives a message to developers to better understand what went wrong.

## Security
CHINO API uses always SSL. No exceptions. This guarantees encrypted communications and simplifies authentication schema. 

The following describes how the two categories of users can access to API.

#### Application developers
App developers or admins can use their `<Customer-id>` and `<Customer-key>` pair within each API call to access as administrators to each resource. In particular they can create Repositories, Users, Groups and Schemas.
`<Customer-Key>` has infinite lifespan and is managed (created and invalidated) from the [user profile page](https://www.chino.io/console). 

> NOTE: Store this uuid in a safe place and do not share it with anyone, since it does not expire.


#### Application users
Users use their username and password to authenticate, in addition to the `<Customer-id>` which identifies the appliacation they are using. The `<Customer-id>` can be encoded within the app since it's not secret.
On successfull authentication they will get a simple `<Access-Token>` that will be carried on within HTTP Basic authentication header.
`Access-Token` has a `lifespan` of 30 minutes. Once it is expired, it needs to be renewed.


### Permissions management
Permissions can be managed by issuing `CRUD` - `Create, Read, Update, Delete` access rights to *Groups* or single *Users* over a resource (*Repository*, *Schema* or *Document*). 


# Group Authentication
API that allows users to login, logout or to get info about his account.

## /auth/login
Allows a user to login and to get a valid `Access-Token`.

### Login [POST]
+ Request (form/multi-part)

    + Headers
            
            
    + Body

            { 
                "username": "jack_sh",
                "password": "jack_password",
                "customer_id": "<Customer-id>"
            }

    
+ Response 200 (application/json)

    + Body

            [{
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "user": {
                        "access_token": "bddddee5-f2ff-439a-a19d-601b46fb8e63",
                        "username": "jack_sh",
                        "user_id": "0e600eb0-921d-4682-92bf-857874c6ce54",
                        "expires_in": 1800
                    }
                }
            }]
            
+ Response 401 (application/json)
In case of wrong username/password/<Customer-id>:

    + Body

            {
                "message": "Your username and/or password were incorrect",
                "result": "error",
                "result_code": 401,
                "data": null
            }


## /auth/logout
Logout invalidating the `Access-Token`.

### Logout [POST]

+ Request (application/json)

    + Headers
    
            Authorization:  Token <Access-Token>

    + Body
    
+ Response 200 (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "logout": {
                        "username": "jack_sh",
                        "user_id": "0e600eb0-921d-4682-92bf-857874c6ce54"
                    }
                }
            }

## /auth/info
Renews the token for the user.

### Get Info [GET]
+ Request (application/json)

    + Headers
    
            Authorization:  Token <Access-Token>
            
    + Body


+ Response 200 (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "user": {
                        "username": "jack_sh",
                        "user_id": "0e600eb0-921d-4682-92bf-857874c6ce54",
                        "insert_date": "2015-02-23T10:52:20.371",
                        "groups": [ ],
                        "attributes": {
                            "first_name": "Jack",
                            "last_name": "Sheppard",
                            "email": "jack@chino.io"
                        },
                        "last_update": "2015-02-23T10:52:20.372",
                        "is_active": true
                    }
                }
            }
 



#Group Users
User API allows an application to create, retrieve, update, delete a `User` object. 

## /users

### List all Users [GET]
List of all the users that were created by the application

+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
            
+ Response 200 (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "count": 100,
                    "total_count": 122,
                    "limit": 100,
                    "offset": 0,
                    "users": [
                        {
                            "username": "kate",
                            "user_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                            "insert_date": "2015-02-23T17:06:18.402",
                            "last_update": "2015-02-23T17:06:18.402",
                            "is_active": true,
                            "attributes": { 
                                "first_name": "Kate",
                                "last_name": "Austen",
                                "email": "kate@email.com"
                            },
                            "groups": [ 
                                {
                                    "group_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                                    "groupname": "Patient"
                                }
                            ]
                        },
                        {
                            "username": "jack_sh",
                            "user_id": "a96994ed-2587-41e7-bf55-d2cd56053171",
                            "insert_date": "2015-02-23T17:01:26.369",
                            "last_update": "2015-02-23T17:01:26.369",
                            "is_active": true,
                            "attributes": { 
                                "first_name": "Jack",
                                "last_name": "Shephard",
                                "email": "jack@physicians.com"
                            },
                            "groups": [ 
                                {
                                    "group_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                                    "groupname": "Physicians"
                                }
                            ]
                        }
                    ]
                }
            }
            

### Create a User [POST]
Create `User` API requires username and password and accepts any additional information the users provides.  

+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
    
    + Body

            {
                "username": "james",
                "password": "jamespsw",
                "is_active": true,
                "attributes": {
                    "first_name":  "James",
                    "last_name": "Ford",
                    "email": "james@acme.com"
                }
            }

+ Response 200 (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "user": {
                        "username": "james",
                        "user_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                        "insert_date": "2015-02-05T10:53:38.157",
                        "last_update": "2015-02-05T10:53:38.157",
                        "is_active": true,
                        "attributes": {
                            "first_name":  "James",
                            "last_name": "Ford",
                            "email": "james@acme.com"
                        },
                        "groups": [ ]
                    }
                }
            }


## /users/{user_id}
This API manages and updates user info.

+ Parameters
    + user_id (required, string, `d88084ef-b6f7-405d-9863-d35b99543389`) ... String `id` of the User to perform action with. Has example value.

### Retrieve a User [GET]
+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
            
+ Response 200 (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "user": {
                        "username": "james",
                        "user_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                        "insert_date": "2015-02-05T10:53:38.157",
                        "last_update": "2015-02-05T10:53:38.157",
                        "is_active": true,
                        "attributes": {
                            "first_name":  "James",
                            "last_name": "Ford",
                            "email": "james@acme.com"
                        },
                        "groups": [ ]
                    }
                }
            }
        
### Update a User [PUT]
Update an user by providing the info that will be updated.

+ Request (application/json)

    + Headers
            
            Authorization:  Token <Access-Token> | <Customer-Id>:<Customer-Key>
            
    + Body

            {
                "username": "james",
                "password": "jamesstrongerpsw",
                "is_active": true,
                "attributes": {
                    "first_name": "James",
                    "last_name": "Ford",
                    "email": "james@acme.com"
                }
            }
            
+ Response 200 (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "user": {
                        "username": "james",
                        "user_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                        "insert_date": "2015-02-05T10:53:38.157",
                        "last_update": "2015-02-05T10:53:38.157",
                        "is_active": true,
                        "attributes": {
                            "first_name":  "James",
                            "last_name": "Ford",
                            "email": "james@acme.com"
                        },
                        "groups": [ ]
                    }
                }
            }


### Delete a User [DELETE]
Deletes a `User` from the application. 

+ Request (application/json)

    + Headers
    
            Authorization:  Token <Access-Token> | <Customer-Id>:<Customer-Key>
            
+ Response 200

    + Body

            {
                "result": "success",
                "result_code": 200,
                "data": null,
                "message": null
            }
            

# Group Groups
User API allows an application to create, retrieve, update, delete a `Group` only by admins (i.e. by using the pair `<Customer-Id>`:`<Customer-Key>`). 

## /groups

### List all Groups [GET]
List of all the groups that were created by the application

+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
            
+ Response 200 (application/json)

    + Body

            {
                "groups":[
                    {
                        "group_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                        "groupname": "Physicians",
                        "creation_date": "2014-01-01 00:00:000",
                        "users_count": 1,
                        "users": [
                            {
                                "user_id": "<uuid2>",
                                "username": "jack"
                            }
                        ]
                    },
                    {
                        "group_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                        "groupname": "Patients",
                        "creation_date": "2014-01-01 00:00:000",
                        "users_count": 2,
                        "users": [
                            {
                                "user_id": "<uuid4>",
                                "username": "kate"
                            },
                            {
                                "user_id": "<uuid5>",
                                "username": "james"
                            }
                        ]
                    }
               ],
               "total": 2,
               "offset": 0,
               "limit": 10
            }

### Create a Group [POST]
Create `Group` API requires username and password and accepts any additional information the users provides.  

+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
    
    + Body

            {
                "groupname": "Physicians"
            }

+ Response 200 (application/json)

    + Body

            {
                "group_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                "groupname": "Physicians",
                "creation_date": "2014-01-01 00:00:000",
                "users_count": 0,
                "users": []
            }
            
            
## /groups/{group_id}
This API manages and updates user info.

+ Parameters
    + group_id (required, string, `d88084ef-b6f7-405d-9863-d35b99543389`) ... String `id` of the Group to perform action with.

### Retrieve a Group [GET]
+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
            
+ Response 200 (application/json)

    + Body

            {
                "group_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                "groupname": "Physicians",
                "creation_date": "2014-01-01 00:00:000",
                "users_count": 0,
                "users": []
            }
            
### Update a Group [PUT]
Update an group by providing the info that will be updated.

+ Request (application/json)

    + Headers
            
            Authorization:  <Customer-Id>:<Customer-Key>
            
    + Body

            {
                "group_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                "groupname": "Physicians of hospital XY"
            }
            
+ Response 200 (application/json)

    + Body

            {
                "group_id": "d88084ef-b6f7-405d-9863-d35b99543389",
                "groupname": "Physicians of hospital XY",
                "creation_date": "2014-01-01 00:00:000",
                "users": []
            }
            
### Remove a Group [DELETE]
Deletes a `Group` from the application. 

+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
            
+ Response 200



## /groups/{group_id}/users/{user_id}
Manage Group memberships.

+ Parameters
    + group_id (required, string, `d88084ef-b6f7-405d-9863-d35b99543389`) ... String `id` of the Group to perform action with.
    + user_id (required, string, `d88084ef-b6f7-405d-9863-d35b99543389`) ... String `id` of the User to add or remove.

### Add a User to Group [POST]
Adds the `user_id` to the `group_id`

+ Request (application/json)

    + Headers
            
            Authorization:  <Customer-Id>:<Customer-Key>
            
    + Body
    

+ Response 200 (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": null
            }

### Remove a User from a Group [DELETE]
Deletes the `User` from a `Gropu`. 

+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
            
    + Body
            
+ Response 200 (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "data": null,
                "message": null
            }



#Group Permissions
Permissions API allows an application to manage permissions and access rights for `Groups` and `Users` to resources (i.e. `Repositories`, `Schemas` or types of documents or single `Documents` or `BLOBs`). 

## /perms/users/{user_id}
Retrieves the list of all permissions that a specific `User` has on different resources.

+ Parameters
    + user_id (required, string, `d88084ef-b6f7-405d-9863-d35b99543389`) ... String `id` of the User.

### Retrieve permissions of a User [GET]
+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
            
+ Response 200 (application/json)

    + Body

            {
               "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "permissions": [
                        {
                            "resource_id":"3ddba8af-6965-4416-9c5c-acf6af95539d",
                            "schema_id":"b1cc4a53-19a1-4819-a8c7-20bf153ec9cf",
                            "group_id":"3ddba8af-6965-4416-9c5c-acf6af95539d",
                            "user_id":"b1cc4a53-19a1-4819-a8c7-20bf153ec9cf",
                            "permission": {
                                "insert": true,
                                "all_data": {
                                    "read": true,
                                    "update": false,
                                    "delete": true
                                },
                                "own_data": {
                                    "read": true,
                                    "update": true,
                                    "delete": false
                                }
                            }
                        }
                    ]
                }
            }
        

## /perms/groups/{group_id}
Retrieves the list of all permissions that a specific `Group` has on different resources.

+ Parameters
    + group_id (required, string, `d88084ef-b6f7-405d-9863-d35b99543389`) ... String `id` of the Group.

### Retrieve Permissions of a Group [GET]
+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
            
+ Response 200 (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "permissions": [
                        {
                            "resource_id":"3ddba8af-6965-4416-9c5c-acf6af95539d",
                            "schema_id":"b1cc4a53-19a1-4819-a8c7-20bf153ec9cf",
                            "group_id":"3ddba8af-6965-4416-9c5c-acf6af95539d",
                            "user_id":"b1cc4a53-19a1-4819-a8c7-20bf153ec9cf",
                            "permission": {
                                "insert": true,
                                "all_data": {
                                    "read": true,
                                    "update": false,
                                    "delete": true
                                },
                                "own_data": {
                                    "read": true,
                                    "update": true,
                                    "delete": false
                                }
                            }
                        }
                    ]
                }
            }



## /perms/schemas/{schema_id}

### Get permissions on a Schema [GET]
Retrieves permissions for each Group and User for specified Schema

+ Paramenters
    + schema_id (required, string, `d88084ef-b6f7-405d-9863-d35b99543389`) ... String `id` of the *Schema*.
    

+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
            
+ Response 200 (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "users": [
                        {
                            "user": "7ec71b83-a5f0-4b0c-ace1-aa42d73b59f9",
                            "permissions": [
                                {
                                    "repository_id": "3ddba8af-6965-4416-9c5c-acf6af95539d",
                                    "schema_id": "b1cc4a53-19a1-4819-a8c7-20bf153ec9cf",
                                    "group_id": null,
                                    "user_id": "7ec71b83-a5f0-4b0c-ace1-aa42d73b59f9",
                                    "permission": {
                                        "insert": true,
                                        "all_data": {
                                            "read": true,
                                            "update": false,
                                            "delete": false
                                        },
                                        "own_data": {
                                            "read": true,
                                            "update": true,
                                            "delete": true
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            "user": "0e600eb0-921d-4682-92bf-857874c6ce54",
                            "permissions": [
                                {
                                    "repository_id": "3ddba8af-6965-4416-9c5c-acf6af95539d",
                                    "schema_id": "b1cc4a53-19a1-4819-a8c7-20bf153ec9cf",
                                    "group_id": null,
                                    "user_id": "0e600eb0-921d-4682-92bf-857874c6ce54",
                                    "permission": {
                                        "insert": false,
                                        "all_data": {
                                            "read": false,
                                            "update": false,
                                            "delete": false
                                        },
                                        "own_data": {
                                            "read": false,
                                            "update": false,
                                            "delete": false
                                        }
                                    }
                                }
                            ]
                        }
                    ],
                    "groups": [
                        {
                            "group": "77de01d8-492d-4cc2-a2b2-d3e76edc0657",
                            "permissions": [
                                {
                                    "repository_id": "3ddba8af-6965-4416-9c5c-acf6af95539d",
                                    "schema_id": "b1cc4a53-19a1-4819-a8c7-20bf153ec9cf",
                                    "group_id": "77de01d8-492d-4cc2-a2b2-d3e76edc0657",
                                    "user_id": null,
                                    "permission": {
                                        "insert": true,
                                        "all_data": {
                                            "read": true,
                                            "update": false,
                                            "delete": true
                                        },
                                        "own_data": {
                                            "read": true,
                                            "update": true,
                                            "delete": false
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            }
            


## /perms/schema/{schema_id}/users/{user_id}

### Grant permissions to a User on a Schema [POST]
Give specific access rights to a User for a Resource for a specified period of time. It is used also to `Update` permissions (instead of using PUT).

+ Parameters
    + user_id (required, string, `d88084ef-b6f7-405d-9863-d35b99543389`) ... String `id` of the *User*.
    + schema_id (required, string, `d88084ef-b6f7-405d-9863-d35b99543389`) ... String `id` of the *Schema*.

+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
    
    + Body
    

            {
                "permissions": {
                    "insert": true,
                    "all_data": {
                        "read": true,
                        "update": false,
                        "delete": true
                    },
                    "own_data": {
                        "read": true,
                        "update": true,
                        "delete": false
                    }
                }
            }
    

            
+ Response 200 (application/json)

    + Body
           

            {
                "result": "success",
                "result_code": 200,
                "message": null,
                "data": {
                    "permissions": [
                        {
                            "repository_id": "3ddba8af-6965-4416-9c5c-acf6af95539d",
                            "schema_id": "75f07ab4-24b6-419f-88cb-5dbc46d39fce",
                            "group_id": null,
                            "user_id": "79d743c0-c199-45f8-9477-b4898710742d",
                            "permission": {
                                "insert": true,
                                "all_data": {
                                    "read": true,
                                    "update": false,
                                    "delete": true
                                },
                                "own_data": {
                                    "read": true,
                                    "update": true,
                                    "delete": false
                                }
                            }
                        }
                    ]
                }
            }

              
### Delete a Permission [DELETE]
Deltets  a Permission

+ Request (application/json)

    + Headers
    
            Authorization:  <Customer-Id>:<Customer-Key>
            
            
+ Response 200  (application/json)

    + Body

            {
                "result": "success",
                "result_code": 200,
                "data": null,
                "message": null
            }


