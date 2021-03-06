Generate Prime Numbers

Problem Statement:
Find the primes in the first n positive integers.

Problem Domain Analysis:
A prime number is a positive integer that is exactly divisible only by 1 and itself. 
The first few primes are:

2,3,5,7,11,13,17,19,23,29,31,37
All primes apart from 2 are odd.

Solution Domain Analysis:
Example 1
Let's check if 13 is a prime. If the number we are testing is prime it will have 
no exact divisors other than 1 and itself. 
To determine if 13 is prime, we need to divide it in turn by the set of numbers

2,3,4,5,.....12
If any of these numbers divide into 13 without remainder, we will know it cannot be prime. 
This requires 11 calls to mod function. This is very inefficient. Let's look at a different approach.

Example 2
Let's look at an example problem. 
If n = 37, we don't need to test all of the numbers 3 through 36 to determine whether n is prime. 
Instead, we can test only the numbers between 2 and sqrt(37), 
rounded up. sqrt(37) = 6.08 - we'll round up to 7.

37 is not evenly divisible by 3, 4, 5, 6, and 7, so we can say confidently that it is prime. 
You can check it in the irb:

$irb
> 37 % 2
 => 1 
> 37 % 3
 => 1 
> 37 % 4
 => 1 
> 37 % 5
 => 2 
> 37 % 6
 => 1 
> 37 % 7
 => 2 
We did not get 0 as the remainder, so it is not evenly divisible by any of 
the numbers from 3,4,5,6, and 7. 
To double check our solution, we can check if a number is prime in Ruby. 
Go to irb :

          > require 'prime'
           => true
          > Prime.prime?(37)
           => true
Steps:

Step 1
Let's write our first test. 
We know we have to generate a list of divisors before we can check if the given number 
is prime or not by using 
the modulo operator. 
The first spec in findprimespec.rb will be something like:

      describe FindPrime do
        it 'should generate a list of divisors for the given number' do
         # 1. Given a number 37
         # 2. I expect the list of divisors to be [2,3,4,5,6,7]

        end
      end
      
Step 2
This is tough for a first test. 
Can we simplify this even further? How about we find the upper number? 
Change the first spec as follows:

    describe FindPrime do
      it 'should find the upper factor to test the prime' do
        find_prime = FindPrime.new(37)

        upper_factor = find_prime.upper_factor
        expect(upper_factor).to eq(7)
      end
    end
    
This is testing the implementation. We will come back to this issue later.

Step 3

      class FindPrime
        def initialize(n)
          @n = n
        end

        def upper_factor
          Math.sqrt(@n)  
        end
      end
      
This fails with the error message 'expected 7 got 6.08'.

Step 4
Change the upper_factor method as follows:

      def upper_factor
        Math.sqrt(@n).ceil  
      end
      
The test now passes.

Step 5
Now we are ready to tackle what we had in Step 1:

describe FindPrime do
  it 'should generate a list of divisors for the given number' do
   # 1. Given a number 37
   # 2. I expect the list of divisors to be [2,3,4,5,6,7]

  end
end
The above spec now becomes the second spec as follows:

      describe FindPrime do
        it 'should generate a list of divisors for the given number' do
          find_prime = FindPrime.new(37)

          divisors_list = find_prime.divisors_list
          expect(divisors_list).to eq([2,3,4,5,6,7])
        end
      end
Step 6
Add the divisors_list method to FindPrime class as follows:

          class FindPrime
            def initialize(n)
              @n = n
            end

            def upper_factor
              Math.sqrt(@n).ceil  
            end

            def divisors_list
              (2..upper_factor).to_a
            end
          end
The test now passes.

Step 7
Let's add the third spec as follows:

it 'should return true given a number input of 37' do
  find_prime = FindPrime.new(37)

  is_prime = find_prime.prime?
  expect(is_prime).to eq(true)
end
Step 8
Based on what we learned in the solution domain analysis section,
we can now add the prime? method 
to the FindPrime class as follows:

# 1. Get the list of factors to use for the modulo check
# 2. Find the modulo using the first number
# 3. Repeat modulo for all numbers
# 4. If all the numbers' modulo returns remainder, then return true otherwise false
      def prime?
        divisors_list.each do |e|
          remainder = @n % e
           return false if remainder == 0
        end
        return true
      end
Step 9
Hide the divisors_list method by making it private. 
So the following test is not required because the method is now private and
it gets indirectly tested.

          it 'should generate a list of divisors for the given number' do
            find_prime = FindPrime.new(37)

            divisors_list = find_prime.divisors_list
            expect(divisors_list).to eq([2,3,4,5,6,7])
          end
          
Delete that test. Now the entire listing looks like this:

              class FindPrime
                def initialize(n)
                  @n = n
                end

                def prime?
                  divisors_list.each do |e|
                    remainder = @n % e
                     return false if remainder == 0
                  end
                  return true
                end

                def upper_factor
                  Math.sqrt(@n).ceil  
                end

                private

                def divisors_list
                  (2..upper_factor).to_a
                end
              end

              describe FindPrime do
                it 'should find the upper factor to test the prime' do
                  find_prime = FindPrime.new(37)

                  upper_factor = find_prime.upper_factor
                  expect(upper_factor).to eq(7)
                end

                it 'should return true given a number input of 37' do
                  find_prime = FindPrime.new(37)

                  is_prime = find_prime.prime?
                  expect(is_prime).to eq(true)
                end

              end
              
Step 10
We can do the same to the upper_factor method. The listing now looks like this:

class FindPrime
  def initialize(n)
    @n = n
  end

  def prime?
    divisors_list.each do |e|
      remainder = @n % e
       return false if remainder == 0
    end
    return true
  end

  private

  def divisors_list
    (2..upper_factor).to_a
  end

  def upper_factor
    Math.sqrt(@n).ceil  
  end

end

describe FindPrime do

  it 'should return true given a number input of 37' do
    find_prime = FindPrime.new(37)

    is_prime = find_prime.prime?
    expect(is_prime).to eq(true)
  end

end
The first two tests we wrote is like scaffold of a building.
  Once the building construction is done, scaffold goes away.

Step 11
Let's get rid of the magic number 2 by making it a constant. 
The FindPrime now looks like this:

class FindPrime
  LOWER_BOUND = 2

  def initialize(n)
    @n = n
  end

  def prime?
    divisors_list.each do |e|
      remainder = @n % e
       return false if remainder == 0
    end
    return true
  end

  private

  def divisors_list
    (LOWER_BOUND..upper_factor).to_a
  end

  def upper_factor
    Math.sqrt(@n).ceil  
  end

end
Summary
In this article we saw how the tests that test the implementation eventually is deleted. 
We hide the implementation details by making it private to the class. 
Sometimes, you will have many private methods that operates on the same 
set of data and might be hiding an abstraction. In such cases, you can extract the functionality 
in the private methods into it's own class that can be tested separately.
