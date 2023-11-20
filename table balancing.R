if(!require(tidyverse)){install.packages("tidyverse")}
if(!require(plotly)){install.packages("plotly")}
library(tidyverse)
library(plotly)

iter_num <- 100


dataset <- data.frame(point_one_x = rep(10, iter_num), point_one_y = rep(0,iter_num), point_one_z = rep(10,iter_num),
                      point_two_x = rep(10, iter_num), point_two_y = rep(0, iter_num), point_two_z = rep(-10, iter_num),
                      point_three_x = rep(-10, iter_num), point_three_y = rep(0, iter_num), point_three_z = rep(10, iter_num),
                      point_four_x = rep(-10, iter_num), point_four_y = rep(0, iter_num), point_four_z = rep(-19, iter_num),
                      equation = rep("", iter_num), 
                      ball_x = rep(0, iter_num), ball_y = rep(0, iter_num), ball_z = rep(0, iter_num))

find_plane_equation <- function(point1, point2, point3){
    vector1 <- point2 - point3
    vector2 <- point3 - point1

    normal_vector <- pracma::cross(vector1, vector2)
    # Normalize the normal vector (optional but recommended)
    normal_vector <- normal_vector / sqrt(sum(normal_vector^2))

    # Calculate the constant (d) in the plane equation Ax + By + Cz + d = 0
    d <- -sum(normal_vector * point1)

    # Return the coefficients A, B, C, and d
    return(list(A = normal_vector[1], B = normal_vector[2], C = normal_vector[3], d = d))
}


# Function to find the fourth corner of the square given three corners and the plane equation
find_fourth_corner <- function(plane_equation, point1, point2, point3, point4) {
  # Extract the coefficients from the plane equation
  A <- plane_equation$A
  B <- plane_equation$B
  C <- plane_equation$C
  d <- plane_equation$d
  
  # Use the equation of the plane to find the fourth corner
  x4 <- point4[1]#(d - B * point2[2] - C * point2[3]) / A
  y4 <- (A*point4[1] +  C * point4[3] + d)/-B
  z4 <- point4[3]
  
  return(c(x4, y4, z4))
}


ball_function <- function(planeEquation, previousCoords, previousVelocity, gravity, timeStep){
  # et's break down the plane equation into its components.
  A <- planeEquation[1]
  B <- planeEquation[2]
  C <- planeEquation[3]
  d <- planeEquation[4]
  
  # Calculate the new coordinates using the previous values and gravity.
  newCoords <- previousCoords
  
  # Calculate the direction based on the normal vector of the plane.
  planeNormal <- c(A, B, C)
  newDirection <- planeNormal
  
  # Calculate the acceleration based on the gravitational force.
  accelerationMagnitude <- gravity * (A * newCoords[1] + B * newCoords[2] + C * newCoords[3] + d) / (A * A + B * B + C * C)
  newAcceleration <- -accelerationMagnitude * planeNormal
  
  # Update the velocity based on the acceleration.
  newVelocity <- previousVelocity + newAcceleration * timeStep
  # Update the position based on the velocity.
  newCoords <- previousCoords + newVelocity * timeStep
  
  # Return the new coordinates, direction, and acceleration as a list.
  return(list(coordinates = newCoords, direction = newDirection, acceleration = newAcceleration, velocity = newVelocity))
  
}


# res <- ball_function(planeEquation = c(0.00803399328420144, 0.998336264658294, -0.05709778997, -0.0912973627562852), previousCoords = c(0,0,0), previousVelocity = c(0,0,0),gravity = 9.8, timeStep = 0.1)
# res$coordinates[3]
# find_fourth_corner(plane_equation = plane_equation, point1 = plane[[1]], point2 = plane[[2]], point3 = plane[[3]], point4 =plane[[4]])

for(i in 1:iter_num){
  if(i == 1){
    Previous_Coords = c(0,0,0)
    Previous_Velocity = c(0,0,0)
  }
  dataset[i, ] <- data.frame(point_one_x = 10, point_one_y = runif(1,-1,1), point_one_z = 10,
                             point_two_x = 10, point_two_y = runif(1, -1, 1), point_two_z = -10,
                             point_three_x = -10, point_three_y = runif(1, -1, 1), point_three_z = 10,
                             point_four_x = -10, point_four_y = 0, point_four_z = -10,
                             equation = "")
  print(dataset[i, ])
  equation <- find_plane_equation(point1 = c(dataset[i, ]$point_one_x, dataset[i, ]$point_one_y, dataset[i, ]$point_one_z),
                                   point2 = c(dataset[i,]$point_two_x, dataset[i,]$point_two_y, dataset[i,]$point_two_z),
                                   point3 = c(dataset[i,]$point_three_x, dataset[i,]$point_three_y, dataset[i,]$point_three_z))
  print(equation)
  res_ <- ball_function(planeEquation = c(equation$A, equation$B, equation$C, equation$d), previousCoords = Previous_Coords, previousVelocity = Previous_Velocity, gravity = 9.8, timeStep = 0.15)
  #print(res_[[1]])
  Previous_Coords <- res_$coordinates
  Previous_Velocity <- res_$velocity
  dataset[i, 14] <- Previous_Coords[1]
  dataset[i, 15] <- Previous_Coords[2]
  dataset[i, 16] <- Previous_Coords[3]
  
  dataset[i, 13] <- paste(equation[1], equation[2], equation[3], equation[4])
  
  print(dataset[i, 13])
  dataset[i,11] <- find_fourth_corner(plane_equation = equation, point1 = c(dataset[i, ]$point_one_x, dataset[i, ]$point_one_y, dataset[i, ]$point_one_z),
                                      point2 = c(dataset[i,]$point_two_x, dataset[i,]$point_two_y, dataset[i,]$point_two_z),
                                      point3 = c(dataset[i,]$point_three_x, dataset[i,]$point_three_y, dataset[i,]$point_three_z),
                                      point4 = c(dataset[i,]$point_four_x, dataset[i,]$point_four_y, dataset[i,]$point_four_z))[2]
  print(dataset[i, 11])
}


dataset_long <- dataset
dataset_long$iter<- 1:iter_num
#dataset_long <- dataset_long[,c(1:12,14)]

dataset_long_one <- dataset_long[c(1:3, 17)]
names(dataset_long_one) <- c("pointx", "pointy", "pointz", "iter")
dataset_long_two <- dataset_long[c(4:6, 17)]
names(dataset_long_two) <- c("pointx", "pointy", "pointz", "iter")
dataset_long_three <- dataset_long[c(7:9, 17)]
names(dataset_long_three) <- c("pointx", "pointy", "pointz", "iter")
dataset_long_four <- dataset_long[c(10:12, 17)]
names(dataset_long_four) <- c("pointx", "pointy", "pointz", "iter")
dataset_ball <- dataset_long[c(14:16, 17)]
names(dataset_ball) <- c("pointx", "pointy", "pointz", "iter")

dataset_long_mod <- rbind(dataset_long_one, dataset_long_two, dataset_long_three, dataset_long_four, dataset_ball) %>% arrange(iter)

dataset_long_mod %>% plot_ly(x =~pointx,
                            y =~pointy,
                            z =~pointz,
                            frame = ~iter,
                            type = 'scatter3d',
                            MODE = "markers",
                            intensity = c(1),
                            color = c(1),
                            colors = c("grey"))%>%
  layout(yaxis = list(range = c(-5,5)))


