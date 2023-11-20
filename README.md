#  Recurrence Quantification Analysis is sensitive to dynamic agent coupling but not prediction strategies in joint action: An agent-based simulation.

## Abstract:
Joint action is an important aspect of everyday behavior such as conversation, and task based social behavior. It has been suggested that a distinct set of task representations, mental processes and low-level dynamics are involved in joint action coordination. In this study dyads of artificial agents that move together in two-dimensional space were programmed. The moves were made based on a prediction of the partner’s next move and response to this predicted next move using simple rules. The series of movements in each dyad was analyzed using recurrence quantification analysis replicating laboratory experiments. In contrast to previous human-based experiments it was shown that recurrence quantification analysis is not sensitive to prediction models but is sensitive to dynamic coupling. It is suggested that the RQA results obtained from these studies may be better explained by dynamic coupling rather than prediction model type.
RQA: Recurrence Quantification Analysis
MdCRQA: Multi-dimensional Cross Recurrence Quantification Analysis
MdARQA: Multi-dimensional Auto Recurrence Quantification Analysis

## Introduction:
Recurrence plots and RQA have been used to characterize the patterned behavior observed from dyads of participants during joint action (see Fusaroli & Tylen, 2016). The measures obtained from RQA have been seen to correlate to joint task performance (Fusaroli & Tylen, 2016), arousal (Konvalinka et al., 2011) and the presence of deception in the interaction (Duran & Fusaroli, 2017). However, it is unclear if RQA can identify specific types of prediction models or strategies used by the participants. 
Knoblich et al. (2011) and Vesper et al. (2010) proposed descriptions and models of joint action made up of a set of task representations, and non-represented processes such as prediction and low-level system dynamics as minimal models of joint action. The most minimal model of joint action (which is pragmatically defined to allow for implicit online goals such as dancing together fluidly or more explicit goals such as lifting a table up a flight of stairs), simply requires a representation of one’s own task and the goal, without requiring representation of a partner's task (see Vesper et al., 2010). Under this basic model the co-actor is treated as a social tool to facilitate one's own action rather than as a partner engaged in the task (see Moll and Tomasello, 2007). 
Prediction of a partner’s action and monitoring of one’s own action are processes used to facilitate joint action while not occupying separate representations in the minimal model. Although representation of a partner's task isn’t built into the minimal model, the prediction process of the partner’s actions is part of the model. Neurophysiological research suggested that these online prediction and monitoring processes in humans may be driven by a common mirroring mechanism (Wolpert et al., 1998, 2003), and could operate using predictive coding principles (Palmer and Demos, 2022). Low level dynamical coupling between agents is another aspect of joint action that isn’t explicitly built into the Vesper et al. model although it is prevalent throughout many joint action experiments, and it is treated as facilitating the other aspect of the minimal model, while not required as part of the model as it is not a representation or a mental process. 
The task that this simulation study aimed to achieve was to create artificial agents that have the representations of the minimal model required for joint action as described by Vesper et al., and also a basic capacity to predict the movements of their partner agent. These agents could also be coupled by making their movements obey a non-random frequency such as the pink noise (1/f) frequency while traveling along a trajectory or uncoupled by allowing them to follow a white noise frequency. RQA was then applied to the series produced by the dyads to test for the ability of RQA to detect different prediction processes and dynamic coupling applied to the agents.
Hypothesis 1: There will be an effect of prediction model used by the agents on the recurrence rate, determinism and entropy measures.
Hypothesis 2: There will be an increase in the recurrence rate and determinism and a decrease in entropy when the agent's movement errors follow a 1/f frequency.


## Method:
Two agents were created to follow the same movement rules as each other. Two rule conditions were used, converge and diverge. These rules were based on dividing the two-dimensional space around an agent into four quadrants, like directions on a map and moving towards or away from the partner agent using these direction quadrants. Below is an example of the rule that would run if the partner agent were (predicted to be) in a positive x positive y (north-east) direction from the agent.   
If rule == Converge
  N=1
 ELSE IF rule == Diverge
N= -1
IF X value – partner X value < 0 AND Y value – partner Y value < 0 DO
New X value = X + 1*N*Scale Value + Error value
New Y value = Y + 1*N*Scale Value + Error value
Move X = New X – X
Move Y = New Y –Y
In the white noise condition, the error value was a randomly generated number from -1 to 1, in the pink noise condition the error value was a sequence of values from -1 to 1 obeying a 1/f power law. Each trial began with 20 iterations where each agent responded to the coordinates of the partner agent in the previous iteration. From iteration 21 to 100 a predication was used to estimate where the partner agent will be in the current iteration and respond according to their movement rule to the predicted coordinates. In the prediction 1 condition linear regression was used to predict the partners coordinated using the previous 5 coordinated of the partner, while in prediction 2 the prediction was made using both the previous 5 coordinates of the partner and previous 5 coordinates of the agent preforming the prediction, again with linear regression. 50 trials were run in each rule*noise*prediction strategy condition combination (400 trials in total). (See comments in the available code for full explanation of agent parameters.)

## Results:
Multidimensional CRQA was used to analyze the alignment of the two agents. The series of changes in x and y coordinates for each agent were used as inputs. This resulted in the “alignment” RQA condition.
Multidimensional ARQA was used to analyze the alignment of the system without dividing it into agent one’s part and agent two’s part. This was achieved by interleaving the series of changes in x and y coordinates collected from the two agents to obtain a single series. This was then used as the input for the RQA analysis. This resulted in the “synergy” RQA condition.   
The embedding dimension and delay parameters were both set to 2 and the radius was set to 0.5 in both analyses described above. These parameter values were set arbitrarily under the assumption that any genuine effects of the predictor variables used in the models below would appear across many different parameter values. It is difficult to compare RQA measures of different systems if different optimized parameters are used for different systems. The reader/user is encouraged to try out different parameters in the available RQA analysis. 
 
