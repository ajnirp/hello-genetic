Hello Genetic
=============

I wanted to learn how to use genetic algorithms, so I wrote this simple set of functions. All you need to run this file is the `ruby` interpreter. To run it, do

    ruby hello_genetic.rb <argument>+

in a Terminal window or in cmd.exe. The algorithm will try to evolve a bunch of random strings towards the given "target string".

Each argument must be a string consisting of only alphabetic characters and/or spaces). You can see the progress that the algorithm is making at regular intervals.

If you want an argument to contain spaces, surround it with double quotes, like so:

    ruby hello_genetic.rb "hello world"
    
because if you were to do

    ruby hello_genetic.rb hello world
    
the program would treat `hello` and `world` as separate arguments, and evolve towards them separately.
