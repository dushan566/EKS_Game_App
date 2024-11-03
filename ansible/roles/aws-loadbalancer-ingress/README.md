Following specs should be modified in inmgress controller J2 template and pass values through ansible variables at run time.
Ref: https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html


from >
```
spec:
      containers:
        - args:
            - --cluster-name=your-cluster-name
           
```

to >
```
spec:
      containers:
        - args:
            - --cluster-name={{ cluster_name.stdout }}
```            
                    