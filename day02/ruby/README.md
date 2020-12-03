# Day 2
The [original solution](https://github.com/merrington/aoc2020/commit/38871e0076adada2e9698d4787662035d4ff8f79) was built for Ruby 2.7 and simply iterates over every line in the input synchronously.
Current `main` was re-implemented using the preview of Ruby 3 and `Ractors`, where each line is processed in a new `Ractor`. When they complete the answer on if the password is valid is taken from the `Ractor` and counted.

## Benchmark 1
### Ruby 2.7
```shell
❯ hyperfine 'ruby day02.rb'
Benchmark #1: ruby day02.rb
  Time (mean ± σ):      1.123 s ±  0.216 s    [User: 612.4 ms, System: 417.1 ms]
  Range (min … max):    0.848 s …  1.496 s    10 runs
```

### Ruby 3.0 Preview
```shell
❯ hyperfine 'ruby day02.rb'
Benchmark #1: ruby day02.rb
  Time (mean ± σ):     417.8 ms ±  64.6 ms    [User: 231.0 ms, System: 206.6 ms]
  Range (min … max):   344.9 ms … 508.5 ms    10 runs
```

### Ruby 3.0 Preview with Ractors
```shell
❯ hyperfine 'ruby day02.rb'
Benchmark #1: ruby day02.rb
  Time (mean ± σ):     457.9 ms ±  45.2 ms    [User: 295.0 ms, System: 217.9 ms]
  Range (min … max):   398.6 ms … 530.7 ms    10 runs
```

### Benchmark 1 Summary
| Ruby Version | Time |
|-|-|
| Ruby 2.7 | 1.123s |
| Ruby 3.0 Preview | 417.8ms |
| Ruby 3.0 Preview, with Ractors | 457.9ms |


## Benchmark 2 - Larger dataset
- 50,000 line file

### Ruby 3.0 Preview
```shell
  Time (mean ± σ):     151.682 s ± 14.024 s    [User: 145.186 s, System: 5.242 s]
  Range (min … max):   137.786 s … 187.589 s    10 runs
```

### Ruby 3.0 Preview with Ractors
```shell
❯ hyperfine 'ruby day02.rb "../input_large.txt"'
Benchmark #1: ruby day02.rb "../input_large.txt"
  Time (mean ± σ):      3.803 s ±  0.694 s    [User: 3.958 s, System: 1.797 s]
  Range (min … max):    3.210 s …  5.230 s    10 runs
```

### Benchmark 2 Summary
| Ruby Version | Time |
|-|-|
| Ruby 2.7 | N/A |
| Ruby 3.0 Preview | 151.682s |
| Ruby 3.0 Preview, with Ractors | 3.803s |
