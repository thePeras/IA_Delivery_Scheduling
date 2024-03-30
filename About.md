# About the project

## Metaheuristics for Optimization/Decision Problems

An optimization problem is characterized by the existence of a (typically large) set of possible solutions, comparable to each other, of which one or more are considered (globally) optimal solutions. 
Depending on the specific problem, an **evaluation function** allows you to establish this comparison between solutions. In many of these problems, it is virtually impossible to find the optimal solution or to ensure that the solution found is optimal, and, as such, the **goal is to try to find a locally optimal** solution that maximizes/minimizes a given evaluation function to the extent possible. 

In this work, the aim is to implement a system to solve an optimization problem, using different algorithms or meta-heuristics, such as 
- hill-climbing
- simulated annealing
- tabu search
- genetic algorithms
You may include other algorithms or variations of these.

Multiple instances of the chosen problem must be solved, and the **results obtained by each algorithm must be compared**. 
Different parameterizations of the algorithms should be tested and compared, in terms of the **average quality of the solution** obtained and the **average time spent** to obtain the solutions. 
All problems should have **different sizes/difficulties** to solve. 

The application to be developed should have an appropriate visualization in text or graphic mode, to **show the evolution of the quality of the solution** obtained along the way and the final (i.e. local optimal) solution, and to **interact with the user**. 

You should **allow the selection and parameterization of the algorithms** and the selection of the instance of the problem to be solved.

## Problem to be solved: Delivery Scheduling
Delivery scenario where packages of three types must be transported from a starting point (0, 0) to various delivery locations. Each package type incurs different costs and penalties during transportation.

### Packages types
1. Fragile packages: Have a chance of damage during transportation.
2. Normal packages: No risk of damage during transportation.
3. Urgent packages: Incur a penalty for delivery outside the expected time.


### Objective
Design an algorithm to optimize the delivery order of packages, considering the following criteria

1. Minimize Fragile Damage
2. Minimize Travel Costs
3. Adhere to Urgent Delivery Constraints:

### Constraints
1. You only have one vehicle available.
2. The delivery locations are speciﬁed by their coordinates.
3. Routes between all delivery coordinates are available.
4. The driver drives at 60km per hour and takes 0 seconds to deliver the goods.
5. The cost per km is C=0.3.

### Objective Function
Minimize the total cost, considering fragile damage, travel costs, and urgent delivery
penalties.

### Input
Package information, including type (fragile, normal, urgent) and coordinates of
delivery locations.

### Output
Optimized delivery order that minimizes the total cost.

### Evaluation criteria
- Total cost: Your algorithm should provide the deliveries at the lowest cost possible.
- Reputation: Your algorithm should ensure deliveries on time and minimize package
breaks to keep the reputation of the delivery company intact.


# Deliverables

## Checkpoint (6-12 March)

Each group must submit in Moodle a PDF format **brief presentation** (max 5 slides), which will be used in the class to analyze, together with the teacher, the progress of the work. 

The presentation should contain:

- [X] 1. Specification of the work to be performed (definition of the optimization problem to be solved)
- [X] 2. Related work with references to works found in a bibliographic search (articles, web pages, and/or source code), 
- [X] 3. Formulation of the problem as a search problem (state representation, initial state, objective test, operators (names, preconditions, effects, and costs), heuristics/evaluation function) or optimization problem (solution representation, neighborhood/mutation and crossover functions, hard constraints, evaluation functions)
- [X] 4. Implementation work already carried out (programming language, development environment, data structures, among others).


## Final (25 March)

Each group must submit in Moodle two files: 
- [ ] A PDF format **presentation** (max 10 slides) with aforementioned for the checkpoint and 
    - [ ] 5. Details on the approach (heuristics, evaluation functions, operators, ...)
    - [ ] 6. Implemented algorithms (search algorithms, minimax, metaheuristics)
    - [ ] 7. Experimental results, using appropriate tables/plots and comparing the various methods, heuristics, algorithms and respective parameterizations for different scenarios/problems.
    - [ ] 8. Conclusions slide
    - [ ] 9. A slide referencing consulted and used materials (software, websites, scientific articles, ...).
- [ ] 10. The implemented **code**
    - Properly commented
    - Including a “readme” file with instructions on how to compile, run, and use the program. 

Based on the submitted presentation, the students must carry out a demonstration (about 10 minutes) of the work, in the practical class, or in another period to be designated by the teachers of the course.


# Roadmap 

1. [X] Formular o problema e especificar os algoritmos a serem implementados.
2. [X] Dar setup às estruturas de dados e ambiente de desenvolvimento.
2. [X] Hill-climbing
3. [X] Simulated annealing
4. [X] Tabu search
5. [X] Genetic algorithms
6. [ ] Implement UI
7. [ ] Write README.md
8. [ ] Write final presentation