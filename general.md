Backend best practices

Check out my other repositories:

    Domain-Driven Hexagon - Guide on Domain-Driven Design, software architecture, design patterns, best practices etc.
    System Design Patterns - list of topics and resources related to distributed systems, system design, microservices, scalability and performance, etc.
    Full Stack starter template - template for full stack applications based on TypeScript, React, Vite, ChakraUI, tRPC, Fastify, Prisma, zod, etc.

In this readme are presented some of the best practices, tools and guidelines for backend applications gathered from different sources.

This Readme contains code examples mainly for TypeScript + NodeJS, but practices described here are language agnostic and can be used in any backend project.

    Backend best practices
        Architecture
        API Security
            Data Validation
            Enforce least privilege
            Rate Limiting
        Testing
            White box vs Black box
            Load Testing
            Fuzz Testing
        Documentation
            Document APIs
            Use wiki
            Add Readme
            Write self-documenting code
            Prefer statically typed languages
            Avoid useless comments
        Database Best Practices
            Backups
            Managing Schema Changes
            Data Seeding
        Configuration
        Logging
        Monitoring
            Telemetry
        Standardization
        Static Code Analysis
        Code formatting
        Shut down gracefully
        Profiling
        Benchmarking
        Make application easy to setup
        Deployment
            Blue-Green Deployment
        Code Generation
        Version Control
            Pre-push/pre-commit hooks
            Conventional commits
        API Versioning
    Additional resources
        Github Repositories

Architecture

Software architecture is about making fundamental choices of your application structure.

    Architecture serves as a blueprint for a system. It provides an abstraction to manage the system complexity and establish a communication and coordination mechanism among components.

Choosing the right architecture is crucial for your application.

We discussed architecture in details in this repository: Domain-Driven Hexagon.

Make sure your architecture is enforced: Enforcing architecture

Read more:

    Software Architecture & Design Introduction

API Security

Software security is the application of techniques that allow to mitigate and protect software systems from vulnerabilities and malicious attacks.

Software security is a large and complex discipline, so we will not cover it in details here.

Instead, here are some generic recommendations to ensure at least basic level of security:

    Ensure secure coding practices
    Validate all inputs and requests.
    Ensure you don’t store sensitive information in your Authentication tokens.
    Use TLS protocol
    Ensure you encrypt all sensitive information stored in your database
    Ensure that you are using safe encryption algorithms. There are a lot of algorithms that are still widely used, but are not secure, for example MD5, SHA1 etc. Secure algorithms include RSA (2048 bits or above), SHA2 (256 bits or above), AES (128 bits or above) etc. Security/Guidelines/crypto algorithms
    Monitor user activity on your servers to ensure that users are following software security best practices and to detect suspicious activities, such as privilege abuse and user impersonation.
    Never store secrets (passwords, keys, etc.) in the sources in version control (like GitHub). Use environmental variables to store secrets. Put files with your secrets (like .env) to .gitignore.
    Update your packages and software tools frequently so ensure the latest bugs and vulnerabilities are fixed
    Monitor vulnerabilities in any third party software / libraries you use
    Follow popular cybersecurity blogs and websites to be aware of the latest security vulnerabilities. This way you can effectively mitigate them in time.
    Don’t pass sensitive data in your API queries, for example: https://example.com/login/username=john&password=12345
    Don't log sensitive data to prevent leaks
    Harden your server by closing all but used ports, use firewall, block malicious connections using tools like fail2ban, keep your server up to date, etc.

Read more:

    OWASP Top Ten
    OWASP Cheat Sheet Series
    Hardening a Linux Server for Production

Data Validation

Data validation is critical for security of your API. You should validate all the input sent to your API.

