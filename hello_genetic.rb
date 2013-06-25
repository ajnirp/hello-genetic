class String
  def to_a
    self.split ''
  end

  def zip(other)
    self.to_a.zip(other.to_a)
  end
end

class HelloGenetic
  # population_size should be a multiple of 3
	def initialize(sample_space, population_size, target)
    @population = []
    @target = target
    @sample_space = sample_space
    population_size.times do
      member = ''
      @target.size.times { member << sample_space.sample }
      @population << member
    end
  end

  def fitness(member)
    fitness = 0
    @target.zip(member).each do |var|
      first, last = var
      if first == ' ' and first == last
        fitness += 30
      elsif first == last
        fitness += 20
      elsif first.downcase == last.downcase
        fitness += 7
      elsif (first.ord - last.ord).abs == 1
        fitness += 5
      end
    end
    return fitness
  end

  def alternating_crossover(member1, member2)
    result, index = '', 0
    member1.size.times do
      if index.even?
        result << member1[index]
      elsif index.odd?
        result << member2[index]
      end
      index += 1
    end
    return result
  end

  # Generate a child according to the following rule:
  # One block from the first parent, another block from the second
  def one_block_crossover(member1, member2, block_length)
    size = member1.size
    return member1[0...block_length] + member2[block_length..size]
  end

  # Change one randomly chosen character
  # in the string to something else
  def mutate(member)
    member[rand(member.size)] = @sample_space.sample
    return member
  end

  # Mutate each member of the population with a certain probability
  def mutate_population(probability)
    @population.map! do |member|
      if rand < probability then mutate(member)
      else member
      end
    end
  end

  # Sort the population so that the
  # weakest members are at the right end
  def sort_by_weakest_last
    @population.sort_by! { |member| -1*fitness(member) }
  end

  # Kill off the weakest members of the population where
  # "weakest" is in the sense of the given fitness function
  def remove_weakest
    sort_by_weakest_last
    to_remove = @population.size / 3
    to_remove.times { @population.pop }
  end

  # You breed
  # like raaaaaaaats
  def breed_like_rats
    index = 0
    while index < @population.size / 2 do
      # elitism: the fit breed with each other
      # the less fit breed with each other
      breed(index, index+1)
      index += 2
    end
  end

  # Breeds the members at indices i and j of the population
  # That is, generates a new child and adds it to the population
  def breed(i, j)
    @population << alternating_crossover(@population[i], @population[j])
  end

  # Mutate the population, kill off the weakest members
  # Then breed to restore the population size
  # like raaaaats
  def run
    mutate_population(0.1)
    remove_weakest
    breed_like_rats
  end

  # Returns the fittest member of the population
  def fittest
    fittest, index, size = 0, 0, @population.size
    while index < size
      if fitness(@population[index]) > fitness(@population[fittest])
        fittest = index
      end
      index += 1
    end
    @population[fittest]
  end
end

def main(step_size)
  sample_space = ('a'..'z').to_a + ('A'..'Z').to_a + [' ']

  ARGV.each do |target|
    a = HelloGenetic.new(sample_space, 300, target)
    puts "Evolving towards #{target}..."
    3000.times do |iter|
      a.run
      if (iter+1) % step_size == 0
        puts "Iteration #{iter+1} best: #{a.fittest}"
      end
    end
    puts "="*10
  end
end

main(250)