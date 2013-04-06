# Basilisk - Ruby firepower for your Firebase batteries

Firebase is a real-time backend that allows one to store key-value pairs in a hierarchical fashion, without
having to manage additional servers. Firebase offers api's for a variety of client libs such as javascript, 
REST, IOS and now Ruby ;-). A cool feature of firebase is that it allows disparate clients to broadcast updates and
sync up across the wire. Checkout http://firebase.com for the firehose...

## Requirements

- Ruby >= 1.9
- Map
- Typhoeus

## Getting Started

$ gem install basilisk

## Usage

### Setup your Firebase

Sign up for a firebase account and create a new firebase of your liking.
In the following code samples, we will use the following as our base url:

+ https://zerodarkthirty.firebaseio.com

Then you can specify an entry point into the data using the following call:

```ruby
ref = Basilisk::Load.new( 'https://zerodarkthirty.firebaseio.com' )
```

NOTE: You don't have to start a the root, but usually a good idea since this api
offers ways to traverse the hierarchy up or down. But more on this later...


### Populating firebase

Firebase supports the following data types:

+ String
+ Number
+ Boolean
+ Array
+ Hash

#### Adding primitive types

```ruby
data = {
  a: 0,
  b: %s(Hello World),
  c: 10.5
}
ref.set( data )
```

Yields:

+ a:0
+ b:"Hello World"
+ c:10.5

NOTE: Set is a destructive operation and will replace the previous content for the reference it is
called from.

Thus 

```ruby
data = {
  a: 0
}
ref.set( data )
```

Yields
+ a:0

Hence replacing the previously assigned content.


#### Adding arrays

```ruby
ref.set( %w(Hello World) )
```

Yields:

+ 0:"Hello"
+ 1:"World"


#### Adding arrays (ordered data)

The preferred method to construct lists in your firebase is to use the push operation, which
will automatically provide ordering to your list.

```ruby
ref.push( "BumbleBee" )
ref.push( "Tuna" )
```

Yields:
  
+ -IrMr3Yp1mozVNzDePKy: "BumbleBee"
+ -IrMr3cM6XjTpNebsYRh: "Tuna"

NOTE: The list indexes will be autogenerated by firebase to ensure correct ordering on retrieval.


#### Adding hashes

```ruby
data = {
  a: {
    a_1: %s(Hello World),    
    a_2: 10.5    
  },
  b: {
    b_1: 10,
    b_2: true
  }
}
ref.set( data )
```

Yields:

+ a:
  + a_1:"Hello World"
  + a_2_:10.5
+ b:
  + b_1:10
  + b_2:true
    
   
### Reading data

Fetching data in the hierarchy is done via the read operation.

```ruby
# Setup...
data = {
  a: {
    a_1: %s(Hello World),    
    a_2: 10.5    
  },
  b: {
    b_1: 10,
    b_2: true
  }
}
ref.set( data )
```

```ruby
ref.child( 'a/a_2' ).read # => 10.5
a_val = ref.child( :a ).read 
a_val.a_1    # => 'Hello World'
a_val[:a_1]  # => 'Hello World' or use hash indexing...
a_val.a_2    # => 10.5
```

### Updating data

You can use the #update on a reference to modify nodes in the hierarchy

```ruby
# Setup...
data = {
  a: {
    a_1: %s(Hello World),    
    a_2: {
      a_2_1: 10.5,
      a_2_2: "Word!"
    }   
  },
  b: {
    b_1: 10,
    b_2: true
  }
}
ref.set( data )
```

```ruby
ref.child( :a ).update( a_1:"BumbleBee Tuna" )
ref.child( 'a/a_2' ).update( a_2_2:"You bet!" )
ref.child( 'a' ).child( 'a_3' ).update( a_3_1:"You better!" )
```

Yields:

+ a
  + a_1:"BumbleBee Tuna"
  + a_2
      + a_2_1: 10.5
      + a_2_2: "You bet!"
  + a_3
      + a_3_1: "You better!"
      
Note: the last call inserts a branch new node in the hierarchy. We could have use set here as well to
perform the insert.

You can leverage #inc/#dec to increment/decrement counter like data.

IMPORTANT! Sadly Firebase currently does not offer transactions using their REST api, hence there is
no guarantees about the atomicity of read/write operations ;-(

### Deleting data

Use the #remove operation to delete nodes at any level in the hierarchy.

```ruby
# Setup...
data = {
  a: {
    a_1: %s(Hello World),    
    a_2: {
      a_2_1: 10.5,
      a_2_2: "Word!"
    }   
  },
  b: {
    b_1: 10,
    b_2: true
  }
}
ref.set( data )
ref.child( 'a/a_2/a_2_2' ).remove
ref.child( :b ).remove
```

NOTE: Calling remove on the root ref will delete the entire hierarchy.

### Traversing the data

You can traverse the hierarchy using the #child or #parent. These calls can be chained.

```ruby
data = {
  a: {
    a_1: %s(Hello World),    
    a_2: {
      a_2_1: 10.5,
      a_2_2: "Word!"
    }   
  },
  b: {
    b_1: 10,
    b_2: true
  }
}
ref.set( data )
```

```ruby
a_2_2_ref = ref.child( 'a/a_2/a_2_2' )
a_2_2_ref = ref.child( :a ).child( :a_2 ).child( :a_2_2 ) # or...
a_2_2_ref.name #=> 'a_2_2'

a_2_ref = a_2_2_ref.parent
a_2_ref.name   # => 'a_2'

a_ref = a_2_2_ref.parent.parent
a_ref.name     # => 'a'
```
      
### Priorities

Firebase provides for setting priorities on ordered list in order to affect the retrieval. By default priority is null.
Setting priority affects the retrieval as follows (See firebase web site for details!):

+ Children with no priority are retrieved first ordered lex asc by name
+ Children with number priority are next, ordered lex asc priority, name
+ Children with a non numeric priority come last, ordered lex asc priority, name

```ruby
a_ref = ref.push( {a:1, b:2} )
b_ref = ref.push( {c:1, d:2} )
a_ref.set_priority( 20 )
b_ref.set_priority( 10 ) 
a_ref.parent.read #=> {-IrNhTASqxqEpNMw8NGq: {c: 1, d: 2}, -IrNhT2vsoQ1WlgSG6op: {a: 1, b: 2} }
```

### Auth and rules

You can secure you firebase store using a secret token and grant access for permissions on the store using rules.
Please refer to the firebase docs for details.

```ruby
ref = Basilisk::Load.new( 'https://bozo.firebaseio.com', my_secret_token )
ref.set( tmp: { a: 0, b: 1 } )
ref.set_rules( 
  { '.read' => true, '.write' => false, 
     "tmp"  => { '.read' => true, '.write' => false }
  }
)
res = ref.child(:tmp).read # => { a: 0, b: 1 }
ref.set( tmp: {d:0} ) } # => Basilisk::Action::PermissionDeniedError
```

## Contact

Fernand Galiana

- http://github.com/derailed
- http://twitter.com/kitesurfer
- <fernand.galiana@gmail.com>

## License

Basilisk is released under the [MIT](http://opensource.org/licenses/MIT) license.


## History
  + 0.0.1:
    + Initial drop
  + 0.0.2:
    + Clean up and doc updates