Below are some basic recommendations on what data should be validated:

    Origin - Is the data from a legitimate sender? When possible, accept data only from authorized users / whitelisted IPs etc. depending on the situation.
    Existence - is provided data not empty? Further validations make no sense if data is empty. Check for empty values: null/undefined, empty objects and arrays.
    Size - Is it reasonably big? Before any further steps, check length/size of input data, no matter what type it is. This will prevent validating data that is too big which may block a thread entirely (sending data that is too big may be a DoS attack).
    Lexical content - Does it contain the right characters and encoding? For example, if we expect data that only contains digits, we scan it to see if there’s anything else. If we find anything else, we draw the conclusion that the data is either broken by mistake or has been maliciously crafted to fool our system.
    Syntax - Is the format right? Check if data format is right. Sometimes checking syntax is as simple as using a regexp, or it may be more complex like parsing an XML or JSON.
    Semantics - Does the data make sense? Check data in connection with the rest of the system (like database, other processes etc.). For example, checking in a database if ID of item exists.

Cheap operations like checking for null/undefined and checking length of data come early in the list, and more expensive operations that require calling the database should be executed afterwards.

Example files:

    create-user.request.dto.ts - lexical, size and existence validations of a DTO using decorators provided by class-validator package.

Read more:

    OWASP Input Validation Cheat Sheet
    "Secure by Design" Chapter 4.3: Validation.

Enforce least privilege

Ensure that users and systems have the minimum access privileges required to perform their job functions (Principle of least privilege).

For example:

    On your web server you can leave only 443 port for HTTPS requests open (and maybe an SSH port for administrating), and close all the other ports to prevent hackers connecting to other applications that may be running on your server.
    When working with databases, give your APIs/services/users only the access rights that they need, and restrict everything else. Let's say if your API only needs to read data, let it read it, but not modify (for example when working with read replicas or CQRS queries your API may only need to read that data but never modify it, so restrict update/delete actions for it).
    Give proper access rights to users. For example, you want your newly hired employee to help your customer service, so you give him SSH access to production server, so he can check the logs through a terminal when it is needed. But you don't want him to shut down the server by accident, so leave him with minimum access rights that he needs to do his job, and restrict access to anything else (and log all his actions).

Eliminating unnecessary access rights significantly reduces your attack surface.

Read more:

    Principle of Least Privilege (PoLP): What Is It, Why Is It Important, & How to Use It

Rate Limiting

Enforce a limit to the number of API requests within a time frame, this is called Rate Limiting or API throttling

By default, there is no limit on how many request users can make to your API. This may lead to problems, like DoS or brute force attacks, performance issues like high response time etc.

To solve this, implementing Rate Limiting is essential for any API.

Also enforce rate limiting for login attempts. Lock a user account for specific period of time after a given number of failed attempts

    In NodeJS world, express-rate-limit is an option for simple APIs.
    Another alternative is NGINX Rate Limiting.
    Kong has rate limiting plugin.

Read more:

    Everything You Need To Know About API Rate Limiting
    Rate-limiting strategies and techniques
    How to Design a Scalable Rate Limiting Algorithm

Testing

Software Testing helps to catch bugs early. Properly tested software product ensures reliability, security and high performance which further results in time saving, cost-effectiveness and customer satisfaction.
White box vs Black box

Let's review two types of software testing:

    White Box testing.
    Black Box testing.

Testing module/use-case internal structures (creating a test for every file/class) is called White Box testing. White Box testing is widely used technique, but it has disadvantages. It creates coupling to implementation details, so every time you decide to refactor business logic code this may also cause a refactoring of corresponding tests.

Use case requirements may change mid-work, your understanding of a problem may evolve, or you may start noticing new patterns that emerge during development, in other words, you start noticing a "big picture", which may lead to refactoring. For example: imagine that you defined a unit test for a class, and while developing this class you start noticing that it does too much and should be separated into two classes. Now you'll also have to refactor your test. After some time, while implementing a new feature, you notice that this new feature uses some code from that class you defined before, so you decide to separate that code and make it reusable, creating a third class (which originally was one), which leads to changing your unit tests yet again, every time you refactor. Use case requirements, input, output or behavior never changed, but tests had to be changed multiple times. This is inefficient and time-consuming.

When we have domain models that change often, tests tend to change with them. Traditional white box unit tests tend to be very coupled to internals of our domain model structure.

