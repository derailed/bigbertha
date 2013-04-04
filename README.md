Firewater - a ruby implementation of the Firebase framework

Firebase is a real-time backend that allows one to store key-value pairs in a hierarchical fashion, without
having to manage additional servers (http://firebase.com)

---

## Requirements

- Ruby 1.9
- Map
- Typhoeus

## > Getting Started

$ gem install firewater

## > Usage

### Setup your Firebase

Signup for a free firebase account and create a new firebase for your account.
In the following code sample we will use the following as you firebase url:

+ https://www.firewater.firebaseio.com

### Adding data

```ruby
ref = Firewater::Firebase.new( 'your firebase repo url' )
```

## > Contact

Fernand Galiana

- http://github.com/derailed
- http://twitter.com/kitesurfer
- <fernand.galiana@gmail.com>

## > License

Firewater is released under the [MIT](http://opensource.org/licenses/MIT) license.