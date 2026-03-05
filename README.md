This project implements a logic-based intelligent agent in Prolog that simulates a chef responsible for constructing a burger sandwich. The system models burger assembly as a reasoning problem, where the agent determines a valid stacking order for ingredients based on logical constraints defined in a knowledge base.

The implementation follows the Situation Calculus framework, allowing the agent to reason about actions and how they change the state of the world over time. The state of the burger evolves through a sequence of actions, where each action corresponds to stacking a specific ingredient. Using logical inference, the agent searches for a sequence of actions that results in a correctly assembled burger that satisfies all ordering constraints.

The knowledge base defines relationships between ingredients using predicates. These constraints guide the agent in determining a valid stacking order while ensuring that all ingredients are included exactly once. The ordering of the ingredients in between depends on the constraints defined in the knowledge base.

The system models the world using fluents and successor state axioms (SSA). Fluents represent properties of the burger that may change across situations, such as which ingredients have been stacked or which ingredient is currently on top. Successor state axioms describe how these properties evolve after each action, enabling the agent to reason about the effects of stacking ingredients and maintain a consistent world state.

To find a valid sequence of actions, the agent queries the predicates. the implementation employs Iterative Deepening Search (IDS) using call_with_depth_limit to ensure that the reasoning process eventually finds a valid solution if one exists.

The project demonstrates how logical reasoning, knowledge representation, and search strategies can be combined to solve structured planning problems. By representing the burger assembly process using Situation Calculus and implementing the reasoning system in Prolog, the project highlights the use of symbolic AI techniques to model decision-making in constrained environments.

The implementation was developed in Prolog and tested using different knowledge bases that define varying ingredient constraints. These knowledge bases allow the agent to generate different valid burger configurations depending on the logical relationships specified
