## Contributing to Stately

So you want to contribute? Awesome! Contributions are welcomed.  
Before we get started on setting up the development environment, check out
the [Code of conduct](./CODE_OF_CONDUCT.md).  

There are a few ways to contribute to Stately:

- Adding documentation
  Articles and documents detailing how classes/functions work at a more
  granular level is always helpful.

- Tooling
  You could work on extra tooling for Stately, things such as CLI generation
  tools, devtools integrations, etc etc.

- Contributing to Stately itself
  This is the hardest part as the codebase itself is rather small. The functionality
  is more causing other state management tools to conform to the FSM-style. However,
  there are still places where code can be contributed, but usually better to fix bugs.

**It is highly encouraged to make an issue before creating your PR**  
This package is relatively lightweight so it would be better to hash out what you
want to do/get done before creating a PR of the work as it may be declined if it doesn't
align with the purpose of Stately.

A discussion can help prevent you spending tons of time on something that may never
make it into the codebase.

## Documentation work (WIP)

Stately's documentation uses [Docusaurus](https://docusaurus.io/fr/docs). It is
currently a Work In Progress (WIP) until fully realized examples are created.

Documentation is written in "mdx", which is a combination of Markdown and JSX.  
Feel free to look at existing pages to see how they work.

### Installing the website locally

The docs uses [node](https://nodejs.org/fr) and [yarn](https://yarnpkg.com/).  
You will need to install both and run:

```sh
yarn install
```

Then, you can start the documentation locally with:

```sh
yarn dev
```

Finally, head to `localhost:3000`

### Adding code snippets (WIP)

Unless agree otherwise, all code snippets inside docs need to be placed in a `.dart` file
and then imported in `.mdx` files.  
This is important to enable static analysis of the code snippets, such that when
a breaking change happens, all associated snippets in the documentation that
need updating will be highlighted.