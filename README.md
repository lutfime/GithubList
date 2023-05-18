# GithubList
An example app that utilizes Github users API.

At 4/23, I've refactored the source code to use clean architecture. You can see the old implementation before refactoring here:
https://github.com/lutfime/GithubList/tree/633937225f3e5def9ceede6d152f6fcf57058e8e

The commits has been done in smaller scale with description, you can follow the refactoring processes here. 
https://github.com/lutfime/GithubList/commits/master

Improvements of the implementation using clean architecture:
- Use of composition root to compose dependencies
- Use dependency injection for better components testability
- Use dependency inversion for APILoader and LocalLoader instead of using concrete infrastructure implementation. This makes the components more reusable and testable.
- Use adapter, decorator and composite patterns to compose different behaviour of LocalLoader, RemoteLoader and ImageLoader
- Move cross cutting concern such as threading and internet connection check from view model and view controller to composition root.
- Better separation of code
- Added more unit tests
- Added snapshot tests
- Use observer instead of delegate in view model for better readability
- Remove anti-pattern singleton usage
- Now view controller become more clean, only used for displaying UI instead of contains logic.

There are multiple improvements still can be done in the future
- Add more unit tests that tests each class components to work correctly
- Add acceptance tests that test the overall behaviour of the app. For example test `when offline app load and render data from cache`
- Separate `User` object to `User` and `UserProfile` so each `UserList` and `UserProfile` screens use either one only. By separating model objects, we can make the properties immutable which are more type safe.




![github list](https://user-images.githubusercontent.com/2703248/203711026-9a19960c-e50c-4696-bd58-93ce8322156c.gif)
