#################################################################################
#################################################################################
########## Moving interacting Agents simulation #################################

# This script runs a simulation of joint action using agents with movement rules 
# specified by the experimenter. These agents also have predictive capabilities. 
# Each iteration each agent will move in 2 dimensional space (ie. move in an
# x direction and a y direction). This move is determined by the movement rule
# and the prediction behavior that is specified. It is necessary to run at least  
# a few iterations without using the agents prediction faculties to begin the trial.
# After there is some data points for each agent then the chosen prediction 
# behavior can kick in.
#
# The motivation behind this simulation is to test the effect of prediction
# type on joint agent movement. For example, if agent one predicts agent two's
# next move only on the previous moves of agent two and moves closer to agent two
# based on this prediction, will this be move effective than if agent one
# predicts agent two's next move based on the behavior of both agent two and agent one.
#
# Recurrence quantification analysis is also built into the experiment. This 
# will show if the different types of movement rules and prediction rules will have
# an effect on the recurrence measures output by crqa. This aims to test the
# ability of crqa to detect different rules that the agents are using.

###############################################################################

##################### Set parameters ##########################################

# iter_num : numeric (integer)
iter_num <- 100

# trial_num : numeric (integer)
# the number of times to run the simulation
trial_num <- 50

# start_predicting: numeric (integer)
# the iteration number in each trial at which the agents start using prediction
start_predicting <- 20

# difference : numeric (integer or float)
# the cut off distance between points. if the points are further than
# this distance data will not be collected
difference <- 60000

# fac : numeric (integer or float)
# the fac parameter scaled the movements on each iteration, set higher if you
# want the agents to make larger moves
fac <- 7

# k : character ("divergent", "convergent")
# the k parameter if the rule that you want the agents to followl
# choose either "divergent" if you want them to move away from each other
# or "convergent" if you want them to move towards each other
k <- "divergent"

# model_type : character ("you", "us both")
# the model_type parameter determines the prediction strategy used. In the "you"
# condition, the partners next move will be predicted on their previous moves,
# in the "us both" condition, it will be predicted using both agents previous moves.
model_type <- "you"

################################################################################
################################################################################

source(paste0(getwd(), "\\", "Experiment_Set_Up.r"))

source(paste0(getwd(), "\\", "movement_2.r"))
       
k <- "divergent"
model_type <- "us both"

source(paste0(getwd(), "\\", "movement_2.r"))

k <- "convergent"
model_type <- "you"

source(paste0(getwd(), "\\", "movement_2.r"))

k <- "convergent"
model_type <- "us both"

source(paste0(getwd(), "\\", "movement_2.r"))

