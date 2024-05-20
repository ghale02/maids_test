# the clean architecture

I used in this project the clean architecture and its principles.

this architecture contains 3 layers basically:

## data layer

which contains:

* **models:** a raw presentation of data
* **data sources:** the data access objects
* **repositories implementation:** wish convert raw data(models) to entities

## domain layer

which contains:

* **use cases:** the use cases where the business logic lives
* **entities:** the entities the objects that the project interact with and manipulate
* **repositories:** the abstraction of the repos classes

## presentation layer

which contains:

* **views:** the ui that the user interacts with
* **presentation logic:** the state management of the ui

### what I use in the project

* bloc for state management
* http for network requests
* sqflite for data persistence(caching)
* mocktail to mock the dependencies
* [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) to store data in the device with encryption

### problems I faces

* 1 - the dummy api does't follow the standard http response codes

* 2- the data format is not consistent between the api and the cache for example *sqlite* use integers to represent booleans
