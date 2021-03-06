# General_Data_Broker
General Data Broker
----------------------------------------------------------------
We introduce a fine-grained, fully asynchronous, pipelined parallel execution model to combine large scale simulations with data-intensive analyses to accelerate scientific discovery. In the project, we build a new general analytical model to estimate the expected time-to-solution for two different user scenarios where users may or may not need to preserve the computed results. The analytical model divides a scientific discovery into multiple stages such that the total time-to-solution is as small as the time of a single stage. We also develop a new data transfer method called concurrent message-passing and file-I/O method to speed up the data transfer between computation
processes and analysis processes. By building a new multi-threaded DataBroker runtime, we are able to tightly integrate
computation with data analysis and support both preserving data and not-preserving data scenarios more effiently. The
experimental results of using 512 computation processes and 128 analysis processes demonstrate that the analytical model reflects the actual time-to-solution accurately, and the new DataBroker middleware can decrease the time-to-solution of the traditional off-line method by up to 16.5 times.
