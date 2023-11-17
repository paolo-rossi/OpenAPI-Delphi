# OpenAPI for Delphi - OpenAPI 3.0 for Delphi

<br />

<p align="center">
  <img src="https://github.com/paolo-rossi/OpenAPI-Delphi/blob/master/openapi-delphi.png" alt="OpenAPI Delphi Library" width="400" />
</p>

## What is OpenAPI-Delphi

**OpenAPI-Delphi** is an OpenAPI 3.0 library for [Delphi](https://www.embarcadero.com/products/delphi) that helps you to generate (and load) OpenAPI 3.0 documentation (in JSON) starting from plain Delphi classes. Delphi-OpenAPI uses the [Neon](https://github.com/paolo-rossi/delphi-neon) serialization library to transform the OpenAPI models from Delphi classes to JSON and to load a OpenAPI document into a Delphi (OpenAPI) object. Please take a look at the Demo to see OpenAPI-Delphi in action.

## General Features

- OpenAPI document generation (JSON) from a Delphi (OpenAPI) object 
- OpenAPI loading and parsing into a Delphi (OpenAPI) object (:star2: new in 2.0)
- Use plain Delphi classes to set the OpenAPI specification sections & fields
- Support for JSON Schema (the OpenAPI version)
- Support for Schema field recursion (:star2: new in 2.0)
- Full Support for enum of any type (:star2: new in 2.0)
- Use 1-line code (using the [Neon](https://github.com/paolo-rossi/delphi-neon) library) to transform from and to JSON documents

## Delphi Compatibility
This library has been tested with **Delphi 12 Athens**, **Delphi 11 Alexandria**, **Delphi 10.4 Sydney**, **Delphi 10.3 Rio**, **Delphi 10.2 Tokyo**.


## Todo
- Full validation for the OpenAPI models

