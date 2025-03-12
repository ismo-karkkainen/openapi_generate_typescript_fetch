# openapi_generate_typescript_fetch

A Ruby gem containing code generation templates for use with openapi-generate tool from openapi-sourcetools gem. This gem provides TypeScript client code generation using Fetch API.

## Configuration

Configuration files are YAML files or anything the YAML library can parse. The configuration file default prefix name is `openapi_generate_typescript_fetch`. See openapi-spourcetools configuration loading for more information.

Key "subdir" is optional holds a string that specifies the subdirectory under the output directory specified in openapi-generate command-line arguments.

Key "copy" is intended for license files and others that are to be copied as is. It holds an array of records that specify:
- content: The actual content string to be copied.
- source: Name of the file to be copied. Used if content is not present.
- target: The destination file name with path. If given, "subdir" is prepended to the target path.

Key "copyright" is for a copyright text block that is included in the generated files.




## License

Copyright © 2024-2025 Ismo Kärkkäinen

Licensed under Universal Permissive License. See LICENSE.txt.