Below the statistical models used are described along with the results summary. See the results subfolder for the model outputs in full detail. These are stored as .txt files.
A simple linear regression was first used to test the effects of noise type and prediction strategy type on the recurrence rate.
lm(RR ~ Noise Type*Prediction Type*Movement Rule + Alignment Type) (model 1)
 
Residuals plot of model 1
There was a strongly significant effect of noise type on recurrence rate (β = -14.93836, t(791) = -29.098, p <0.000, R^2 = 0.82). There was a small, nearly significant interaction effect of noise type and movement rule (β = -1.32313, t(791) = -1.822, p = 0.068, R^2 = 0.82). The prediction type, noise type – prediction type interaction, and RQA type condition effects were not significant (t(791) =0.027, t(791) = 1.48, t(791) = 0.296)).
The other RQA measures can be correlated to the recurrence rate, so mixed effects models were used to adjust for recurrence rate correlations.
lmer(DET ~ Noise Type*Prediction Type*Movement Rule + RQA Type + (1 | RR)) (model 2)
There was a significant effect of noise type (β = -21.7795, SE = 0.6760, p <0.000), of RQA type (β = -2.6882, SE = 0.3729, p <0.000), and of movement rule on determinism (β = 3.8363, SE = 0.6673, p <0.000), as well as an interaction effect of noise type and movement rule (β = -3.1844, SE = 0.9315, p <0.000). The other fixed effects were insignificant and had small betas (<0.5). 
lmer(ENT ~ Noise Type*Prediction Type*Movement Rule + RQA Type + (1 | RR)) (model 3)
There was a significant effect of noise type (β = -0.469897, SE = 0.013874, p <0.000), and of movement rule (β = 0.082045, SE = 0.013497, p <0.000) on entropy. There was also a nearly significant interaction effect of noise type and prediction type and movement rule (β = 0.037828, SE = 0.022534, p =0.0937). The other fixed effects were not significant and have betas below 0.025
lmer(LAM ~ Noise Type*Prediction Type*Movement Rule + RQA Type + (1 | RR)) (model 4)
There was a significant effect of noise type (β = -25.5713, SE = 0.9586, p <0.000), of movement rule (β = 6.5046, SE = 0.9421, p <0.000) and of RQA type (β = -4.3920, SE = 0.5351, p <0.000) on laminarity. There were also significant interaction effects of noise type and movement rule (β = -8.2625, SE = 1.3101, p <0.000) and of noise type prediction type and movement rule (β = 3.2706, SE = 1.6091, p <0.05). The other fixed effects were insignificant and had betas below 2.
lmer(MaxL ~ Noise Type*Prediction Type*Movement Rule + RQA Type + (1 | RR)) (model 5)
Model 5 failed to converge and further simplification by removing the random intercept was decided against due to the variance of the RR random effect being 3.2. 

## Conclusions and further research suggestions:
Using simple agents with identical rules and prediction capabilities, it was shown that RQA did not produce markers of prediction model choice. However, it was shown that low level coupling created by programming each agent to follow a 1/f pink noise in its movement errors resulted in a large increase in the recurrence rate, determinism and other RQA measures. This experiment has been designed in such a way that the rules that the agents follow could be changed, as well as the prediction strategies. A joint goal could be added to the simulation. Further research could involve creating more advanced rules for the agents so that different patterns of system alignment could be observed. The prediction strategies used here are not biologically informed and arguably too simple to be meaningful. Further research could use biologically feasible prediction models such as a recurrent neural network to create agent level “alignment” and system level “synergy” prediction capabilities for the agents (see Knoblich and Jordan, 2003 and Kelso... for description of synergy prediction processes). Further research should engage with the challenges and advantages of using multi-agent-based modeling for running simulations of cognition or behavior.






Fusaroli, R., & Tylén, K. (2016). Investigating conversational dynamics: Interactive alignment, interpersonal synergy, and collective task performance. Cognitive science, 40(1), 145-171.
Knoblich, G., Butterfill, S., & Sebanz, N. (2011). Psychological research on joint action: theory and data. Psychology of learning and motivation, 54, 59-101.
Malone, M., Castillo, R. D., Kloos, H., Holden, J. G., & Richardson, M. J. (2014). Dynamic structure of joint-action stimulus-response activity. PLoS One, 9(2), e89032.
Mayo, O., & Gordon, I. (2020). In and out of synchrony—Behavioral and physiological dynamics of dyadic interpersonal coordination. Psychophysiology, 57(6), e13574.
Nalepka, P., Riehm, C., Mansour, C. B., Chemero, A., & Richardson, M. J. (2015). Investigating Strategy Discovery and Coordination in a Novel Virtual Sheep Herding Game among Dyads. In CogSci.
Palmer, C., & Demos, A. P. (2022). Are We in Time? How Predictive Coding and Dynamical Systems Explain Musical Synchrony. Current Directions in Psychological Science, 31(2), 147–153.
Scheurich, R., Demos, A. P., Zamm, A. P., Mathias, B., & Palmer, C. (2019). Capturing Intra-and Inter-Brain Dynamics with Recurrence Quantification Analysis. In CogSci (pp. 2748-2754).
Vesper, C., Butterfill, S., Knoblich, G., & Sebanz, N. (2010). A minimal architecture for joint action. Neural Networks, 23(8-9), 998-1003.
