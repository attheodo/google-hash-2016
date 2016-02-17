# Deliver
### Description
Deliver is a pure Swift solver for the Google Hash Code 2016 challenge (see `/specs`). In
order to run you'll need to open the XCode project and change the `inputFile` paths on the top of `main.swift` file. Make sure that you run the simulations with the `Release` configuration so that compiler optimizations will kick in.

### Example output

![Screenshot](https://github.com/attheodo/google-hash-2016/blob/master/screenshot/screenshot.png)

### Key Concepts
- Each warehouse becomes a `ServiceCluster`. `ServiceClusters` are assigned to fulfill the orders that are nearest to it's warehouse. The are as many `ServiceClusters` as warehouses in each simulation. The simulation starts with the cluster that has been assigned with the most orders.
- Before the simulation starts, for each cluster, the `surplus` and `deficit` products are calculated by the `ServiceCluster.calculateStock()` method. Essentially it finds which kind of products the cluster is missing to fulfill its orders (deficit) and how many products we have and we can spare to other clusters.
- The simulation starts by assigning a certain percentage of the total drones as `deliveryDrones` whereas the rest become `supplyDrones`. `deliveryDrones` are responsible for delivering products to orders and `supplyDrones` are responsible for covering cluster deficits from other clusters' surplus. For every turn we cover some part of the service cluster's deficit and then we start deliveries for orders. We also make sure to allocate more `supplyDrones` to `deliveryDrones` if needed and vice versa. The number of `supplyDrones` and `deliveryDrones` is constantly changing according to the simulation requirements.
- `supplyDrones` always find the nearest cluster with the required product and product quantity in order to cover the ordering cluster's deficit.
- The algorithm always chooses the nearest `supplyDrones` and `deliveryDrones` to the cluster that is about to be served.

### Room for improvement
- Currently the algorithm doesn't utilize the drone's maximum payload in order to deliver to more that one orders after take-off from the service cluster. This wastes quite a lot of turns. Ideally, each `deliveryDrone` should load the maximum quantity it can hold for a product and empty it's inventory by delivering to other orders in the same service cluster before landing to the service cluster for reload.
