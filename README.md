# Portal

Code from [howistart.org](https://howistart.org/posts/elixir/)

## Installation

Install dependencies:

```mix deps.get```

Compile application:

```mix compile```

Generate documentation:

```mix docs```

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc).

## Usage

Just shoot a couple of doors and you can start transfering data:

```iex
iex> Portal.shoot(:orange)
{:ok, #PID<0.192.0>}
iex> Portal.shoot(:blue)
{:ok, #PID<0.194.0>}
iex> portal = Portal.transfer(:orange, :blue, [1, 2, 3])
#Portal<
    :orange <=> :blue
  [1, 2, 3] <=> []
>
iex> Portal.push_right(portal)
#Portal<
  :orange <=> :blue
   [1, 2] <=> [3]
>
iex> Portal.push_right(portal)
#Portal<
  :orange <=> :blue
      [1] <=> [2, 3]
>
iex> Portal.push_left(portal) 
#Portal<
  :orange <=> :blue
   [1, 2] <=> [3]
>
```

---

## Acknowledgment

Thanks do José Valim for this guide, besides all the amazing work on building Elixir! 💜
