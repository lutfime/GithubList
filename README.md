# GithubList
An example app that utilizes Github users API.

Recently, I've update the source code to use clean architecture. You can see old implementation here:

Improvements for new implementation using clean architecture:
- Use dependency injection for components testability
- Use dependency inversion for APILoader and LocalLoader instead of using concrete infrastructure implementation. This makes the components are more reusable and testable.
- Use of composition root to compose dependencies


![github list](https://user-images.githubusercontent.com/2703248/203711026-9a19960c-e50c-4696-bd58-93ce8322156c.gif)
