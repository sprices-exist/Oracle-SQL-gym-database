# Oracle-SQL-gym-database
Creation and benchmarking for a gym membership database, populated with realistic artificial data generated using the faker library.  Complex queries involving multiple joins, sub-queries, and groupings.

### Figure 1: Entity-Relationship diagram
![image](https://github.com/sprices-exist/Oracle-SQL-gym-database/assets/68065642/03810bcc-cf6e-4bc0-8a96-43119d755790)

Record counts after data insertion (python script)
-----------------

### Members table

SELECT COUNT(*) FROM MEMBERS;

Count  =  <mark>154446</mark>

###  Body Measurements table

SELECT COUNT(*) FROM BODYMEASUREMENTS;

Count  =  <mark>618088</mark>

### Health Records table

SELECT COUNT(*) FROM HEALTHRECORDS;

Count  =  <mark>385874</mark>

### Diet Log table

SELECT COUNT(*) FROM DIETLOG;

Count  =  <mark>541243</mark>

### Exercise Activities table

SELECT COUNT(*) FROM EXERCISEACTIVITIES;

Count  =  <mark>540255</mark>
