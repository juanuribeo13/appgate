# Appgate

## Description

Appgate is a test app built using SwiftUI and Combine, it also has it's code split in multiple Swift frameworks and uses the Swift Package Manager for managing the dependencies.

The project is composed of the following modules:

### Core

This framework contains the models as well as a helper class for making validations.

### KeychainStore

This framework exposes an API for interacting with the Keychain. There's also a `KeychainStoreTests` project which was created in order to test the `KeychainStore` since the Keychain requires a bundle and cannot be directly tested in the framework

### Repository

This framework exposes an API for creating and validating accounts. It has as dependency the `KeychainStore` framework for storing sensitive data and the `Core` framework for the models.

### Appgate

This is the main app which allows the user to create accounts, validate accounts and if the validation is successful also allows the user to see the list of all the validation attempts for that account.

## Usage

All you need to do is clone the repository or download the code and open `Appgate.xcworkspace` with Xcode, since the project only has local dependencies and uses the Swift Package Manager nothing else needs to be done.
