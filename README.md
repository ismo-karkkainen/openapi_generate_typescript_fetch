# openapi_generate_typescript_fetch

A Ruby gem containing code generation templates for use with openapi-generate tool from openapi-sourcetools gem. This gem provides TypeScript client code generation using Fetch API.

## Generated Code

Overall, you get a package with tests. The package can be published and installed where needed.

The contents of the TypeScript output is briefly described to give an overview of what the generated code contains.

The source will have `src` and `test` subdirectories, and the compiled code is placed under `pkg` directory. The files under `pkg/src` are only included in the package. `pkg/src/index.js` is the main file and merely exports types, functions etc. from other files.

Typically a function has a matching arguments type that is the only parameter passed to the function, with some intentional exceptions.

Each operationId receives its own request and response classes. Request class handles forming the request and allows external modifications, or you can extract URL and RequestInit and modify them if needed. You can use the call-method or perform the fetch yourself. Reponse class organizes the expected response data for easy checks. In case of non-2XX status codes, the response can throw an exception if so configured. The error class is also operationId-specific. Request class can encode the body, when present. Response class will try to decode the body when present. For content types other then JSON, you can set encoder and decoder functions, selected using content-type header value. You can also provide already encoded body.

The request class has members that cover the parameters needed for the request. The class also has static members that match the same parameters. Then there are shared parameters. A class instance member is used for the request performed by this particular class instance. A static member is used by all instances, when instance member is not set. If neither instance or class static member is set, matching member from shared parameters is used. If all are missing and the parameter is optional then the parameter is omitted.

There is an option to set extra parameters. There can be headers or query parameters. The instance > class static > shared setting hierarchy applies to them as well. The server URL can be set as shared setting. Authorization-related headers that are the same for all requests can be set as shared as well, updated when e.g. token is about to expire.

Respose class has members named c123 based on the expected status codes, and cOther to cover the rest. Each of these has type that has properties for what the response is expected to contain. The same properties are duplicated at the top level. When properties with same name at different levels are set, they refer to the same object.

The `servers.ts` file has storage for server information. As the OpenAPI spec does not name servers with anything like operationId for operations, the URL is used as basis for naming the functions, which you call with needed parameters. For example httpLocalhost or httpsPrefixExampleCom. They apply the parameters and return a server URL for use with actual calls.

The `shared.ts` has types that contain all parameters and it exports a shared const that is used by all operationId classes. It also has functions to extract just the part of shared parameters that an operation needs. It has properties for server URL, default extras, a request information modifier function, and a body encoder function if you want to set something in one place for all.

Due to the possibility that same parameter name is used with multiple different types, there is some duplication in the parameters. For parameter `foo` there is a property `foo` that has the most common type for a parameter with that name. Then there are type-specific properties. A `fooBar` has type `Bar` and so on. The property with most specific type has precedence when selecting which one to use when multiple ones have been set. A consequence of this duplication is that if one parameter was the most common, but as the API changes, another one becomes more common, the property without type name changes type. Typescript should indicate the improper assignments so the code can be fixed. If in doubt, use property with type in the name.

The `schemas.ts` file contains for all schemas an exported type SomeType, a function to check if unknown item x is SomeType (isSomeType), a function to convert unknown to SomeType (unknown2SomeType), and a function to return a copy without extra properties from an argument expected to be SomeType (baseSomeType). If you have stated `additionalProperties: false` in the schema, then all properties that are not recognized are omitted from the output. These are defined for all types, even though for number and such, they actually do nothing.

The `callclasses.ts` contains the request and response classes along with error classes. You create a new request class using new, set it up as you need, use async call() and it returns to you a response class instance with a reference to the request class, and members filled according to what was received.

Security parameters are intentionally omitted. For whatever you need, use extras to set the headers. Security schemes have some simple types.

## Configuration

Configuration files are YAML files or anything the YAML library can parse. The configuration file default prefix name is `openapi_generate_typescript_fetch`. See openapi-sourcetools configuration loading for more information.

Key `target` holds the generation target, either `browser` or `node`.

Key `subdir` is optional and holds a string that specifies the subdirectory under the output directory specified in openapi-generate command-line arguments.

Key `copy` is intended for license files and others that are to be copied as is. It holds an array of records that specify:

- `content`: The actual content string to be copied.
- `source`: Name of the file to be copied. Used if content is not present.
- `target`: The destination file name with path. If given, `subdir` is prepended to the target path.

Key `copyright` is for a copyright text block that is included in the generated files.

Under `tests` is expected to be the output of openapi-patterntests with needed manual changes.

An example configuration with target, added script for package.json, and test strings for a string pattern. 

```yaml
target: 'browser'
package:
  scripts:
    coverage: "tsc && NODE_V8_COVERAGE=coverage mocha pkg/test"
tests:
  patterns:
  - pattern: "^.+$"
    minLength: 1
    maxLength: 64
    pass:
    - 'alskjdfhgaolsdhj'
    - p
    - pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp
    fail:
    - ''
    - fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
```

## Usage

See the quick start to get generation source document from you API as described in README.md of [openapi-sourcetools](https://github.com/ismo-karkkainen/openapi-sourcetools).

To run the actual generation using this gem, run:

```sh
openapi-generate --input generation_source_document.yaml --outdir package-dir config:package_cfg req:openapi_generate_typescript_fetch
```

The package-dir will have a TypeScript NPM package sources including test files. The config points to files with `package_cfg` as name prefix.

## To Do

- Add oneOf, anyOf, allOf support.
- Large API document generated with multiple possible combinations for each thing.
- Small example API and code.
- Naming things could have something that can deal with collisions.
- Testing with mock server? https://github.com/nock/nock ?

## License

Copyright © 2025-2026 Ismo Kärkkäinen

Licensed under Universal Permissive License. See LICENSE.txt.
