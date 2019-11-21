       program-id. Program1 as "IndexedFile.Program1".
           
       environment division.
       input-output section.
       file-control.   select customer-trans
                       assign to "C:\a\exercise10\input1.txt"
                       organization is line sequential.

                       select customer-master
                       assign to "C:\a\exercise10\indexedmaster.txt"
                       organization is indexed
                       access mode is random
                       record key is customer-no-master.
       
       data division.
       file section.
       fd  customer-trans.
       01  customer-trans-record.
           05  customer-no-trans           picture x(5).
           05  customer-name-trans         picture x(20).
           05  date-of-purchase-trans      picture 99/99/9999.
           05  amt-of-purchase-trans       picture 9(5)v99.

       fd  customer-master.
       01  customer-master-record.
           05  customer-no-master           picture x(5).
           05  customer-name-master         picture x(20).
           05  date-of-last-purchase-master picture 99/99/9999.
           05  amt-owed-master              picture 9(5)v99.

       working-storage section.
       01  eof                             picture x value "N".

       procedure division.
       main-module.
           open i-o customer-master
                input customer-trans

           perform read-transactions until eof = "Y"

           close customer-master
                 customer-trans

           stop run.
       
       read-transactions.
           read customer-trans
               at end 
                   move "Y" to eof
               not at end
                   display "Transaction Record read"
                   perform read-master
           end-read.

       read-master.
           move customer-no-trans to customer-no-master
           read customer-master
               invalid key
                   display "Account-no: ",customer-no-trans, " is invalid."
               not invalid key
                   display "Account-no: ",customer-no-trans, " is valid." 
                   perform update-record
           end-read.
    
       update-record.

           add amt-of-purchase-trans to amt-owed-master
           move date-of-purchase-trans to date-of-last-purchase-master
           rewrite customer-master-record
               invalid key
                   display "Error on rewrite"
               not invalid key 
                   display "Record updated."
                   display ""
           end-rewrite.


       end program Program1.
