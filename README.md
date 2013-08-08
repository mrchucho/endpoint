## Endpoint Explorer

Add this route:

```ruby
root to: 'endpoint/endpoint_explorer#show'
```

Include this in controllers:

```ruby
include Endpoint::ApiExpression
```
