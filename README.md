# Delivery Scheduling Optimization Problem

>**Project**
><br />
>Course Unit: [Inteligência Artificial](https://sigarra.up.pt/feup/en/ucurr_geral.ficha_uc_view?pv_ocorrencia_id=520334 "Artificial Intelligence"), 3rd year 
><br />
>Course: **Informatics and Computer Engineering** 
><br />
> Faculty: **FEUP** (Faculty of Engineering of the University of Porto)
><br />
> Assigment: [project assignment](./docs/assignment/projetc_assignment.pdf) and [theme](./docs/assignment/specific_projetc_assignment.pdf)
><br />
> Presentation: [presentation.pdf](./docs/presentation/presentation#2.pdf)
><br/>
> Project evaluation: **20**/20

# Requirements to run

## Install Julia
```bash
curl -fsSL https://install.julialang.org | sh
```

# How to run
Go to src folder
```bash
cd src
```

## Install dependencies
Inside the src/ folder enter the Julia REP, install the dependencies and run the program with the following command
```bash
julia --project=. -e 'using Pkg; Pkg.instantiate(); include("app.jl")'
```
This will open a local server you can access in your browser at http://localhost:8100. The port may be different, check the output of the command.

## If you have problems with the PlotlyJS package
Enter the Julia REPL with
```bash
julia --project=.
```

Then enter the package manager by typing
```julia
] 
```
and run the following command
```julia
build PlotlyJS
```

## Run the program
```bash
include("app.jl")
```

## The program
This is a UI web-based application that allows you to solve the delivery scheduling problem using different algorithms. The user can select the algorithm to use, the problem instance to solve and the parameters of the algorithm. The program will then show the evolution of the solution and the final solution.

# About the project

## Metaheuristics for Optimization/Decision Problems

An optimization problem is characterized by the existence of a (typically large) set of possible solutions, comparable to each other, of which one or more are considered (globally) optimal solutions. 
Depending on the specific problem, an **evaluation function** allows you to establish this comparison between solutions. In many of these problems, it is virtually impossible to find the optimal solution or to ensure that the solution found is optimal, and, as such, the **goal is to try to find a locally optimal** solution that maximizes/minimizes a given evaluation function to the extent possible. 

In this work were implemented and compared different algorithms for solving optimization problems, such as:
- Hill-climbing
- Simulated annealing
- Tabu search
- Genetic algorithms

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