To solve this and get the most out of your tests, prefer Black Box testing (Behavioral Testing). This means that tests should focus on testing user-facing behavior users care about (your code's public API), not the implementation details of individual units it has inside. This avoids coupling, protects tests from changes that may happen while refactoring, makes tests easier to understand and maintain thus saving time.

    Tests that are independent of implementation details are easier to maintain since they don't need to be changed each time you make a change to the implementation.

Try to avoid White Box testing when possible. However, it's worth mentioning that there are cases when White Box testing may be useful:

    For instance, we need to go deeper into the implementation details when it is required to reduce combinations of testing conditions. For example, a class uses several plug-in strategies, thus it is easier for us to test those strategies one at a time.
    You are developing a library that will be used by multiple modules or projects. In those cases White Box tests may be appropriate.
    You want to document some complex piece of code. Creating a test can be a great way to do it instead of just writing comments/readme, since readme can get outdated, but test will fail if it gets outdated forcing you to update it.

Use White Box testing only when it is really needed and as an addition to Black Box testing, not the other way around.

It's all about investing only in the tests that yield the biggest return on your effort.

Black Box / Behavioral tests can be divided in two parts:

    Fast: Use cases tests in isolation which test only your business logic, with all I/O (external API or database calls, file reads etc.) mocked. This makes tests fast, so they can be run all the time (after each change or before every commit). This will inform you when something fails as fast as possible. Finding bugs early is critical and saves a lot of time.
    Slow: Full End to End (e2e) tests which test a use case from end-user standpoint. Instead of injecting I/O mocks those tests should have all infrastructure up and running: like database, API routes etc. Those tests check how everything works together and are slower so can be run only before pushing/deploying. Though e2e tests can live in the same project/repository, it is a good practice to have e2e tests independent from project's code. In bigger projects e2e tests are usually written by a separate QA team.

Note: some people try to make e2e tests faster by using in-memory or embedded databases (like sqlite3). This makes tests faster, but reduces the reliability of those tests and should be avoided. Read more: Don't use In-Memory Databases for Tests.

For BDD tests Cucumber with Gherkin syntax can give a structure and meaning to your tests. This way even people not involved in a development can define steps needed for testing. In node.js world jest-cucumber is a nice package to achieve that.

Example files:

    create-user.feature - feature file that contains human-readable Gherkin steps
    create-user.e2e-spec.ts - e2e / behavioral test

Read more:

    Pragmatic unit testing
    Google Blog: Test Behavior, Not Implementation
    Writing BDD Test Scenarios
    Book: Unit Testing Principles, Practices, and Patterns

Load Testing

For projects with a bigger user base you might want to implement some kind of load testing to see how program behaves with a lot of concurrent users.

Load testing is a great way to minimize performance risks, because it ensures an API can handle an expected load. By simulating traffic to an API in development, businesses can identify bottlenecks before they reach production environments. These bottlenecks can be difficult to find in development environments in the absence of a production load.

Automatic load testing tools can simulate that load by making a lot of concurrent requests to an API and measure response times and error rates.

Example tools:

    k6
    Artillery is a load testing tool based on NodeJS.

Example files:

    create-user.artillery.yaml - Artillery load testing config file. Also can be useful for seeding database with dummy data.

More info:

    Top 6 Tools for API & Load Testing.
    Getting started with API Load Testing (Stress, Spike, Load, Soak)

Fuzz Testing

Fuzzing or fuzz testing is an automated software testing technique that involves providing invalid, unexpected, or random data as inputs to a computer program.

Fuzzing is a common method hackers use to find vulnerabilities of the system. For example:

    JavaScript injections can be executed if input is not sanitized properly, so a malicious JS code can end up in a database and then gets executed in a browser when somebody reads that data.
    SQL injection attacks can occur if data is not sanitized properly, so hackers can get access to a database (though modern ORM libraries can protect from that kind of attacks when used properly).
    Sending weird unicode characters, emojis etc. can crash your application.

There are a lot of examples of a problems like this, for example sending a certain character could crash and disable access to apps on an iPhone.

Sanitizing and validating input data is very important. But sometimes we make mistakes of not sanitizing/validating data properly, opening application to certain vulnerabilities.

Automated Fuzz testing tools can prevent such vulnerabilities. Those tools contain a list of strings that are usually sent by hackers, like malicious code snippets, SQL queries, unicode symbols etc. (for example: Big List of Naughty Strings), which helps test most common cases of different injection attacks.

Fuzz testing is a nice addition to typical testing methods described above and potentially can find serious security vulnerabilities or defects.

Example tools:

    Artillery Fuzzer is a plugin for Artillery to perform Fuzz testing.
    sqlmap - an open source penetration testing tool that automates the process of detecting and exploiting SQL injection flaws

Read more:

    Fuzz Testing(Fuzzing) Tutorial: What is, Types, Tools & Example

Documentation

Here are some useful tips to help users/other developers to use your program.
Document APIs

Use OpenAPI (Swagger) or GraphQL specifications. Document in details every endpoint. Add description and examples of every request, response, properties and exceptions that endpoints may return or receive as body/parameters. This will help greatly to other developers and users of your API.

Example files:

    user.response.dto.ts - notice @ApiProperty() decorators. This is NestJS Swagger module.
    create-user.http.controller.ts - notice @ApiOperation() and @ApiResponse() decorators.

Read more:

    Documenting a NodeJS REST API with OpenApi 3/Swagger
    Best Practices in API Documentation

Use wiki

Create a wiki for collecting and sharing knowledge. Describe common tools, practices and procedures used in your organization. Write down notes explaining peculiarities of your software, how it works and why you made certain decisions.

It must be easy for everyone, especially new team members, to learn about specifics of the project.

According to The Bus Factor, projects can stall if knowledge is not shared properly across team members.

Here are some useful tools for note-taking and creating wikis:

    Notion
    Obsidian
    Confluence
    Outline

Read more:

    The Surprising Power of Documentation
    How to build a wiki for your company
    Use of Wikis in Organizational Knowledge Management

Add Readme

Create a simple readme file in a git repository that describes basic app functionality, available CLI commands, how to setup a new project etc.

    How to write a good README
    How to write a good README for your GitHub project?

Write self-documenting code

Code can be self-documenting to some degree. One useful trick is to separate complex code to smaller chunks with a descriptive name. For example:

    Separating a big function into a bunch of small ones with descriptive names, each with a single responsibility;
    Moving in-line primitives or hard to read conditionals into a variable with a descriptive name.

This makes code easier to understand and maintain.

Read more:

    Tips for Writing Self-Documenting Code

Prefer statically typed languages

Types give useful semantic information to a developer and can be useful for creating self-documenting code. Good code should be easy to use correctly, and hard to use incorrectly. Types system can be a good help for that. It can prevent some nasty errors at a compile time, so IDE will show type errors right away.

Applications written using statically typed languages are usually easier to maintain, more scalable and better suited for large teams.

Note: For smaller projects/scripts/jobs static typing may not be needed.

Read more:

    Static Types vs Dynamic Types

Avoid useless comments

Writing readable code, using descriptive function/method/variable names and creating tests can document your code well enough. Try to avoid comments when possible and try to make your code legible and tested instead.

Use comments only when it's really needed. Commenting may be a code smell in some cases, like when code gets changed but a developer forgets to update a comment (comments should be maintained too).

    Code never lies, comments sometimes do.

Use comments only in some special cases, like when writing an counter-intuitive "hack" or performance optimization which is hard to read.

For documenting public APIs use code annotations (like JSDoc) instead of comments, this works nicely with code editor intellisense.

Read more:

    Code Comment Is A Smell
    // No comments

Database Best Practices
Backups

Data is one of the most important things in your business. Keeping it safe is a top priority of any backend service.

Here are some basic recommendations:

    Create backups frequently and regularly
    Use remote storages for your backups. Backing up your data and storing it on the same disk as your original data is a road to losing everything. When your storage breaks you will lose an original data and your backups. So keep your backups separately
    Keep backups encrypted and protected. Backup encryption ensures data is protected from leaks and that your data will be what you expect when you recover it
    Consider retention span. Keeping every backup forever isn’t feasible due to a limited amount of space for storage
    Monitor the backup and restore process
    Consider using point in time recovery when you need to restore database to a specific point in time (if database supports it). This can be useful for synchronizing time between multiple databases when restoring them from a backup.

Read more:

    Backup and Recovery Best Practices
    The 7 critical backup strategy best practices to keep data safe

Managing Schema Changes

Migrations can help for database table/schema changes:

    Database migration refers to the management of incremental, reversible changes and version control to relational database schemas. A schema migration is performed on a database whenever it is necessary to update or revert that database's schema to some newer or older version.

Source: Wiki

Migrations can be written manually or generated automatically every time database table schema is changed. When pushed to production it can be launched automatically.

BE CAREFUL not to drop some columns/tables that contain data by accident. Perform data migrations before table schema migrations and always backup database before doing anything.

Examples:

    Typeorm Migrations - can automatically generate sql table schema migrations like this: 1611765824842-CreateTables.ts
    Or you could create raw SQL queries like this: 2022.10.07T13.49.19.users.sql

Read more:

    What are database migrations?
    Database Migration: What It Is and How to Do It

Data Seeding

To avoid manually creating data in the database, seeding is a great solution to populate database with data for development and testing purposes.

Example packages for nodejs:

    typeorm-seeding - seeder for TypeORM
    faker.js - generate mock data

Example file: user.seeds.ts

Read more:

    Seed hundreds of dummy data using faker.js

Configuration

    Store all configurable variables/parameters in config files. Try to avoid using in-line literals/primitives. This will make it easier to find and maintain all configurable parameters when they are in one place.
    Never store sensitive configuration variables (passwords/API keys/secret keys etc) in plain text in a configuration files or source code.
    Store sensitive configuration variables, or variables that change depending on environment, as environment variables (dotenv is a nice package for that) or as a Docker/Kubernetes secrets.
    Create hierarchical config files that are grouped into sections. If possible, create multiple files for different configs (like database config, API config, tasks config etc).
    Application should fail and provide the immediate feedback if the required environment variables are not present at start-up. env-var is a nice package for nodejs that can take care of that.
    For most projects plain object configs may be enough, but there are other options, for example: NestJS Configuration, rc, nconf or any other package.

Example files:

    database.config.ts - database config that uses environmental variables and also validates them
    .env.example - this is dotenv example file. This file should only store dummy example secret keys, never store actual development/production secrets in it. This file later is renamed to .env and populated with real keys for every environment (local, dev or prod). Don't forget to add .env to .gitignore file to avoid pushing it to repo and leaking all keys.

Logging

    Try to log all meaningful events in a program that can be useful to anybody in your team.
    Use proper log levels: log/info for events that are meaningful during production, debug for events useful while developing/debugging, and warn/error for unwanted behavior on any stage.
    Write meaningful log messages and include metadata that may be useful. Try to avoid cryptic messages that only you understand.
    Never log sensitive data: passwords, emails, credit card numbers etc. since this data will end up in log files. If log files are not stored securely this data can be leaked.
    Parse your logs and remove all potentially sensitive data to prevent accidental leaks. For example, you can iterate over logged values and remove anything that has a "secret" or "password" or similar keys in it.
    Avoid default logging tools (like console.log). Use mature logger libraries (for example Winston) that support features like enabling/disabling log levels, convenient log formats that are easy to parse (like JSON) etc.
    Consider including user id in logs. It will facilitate investigating if user creates an incident ticket.
    In distributed systems a gateway (or a client) can generate an unique correlation id for each request and pass it to every system that processes this request. Logging this id will make it easier to find related logs across different systems/files. You can also use a causation id to determine a correct ordering of the events that happen in your system. Read more: Correlation id and causation id in evented systems
    Use consistent structure across all logs. Each log line should represent one single event and can contain things like a timestamp, context, unique user id or correlation id and/or id of an entity/aggregate that is being modified, as well as additional metadata if required.
    Use log managements systems. This will allow you to track and analyze logs as they happen in real-time. Here are some short list of log managers: Sentry, Loggly, Logstash, Splunk etc.
    Send notifications of important events that happen in production to a corporate chat like Slack or even by SMS.
    Don't write logs to a file or to the cloud provider from your program. Write all logs to stdout and let other tools handle writing logs to cloud or file (for example docker supports writing logs to a file). Read more: Why should your Node.js application not handle log routing?
    Logging operation can affect performance, especially when you transform your logs (for example to remove sensitive data). You can delegate log parsing and transforming to a separate process. For example, Pino logger supports this.
    Instead of sending your logs to stdout, alternatively you could send them to your sidecar (running in the same container) that will handle log parsing, transformations, and sending them to your log visualization tool in batches for better performance.
    Logs can be visualized by using a tool like Kibana, or by your cloud provider of choice.

Read more:

    Make your app transparent using smart logs

Monitoring

Monitoring is the process to gather metrics about the operations of an IT environment's hardware and software to ensure everything functions as expected.

Additionally, to logging tools, when something unexpected happens in production, it's critical to have thorough monitoring in place. As software hardens more and more, unexpected events will get more and more infrequent and reproducing those events will become harder and harder. So when one of those unexpected events happens, there should be as much data available about the event as possible. Software should be designed from the start to be monitored. Monitoring aspects of software are almost as important as the functionality of the software itself, especially in big systems, since unexpected events can lead to money and reputation loss for a company. Monitoring helps fix and sometimes preventing unexpected behavior like failures, slow response times, errors etc.

Health monitoring tools are a good way to keep track of system performance, identify causes of crashes or downtime, monitor behavior, availability and load.

Some health monitoring tools already include logging management and error tracking, as well as alerts and general performance monitoring.

Here are some basic recommendation on what can be monitored:

    Connectivity – Verify if user can successfully send a request to the API endpoint and get a response with expected HTTP status code. This will confirm if the API endpoint is up and running. This can be achieved by creating some kind of 'heath check' endpoint.
    Performance – Make sure the response time of the API is within acceptable limits. Long response times cause bad user experience.
    Error rate – errors immediately affect your customers, you need to know when errors happen right away and fix them.
    CPU and Memory usage – spikes in CPU and Memory usage can indicate that there are problems in your system, for example bad optimized code, unwanted process running, memory leaks etc. This can result in loss of money for your organization, especially when cloud providers are used.
    Storage usage – servers run out of storage. Monitoring storage usage is essential to avoid data loss.
    Monitor your backend and any 3rd party services that your backend use, monitor databases, kubernetes clusters etc. to ensure that everything in a system works as intended.

Choose health monitoring tools depending on your needs, here are some examples:

    Sematext, AppSignal, Prometheus, Checkly, ClinicJS

Read more:

    Essential Guide to API Monitoring: Basics Metrics & Choosing the Best Tools
    DevOps measurement: Monitoring and observability

Telemetry

Telemetry data (metrics, logs, and traces) can help analyze your software’s performance and behavior.

For example, imagine that you have an event handler that listens for events and executes something:

async handleUserCreatedEvent(event: UserCreatedEvent) {
  await scheduleEmailNotification(event);
  await createWalletForNewUser(event);
  await doSomethingElse(event);
}

In production environments, you or your clients can notice that application is unresponsive, or that operations have a long delay, and sometimes it's hard to determine why. Telemetry data can help investigate why. Let's modify our previous example:

async handleUserCreatedEvent(event: UserCreatedEvent) {
  // Initialize tracing with OpenTelemetry
  const tracer = trace.getTracer('EventSubscriber', '0.1.0');
  const span = tracer.startSpan(name);
  span.addAttribute('eventName', event.name);

  span.addEvent(`Received event. Scheduling email notification...`);
  await scheduleEmailNotification(event);

  span.addEvent(`Creating wallet for new user...`);
  await createWalletForNewUser(event);

  span.addEvent(`Starting something else...`);
  await doSomethingElse(event);

  span.addEvent(`Event processed.`);
}

We created a tracer span and logged some events before every function execution. These logs can be integrated with a cloud provider, or tools like Prometheus, that will visualize your telemetry data, create charts and graphs, showing execution times for each span and log. Now, you can check your telemetry graphs at any time and instantly locate exact function call that causes unusual spikes.

Telemetry data can be logged anywhere:

    API endpoints to see how long each request takes
    event handlers to trace event execution
    network calls, like calling external APIs
    database queries to observe query execution times
    large functions with multiple steps
    periodic jobs
    other places of interest

Using telemetry makes it trivial to locate bottlenecks in your application.

Example tools:

    OpenTelemetry - a collection of tools, APIs, and SDKs to instrument, generate, collect, and export telemetry data.

Standardization

Standardization is the process of implementing and developing technical standards based on the consensus of different parties.

Define and agree on standards in the development process, for example:

    Tech stack and tools
    Architectural practices, code style and formatting tools
    Create reusable software objects and interfaces for common procedures
    Enforce naming conventions
    Define API response structure
    Standard way of handling pagination of resources
    Standardize protocols and schemas that will be used for communication between multiple systems
    Error handling
    Versioning of your app, libraries, endpoints, schemas, etc
    Documentation
    Standard ways to report health, errors, monitoring statistics, etc
    Standard ways of logging and a place where those logs will be aggregated
    etc.

Standards help enforce best practices and simplify both the development process and code.

Create documents that describe your standards and enforce them as much as you can. Ideally there should be only one way of doing a common task. If you don't have standards everybody in the team will be doing things differently and your system will be a mess.

Read more:

    Standardization in Software Development: Accelerating Innovation

Static Code Analysis

    Static code analysis is a method of debugging by examining source code before a program is run.

For JavasScript and TypeScript, Eslint with typescript-eslint plugin and some rules (like airbnb / airbnb-typescript) can be a great tool to enforce writing better code.

Try to make linter rules reasonably strict, this will help greatly to avoid "shooting yourself in a foot". Strict linter rules can prevent bugs and even serious security holes (eslint-plugin-security).

    Adopt programming habits that constrain you, to help you to limit mistakes.

For example:

Using explicit any type is a bad practice. Consider disallowing it (and other things that may cause problems):

// .eslintrc.js file
  rules: {
    '@typescript-eslint/no-explicit-any': 'error',
    // ...
  }

Also, enabling strict mode in tsconfig.json is recommended, this will disallow things like implicit any types:

  "compilerOptions": {
    "strict": true,
    // ...
  }

Example file: .eslintrc.js

Code Spell Checker may be a good addition to eslint.

Read more:

    What Is Static Analysis?
    Controlling Type Checking Strictness in TypeScript

Code formatting

The way code looks adds to our understanding of it. Good style makes reading code a pleasurable and consistent experience.

Consider using code formatters like Prettier to maintain same code styles in the project.

Read more:

    Why Coding Style Matters

Shut down gracefully

When you shut down your application you may interrupt all operations that are running at that time and lose data. Unless you gracefully shut down your app.

Shutting down gracefully means when you send a termination signal to your app, it should (if it's a web server):

    Stop all new requests from clients
    Wait until all current requests finish executing
    Close server connections, like connection to a database, external APIs, etc.
    Exit

This way you are not interrupting running operations and prevent a lot of related problems.

Read more:

    Graceful shutdown in NodeJS
    Graceful shutdown in Go http server

Profiling

Profiling allows us to collect and analyze data on how functions in your code perform when executed. This can help us with identifying bottlenecks in our code and fix them to make application perform faster.

Here are some examples for NodeJS:

    Using the inbuilt Node.js profiler
    How to Automate Performance Profiling in Node.js

Benchmarking

To make sure that your optimizations are working and system run fast, consider using benchmarking tools to analyze execution times and performance of your backend, apps, scripts, jobs, etc.

Read more:

    hyperfine - A command-line benchmarking tool.
    How to Perform Web Server Performance Benchmark?

Make application easy to setup

There are a lot of projects out there which take effort to configure after downloading it. Everything has to be set up manually: database, all configs etc. If new developer joins the team he has to waste a lot of time just to make application work.

This is a bad practice and should be avoided. Setting up project after downloading it should be as easy as launching one or few commands in terminal. Consider adding scripts to do this automatically:

    package.json scripts
    docker-compose file
    Makefile
    Database seeding and migrations
    or any other tools.

Example files:

    package.json - notice all added scripts for launching tests, migrations, seeding, docker environment etc.
    docker-compose.yml - after configuring everything in a docker-compose file, running a database and a db admin panel (and any other additional tools) can be done using only one command. This way there is no need to install and configure a database separately.

Deployment

Automate your deployment process. CI/CD tools can help with that.

Deployment automation reduces errors, speeds up deployments, creates a smooth path to deliver updates and upgrades on a regular basis. The process becomes very easy, just pushing your changes to a repository can trigger a build and deploy process automatically so you don't have to do anything else.

During deployment execute your e2e tests, load/fuzz tests, static code analysis checks, check for vulnerabilities in your packages etc. and stop a deploy process if anything fails. This prevents deploying failing or insecure code to production and makes your application robust and secure.

Read more:

    8 Best Practices for Agile Software Deployment
    CI/CD Best Practices for DevOps Teams

Blue-Green Deployment

Blue-green deployment is a release strategy that proposes the use of two servers: "green" and "blue". When deploying, the new build is deployed to one of the servers ("green"). When build is finished, requests are routed to a new build ("green" server), while maintaining an old version of your program ("blue") running. If a "green" server has some bugs or doesn't work properly, you can easily switch back to a "blue" server with zero downtime. This allows to quickly roll back to a previous version if anything goes wrong by simply routing traffic back to a "blue" server with previous version of your program.

Read more:

    BlueGreenDeployment
    What is Blue Green Deployment?
    Intro to Deployment Strategies: Blue-Green, Canary, and More

Code Generation

Code generation can be important when using complex architectures to avoid typing boilerplate code manually.

Hygen is a great example. This tool can generate building blocks (or entire modules) by using custom templates. Templates can be designed to follow best practices and concepts based on Clean/Hexagonal Architecture, DDD, SOLID etc.

Main advantages of automatic code generation are:

    Avoid manual typing or copy-pasting of boilerplate code.
    No hand-coding means less errors and faster implementations. Simple CRUD module can be generated and used right away in seconds without any manual code writing.
    Using auto-generated code templates ensures that everyone in the team uses the same folder/file structures, name conventions, architectural and code styles.

Notes:

    To really understand and work with generated templates you need to understand what is being generated and why, so full understanding of an architecture and patterns used is required.
    Don't try to implement code generation on early stages of development. At early stages your application architecture will change a lot adapting to new requirements, meaning that your code generation templates have to change too. Do it only when your project matures and becomes more stable.

Version Control

Make sure you are using version control systems like git. Version control systems can track changes you make to files, so you have a record of what has been done, and you can revert to specific versions should you ever need to. It will also help coordinating work among programmers allowing changes by multiple people to all be merged into one source.

Below are some good practices to use together with git.
Pre-push/pre-commit hooks

Consider launching tests/code formatting/linting every time you do git push or git commit. This prevents bad code getting in your repo. Husky is a great tool for that.

Read more:

    Git Hooks

Conventional commits

Conventional commits add some useful prefixes to your commit messages, for example:

    feat: added ability to delete user's profile

This creates a common language that makes easier communicating the nature of changes to teammates and also may be useful for automatic package versioning and release notes generation.

Read more:

    conventionalcommits.org
    Semantic Commit Messages
    Commitlint
    Semantic release

API Versioning

API versioning is the practice of transparently managing changes to your API.

API versioning allows you to incorporate the latest changes in a new version of your API thereby still allowing users to have access to the older version of your API without breaking your users application.

If you need to create a new version of an endpoint, a simple solution would be to create new version of DTOs and a URL like this: /v2/users. Keep old version of an endpoint running for backwards compatibility until your users fully migrate to a new version.

Creating a new version of an endpoint instead of modifying an old one protects users of your API from breaking their app.

Note: if the only user of your API is your own frontend that can change on demand API versioning may be not worth it.

If you are using GraphQL, you can use a @deprecated directive on a field.

For versioning packages, libraries, SDKs etc. you can use semantic versioning.

Example files:

    app.routes.ts - file that contains routes with its version.

Read more:

    How to Version a REST API
