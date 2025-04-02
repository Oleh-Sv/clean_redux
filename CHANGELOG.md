## 0.0.1

- Initial releae with base features.

## 0.1.0

- Fixed use waitCancel behaviour. Now it unsubscribes from main stream after complete of execute.

## 0.1.1

- Improve to previous change

## 0.2.0

- Replace Future in waitCancel to token

## 0.3.0

- New way to pass CancelToken

## 0.3.1

- Expose outside _canceled field of CancelToken

## 0.3.2

- Mark Action as constant

## 0.3.3

- Extended Failure

## 0.3.4

- Updated dependecies

## 0.3.5

- Added details field to Failure

## 0.3.6

- Extended constructor for FailureOrResult

## 0.3.7

- Added ability to provide custom name for action type. Useful in case of logging when code minified

## 0.3.8

- Use typeName in toString()

## 0.3.9

- Added stack trace to FailureOrResult constructor 
- Added generic state for failures

## 0.3.10

- Fixed mistake in Action toString()

## 0.3.11

- Enabled reset failure reducer