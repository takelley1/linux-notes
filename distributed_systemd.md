# Distributed Systems

- Strong vs Weak Consistency
  - Strong consistency = Future reads of a system are guaranteed to have the most recent write.
    - Tradeoff = Higher latency, but data is always up to date.
    - Examples = Kubernetes' etcd database, Ceph's RADOS engine
    ```
                  STRONG CONSISTENCY
    
    TIME  ------------------------------------------------>
    
    Client A:   WRITE x=10
                [---------]
                          |
                          | Write completes
                          v
    Client B:                 READ x
                              [------]
                                    |
                                    v
                                  x = 10
    
    A read started after the completed write
    cannot return the old value x = 5.
    ```
  - Weak consistency = Reads may return outdated information, but consistency is guaranteed eventually.
    - Tradeoff = Lower latency, but may return stale data.
    - Examples = Redis replicas, DNS caches, 
    ```
                  EVENTUAL CONSISTENCY
    
    TIME  ------------------------------------------------>
    
    Client A:   WRITE x=10
                [---------]
                          |
                          | Write completes
                          v
    Client B:                 READ x
                              [------]
                                    |
                                    v
                                  x = 5
                                  STALE
    
    Replication:                 .... x=10
    
    Client B:                                READ x
                                             [-----]
                                                   |
                                                   v
                                                 x = 10
    ```
